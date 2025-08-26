//
//  ReminderListViewModel.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//


import Foundation
import RealmSwift

class ReminderListViewModel {

    var onChange: (() -> Void)?

    var realmResults: Results<Reminder>!
    var reminders: [Reminder] = []
    var currentQuery: String = ""
    var isAscending: Bool = true

    init() {
        realmResults = ReminderRealmManager.shared.getAll()
        loadReminders()
    }

    func loadReminders() {
        performSearch(currentQuery)
    }

    func performSearch(_ query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentQuery.isEmpty {
            reminders = Array(realmResults)
        } else {
            let filtered = realmResults.filter("title CONTAINS[cd] %@", currentQuery)
            reminders = Array(filtered)
        }
        onChange?()
    }

    func sort() {
        isAscending.toggle()
        realmResults = ReminderRealmManager.shared.getAll().sorted(byKeyPath: "createdAt", ascending: isAscending)
        loadReminders()
    }

    func addNewReminder() -> Reminder {
        let temp = Reminder()
        temp.createdAt = Date()
        temp.dueDate = Date() // mặc định Today
        reminders.append(temp)
        onChange?()
        return temp
    }

    func delete(_ reminder: Reminder) {
        ReminderRealmManager.shared.delete(reminder)
        performSearch(currentQuery)
    }

    func commitEdit(_ reminder: Reminder, title: String, description: String, dueDate: Date?) {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDesc  = description.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanTitle.isEmpty {
            ReminderRealmManager.shared.delete(reminder)
        } else {
            if reminder.realm == nil {
                ReminderRealmManager.shared.add(reminder)
            }
            ReminderRealmManager.shared.update {
                reminder.title = cleanTitle
                reminder.descriptions = cleanDesc
                reminder.dueDate = dueDate // nil nếu tắt switch
            }
        }
        performSearch(currentQuery) // refresh list + section
    }

    func isInToday(_ date: Date?) -> Bool {
        guard let d = date else { return true }
        return Calendar.current.isDateInToday(d)
    }

    func remindersFor(_ section: Int) -> [Reminder] {
        if section == 0 {
            return reminders.filter { isInToday($0.dueDate) }
        } else {
            return reminders.filter {
                guard let d = $0.dueDate else { return false }
                return !Calendar.current.isDateInToday(d)
            }
        }
    }

    func indexPath(of reminder: Reminder) -> IndexPath? {
        let section = isInToday(reminder.dueDate) ? 0 : 1
        let list = remindersFor(section)
        guard let row = list.firstIndex(of: reminder) else { return nil }
        return IndexPath(row: row, section: section)
    }

    func headerTitle(for section: Int) -> String? {
        let count = remindersFor(section).count
        if count == 0 { return nil }
        return section == 0 ? "Today" : "Upcoming"
    }

    var isEmpty: Bool {
        reminders.isEmpty
    }
}

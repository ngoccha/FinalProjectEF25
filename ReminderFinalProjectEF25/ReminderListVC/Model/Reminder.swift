//
//  Reminder.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 25/8/25.
//


import RealmSwift

class Reminder: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var title = ""
    @Persisted var descriptions: String? = nil
    @Persisted var dueDate: Date? = nil
    @Persisted var tag: String? = nil
    @Persisted var isDone = false
    @Persisted var createdAt = Date()
    @Persisted var updatedAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

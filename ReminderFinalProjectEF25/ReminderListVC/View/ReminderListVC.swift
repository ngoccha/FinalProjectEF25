//
//  ReminderListVC.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/25/25.
//

import UIKit
import RealmSwift
import Combine

class ReminderListVC: UIViewController {
    
    
    @IBOutlet weak var noReminderView: UIView!
    @IBOutlet weak var reminderListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = ReminderListViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminders"
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(sort)
        )
        navigationItem.rightBarButtonItem?.tintColor = .accent
        
        reminderListTableView.register(UINib(nibName: "ReminderCell", bundle: nil), forCellReuseIdentifier: "ReminderCell")
        reminderListTableView.delegate = self
        reminderListTableView.dataSource = self
        
        searchBar.delegate = self
        viewModel.onChange = { [weak self] in
            guard let self = self else { return }
            self.noReminderView.isHidden = !self.viewModel.isEmpty
            self.reminderListTableView.reloadData()
        }
        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.viewModel.performSearch(text)
            }
            .store(in: &cancellables)
        
        viewModel.loadReminders()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    @IBAction func addNewReminderButton(_ sender: Any) {
        if !(searchBar.text ?? "").isEmpty {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            viewModel.performSearch("")
        }
        
        let tempReminder = viewModel.addNewReminder()
        if let indexPath = viewModel.indexPath(of: tempReminder) {
            reminderListTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            if let cell = reminderListTableView.cellForRow(at: indexPath) as? ReminderCell {
                cell.startEditing()
            }
        }
    }
    
    
    func debounceSearch() {
        searchTextSubject.send(viewModel.currentQuery)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sort() {
        viewModel.sort()
    }
}

extension ReminderListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = remindersFor(section).count
        if count == 0 { return nil }
        return section == 0 ? "Today" : "Upcoming"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersFor(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = remindersFor(indexPath.section)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        
        cell.configCell(with: reminder)
        
        cell.onDelete = { [weak self] r in
            self?.viewModel.delete(r)
        }
        
        cell.onEditingFinished = { [weak self] r, t, d in
            self?.viewModel.commitEdit(r, title: t, description: d, dueDate: r.dueDate)
        }
        
        cell.onInfo = { [weak self] reminder in
            guard let self = self else { return }
            let infoVC = AddNewReminderVC()
            infoVC.reminder = reminder
            infoVC.onDone = { [weak self] rem, title, desc, due in
                self?.viewModel.commitEdit(rem, title: title, description: desc, dueDate: due)
            }
            
            let nav = UINavigationController(rootViewController: infoVC)
            self.present(nav, animated: true)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { completion(false); return }
            let reminder = self.viewModel.remindersFor(indexPath.section)[indexPath.row]
            self.viewModel.delete(reminder)
            self.viewModel.performSearch(self.viewModel.currentQuery)
            completion(true)
        }
        
        deleteAction.backgroundColor = .primary
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
}

extension ReminderListVC {
    func isInToday(_ date: Date?) -> Bool {
        return viewModel.isInToday(date)
    }
    
    func remindersFor(_ section: Int) -> [Reminder] {
        return viewModel.remindersFor(section)
    }
    
    func indexPath(of reminder: Reminder) -> IndexPath? {
        return viewModel.indexPath(of: reminder)
    }
}


extension ReminderListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.currentQuery = searchText
        debounceSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { view.endEditing(true) }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.performSearch("")
        view.endEditing(true)
    }
}


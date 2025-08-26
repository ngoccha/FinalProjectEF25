//
//  AddNewReminderVC.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/25/25.
//

import UIKit

class AddNewReminderVC: UIViewController {
    
    
    @IBOutlet weak var firstSectionStackView: UIStackView!
    @IBOutlet weak var secondSectionStackView: UIStackView!
    @IBOutlet weak var thirdSectionStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var isHaveDueDateSwitch: UISwitch!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var reminder: Reminder!
    var onDone: ((Reminder, String, String, Date?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Reminder"
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .accent
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem?.tintColor = .accent
        
        firstSectionStackView.layer.cornerRadius = 12
        secondSectionStackView.layer.cornerRadius = 12
        thirdSectionStackView.layer.cornerRadius = 12
        titleView.layer.cornerRadius = 12
        descriptionView.layer.cornerRadius = 12
        
        dueDatePicker.datePickerMode = .date
        let startToday = Calendar.current.startOfDay(for: Date())
        dueDatePicker.minimumDate = startToday
        
        titleTextField.text = reminder.title
        descriptionTextField.text = reminder.descriptions
        
        if let d = reminder.dueDate {
            isHaveDueDateSwitch.isOn = true
            dateStackView.isHidden = false
            dueDatePicker.date = max(d, Date())
        } else {
            isHaveDueDateSwitch.isOn = false
            dateStackView.isHidden = true
            dueDatePicker.date = Date()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        dateStackView.isHidden = !isHaveDueDateSwitch.isOn
        
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        dateStackView.isHidden = !sender.isOn
        if sender.isOn, dueDatePicker.date < Date() {
            dueDatePicker.date = Date()
        }
    }
    
    
    @IBAction func goToTagButton(_ sender: Any) {
        let tagVC = TagVC()
        let nav = UINavigationController(rootViewController: tagVC)
        self.present(nav, animated: true)
        
    }
    func validate(title: String, description: String, dueDate: Date?) -> String? {
        if title.isEmpty { return "Title must not be empty." }
        if title.count > 50 { return "Title must be < 51 characters." }
        if description.count > 150 { return "Description must be < 151 characters." }
        if let d = dueDate {
            let startPicked = Calendar.current.startOfDay(for: d)
            let startToday  = Calendar.current.startOfDay(for: Date())
            if startPicked < startToday { return "Due date must be today or later." }
        }
        return nil
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done() {
        let title = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let desc  = (descriptionTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let due: Date? = isHaveDueDateSwitch.isOn ? dueDatePicker.date : nil
        
        if let err = validate(title: title, description: desc, dueDate: due) {
            showAlert(message: err)
            return
        }
        
        onDone?(reminder, title, desc, due)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}

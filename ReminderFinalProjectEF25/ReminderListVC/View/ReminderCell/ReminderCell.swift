//
//  ReminderCell.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//

import UIKit

class ReminderCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var reminderTitleTextField: UITextField!
    @IBOutlet weak var reminderDescriptionTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    @IBOutlet weak var infoButtonOutlet: UIButton!
    
    private var reminder: Reminder?
    var onDelete: ((Reminder) -> Void)?
    var onEditingFinished: ((Reminder, String, String) -> Void)?
    var onInfo: ((Reminder) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoButtonOutlet.isHidden = true
        
        reminderTitleTextField.delegate = self
        reminderDescriptionTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        guard let reminder = reminder else { return }
        onDelete?(reminder)
    }
    
    
    @IBAction func infoButton(_ sender: Any) {
        guard let reminder = reminder else { return }
        onInfo?(reminder)
    }
    
    func configCell(with reminder: Reminder) {
        self.reminder = reminder
        reminderTitleTextField.text = reminder.title
        reminderDescriptionTextField.text = reminder.descriptions
    }
    
    func startEditing() {
        reminderTitleTextField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        infoButtonOutlet.isHidden = false
    }
    
    func finishEditing() {
        guard let reminder = reminder else { return }
        
        let title = reminderTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = reminderDescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        onEditingFinished?(reminder, title, description)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        finishEditing()
        infoButtonOutlet.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

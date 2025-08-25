//
//  AddNewReminderVC.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/25/25.
//

import UIKit

class AddNewReminderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Reminder"
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .accent
        
    }

    @objc func cancel() {
        dismiss(animated: true)
    }

}

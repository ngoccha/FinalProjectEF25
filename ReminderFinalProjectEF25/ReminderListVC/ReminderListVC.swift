//
//  ReminderListVC.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/25/25.
//

import UIKit

class ReminderListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reminders"
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sort))
        navigationItem.rightBarButtonItem?.tintColor = .accent
    }


    @IBAction func addNewReminderButton(_ sender: Any) {
        let vc1 = AddNewReminderVC()
        let navivc = UINavigationController(rootViewController: vc1)
        self.present(navivc, animated: true)
    }
    
    @objc func sort() {
        print("sth")
    }

}

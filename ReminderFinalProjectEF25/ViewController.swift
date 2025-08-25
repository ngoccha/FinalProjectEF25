//
//  ViewController.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/25/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        let vc = ReminderListVC()
        let naviVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = naviVC
    }


}


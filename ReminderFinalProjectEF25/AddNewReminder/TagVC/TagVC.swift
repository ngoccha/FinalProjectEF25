//
//  TagVC.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//

import UIKit

class TagVC: UIViewController {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    let tags = ["Học tập", "Công việc", "Thói quen", "Sức khoẻ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tags"
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .accent
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .accent
        
        tagCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.allowsMultipleSelection = true
        
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done() {
        //
        dismiss(animated: true)
    }
}

extension TagVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        return cell
    }
}

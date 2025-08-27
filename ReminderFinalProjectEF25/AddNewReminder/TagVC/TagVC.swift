//
//  TagVC.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//

import UIKit

class TagVC: UIViewController {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
        
    var preselectedTags: Set<Tag> = []
    var onSelectTags: ((Set<Tag>) -> Void)?
    private var currentTags: Set<Tag> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tags"
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .accent
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem?.tintColor = .accent
        
        tagCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.allowsMultipleSelection = true
        tagCollectionView.layer.cornerRadius = 16

        currentTags = preselectedTags
        
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done() {
        onSelectTags?(currentTags)
        dismiss(animated: true)
    }
}

extension TagVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = Tag.allCases[indexPath.item]
        cell.configTitle(tag: tag)
        cell.isSelected = currentTags.contains(tag)
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTags.insert(Tag.allCases[indexPath.item])
    }

    func collectionView(_ cv: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        currentTags.remove(Tag.allCases[indexPath.item])
    }
}

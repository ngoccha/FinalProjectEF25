//
//  TagCell.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    private var currentTag: Tag?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                tagView.backgroundColor = currentTag?.color
            } else {
                tagView.backgroundColor = .neutral3
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagView.layer.cornerRadius = 8
    }
    
    func configTitle(tag: Tag) {
        currentTag = tag
        tagLabel.text = tag.rawValue
    }

}

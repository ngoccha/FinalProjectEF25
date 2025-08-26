//
//  TagCell.swift
//  ReminderFinalProjectEF25
//
//  Created by Ngoc Ha on 26/8/25.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, selected: Bool) {
           tagLabel.text = title
    }
}

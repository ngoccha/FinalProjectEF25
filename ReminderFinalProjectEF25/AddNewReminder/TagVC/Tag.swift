//
//  Tag.swift
//  ReminderFinalProjectEF25
//
//  Created by iKame Elite Fresher 2025 on 8/27/25.
//

import Foundation
import UIKit

enum Tag: String, CaseIterable {
    case study = "Học tập"
    case work = "Công việc"
    case habit = "Thói quen"
    case health = "Sức khoẻ"
    
    var color: UIColor {
        switch self {
        case .study:
            return .accent
        case .work:
            return .warning
        case .habit:
            return .low
        case .health:
            return .primary
        }
    }
}

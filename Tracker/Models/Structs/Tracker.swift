//
//  Tracker.swift
//  Tracker
//
//  Created by Konstantin on 10.07.2024.
//

import UIKit

struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay?]?
    let createdDate: Date
}

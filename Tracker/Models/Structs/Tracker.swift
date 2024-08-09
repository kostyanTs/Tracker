//
//  Tracker.swift
//  Tracker
//
//  Created by Konstantin on 10.07.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay?]?
}

//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Konstantin on 10.07.2024.
//

import Foundation

struct TrackerCategory {
    let title: String
    var trackers: [Tracker]
    
    mutating func changeTrackers(newValue: [Tracker]) {
        self.trackers = newValue
    }
}



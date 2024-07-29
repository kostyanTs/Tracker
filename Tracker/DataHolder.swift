//
//  File.swift
//  Tracker
//
//  Created by Konstantin on 18.07.2024.
//

import UIKit

// временный класс для хранения данных
class DataHolder {
    
    static let shared = DataHolder()
    
    var counterForId: UInt = 0
    
    var categories: [TrackerCategory]? 
    var complitedTrackers: [TrackerRecord]?
    
    var categoryForIndexPath: String?
    var scheduleForIndexPath: [WeekDay?]?
    var emojiForIndexPath: String?
    var colorForIndexPath: UIColor?
    
    private init() {}
}

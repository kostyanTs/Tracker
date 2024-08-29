//
//  File.swift
//  Tracker
//
//  Created by Konstantin on 18.07.2024.
//

import UIKit

// класс для хранения временных данных
final class DataHolder {
    
    static let shared = DataHolder()
  
    var categoryForIndexPath: String?
    var scheduleForIndexPath: [WeekDay?]?
    var emojiForIndexPath: String?
    var colorForIndexPath: UIColor?
    
    var filter: String?
    
    private init() {}

    func deleteValuesForIndexPath() {
        categoryForIndexPath = nil
        colorForIndexPath = nil
        emojiForIndexPath = nil
        scheduleForIndexPath = nil
    }
    
    func deleteCategoryForIndexPath() {
        categoryForIndexPath = nil
    }
}

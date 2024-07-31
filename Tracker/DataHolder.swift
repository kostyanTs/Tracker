//
//  File.swift
//  Tracker
//
//  Created by Konstantin on 18.07.2024.
//

import UIKit

// временный класс для хранения данных
final class DataHolder {
    
    static let shared = DataHolder()
    
    var counterForId: UInt = .zero
    
    var categories: [TrackerCategory]? 
    var complitedTrackers: [TrackerRecord]?
    
    var categoryForIndexPath: String?
    var scheduleForIndexPath: [WeekDay?]?
    var emojiForIndexPath: String?
    var colorForIndexPath: UIColor?
    
    private init() {}
    
    func addTrackerToCategories(tracker: Tracker, titleCategory: String?) {
        guard let categories = categories else { return }
        for i in 0..<categories.count {
            if self.categories?[i].title == titleCategory {
                guard let titleCategory = titleCategory else { return }
                if self.categories?[i].trackers == nil {
                    let newCategory = TrackerCategory(title: titleCategory, trackers: [tracker])
                    self.categories?.remove(at: i)
                    self.categories?.append(newCategory)
                } else {
                    var trackers = self.categories?[i].trackers
                    trackers?.append(tracker)
                    guard let trackers = trackers else { return }
                    let newCategory = TrackerCategory(title: titleCategory, trackers: trackers)
                    self.categories?.remove(at: i)
                    self.categories?.append(newCategory)
                }
            }
        }
    }
    
    func deleteValuesForIndexPath() {
        categoryForIndexPath = nil
        colorForIndexPath = nil
        emojiForIndexPath = nil
        scheduleForIndexPath = nil
    }
}

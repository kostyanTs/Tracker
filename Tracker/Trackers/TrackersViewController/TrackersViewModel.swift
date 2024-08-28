//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Konstantin on 17.08.2024.
//

import Foundation

final class TrackersViewModel {
    
    private let dataHolder = DataHolder.shared
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var currentDate: Date?
    private(set) var complitedTrackers: [TrackerRecord]?
    private(set) var visibleCategories: [TrackerCategory]?
    private(set) var categories: [TrackerCategory]? = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[TrackerCategory]?>?
    
    init() {
        self.categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: currentDate?.getWeekday()
        )
    }
    
    func setupComplitedTrackers() {
        self.complitedTrackers = trackerRecordStore.loadTrackerRecords()
    }
    
    func filterComplitedTrackers(trackerId: UUID) -> [TrackerRecord] {
        complitedTrackers?.filter{$0.id.hashValue == trackerId.hashValue} ?? []
    }
    
    func trackerIsDone(trackerRecord: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func trackerIsNotDone(trackerRecord: TrackerRecord) {
        trackerRecordStore.addNewTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func didTapPlusTrackerButton(trackerId: UUID) {
        setupComplitedTrackers()
        filterComplitedTrackers(trackerId: trackerId)
    }
    
    func setupCategories(currentDate: Date?) {
        let categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: currentDate?.getWeekday()
        )
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        self.visibleCategories = categories
    }
    
    func filterTrackers(searchText: String) -> [TrackerCategory]? {
        var newCategories: [TrackerCategory] = []
        let categories = self.categories
        guard let categories = categories else { return nil }
        for category in categories {
            var newTrackers: [Tracker] = []
            for i in 0..<category.trackers.count {
                let tracker = category.trackers[i]
                if tracker.name.lowercased().contains(searchText.lowercased()) {
                    newTrackers.append(tracker)
                }
            }
            if !newTrackers.isEmpty {
                let newCategory = TrackerCategory(title: category.title, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        if newCategories.isEmpty {
            return nil
        }
        return newCategories
    }
    
    func makeCategoriesForWeeday(categories: [TrackerCategory]?, forWeekdays: Int? = nil) -> [TrackerCategory]? {
        var newCategories: [TrackerCategory] = []
        if forWeekdays == nil {
            guard let categories = categories else { return nil }
            newCategories = categories
        }
        else {
            guard let categories = categories else { return nil }
            for category in categories {
                var newTrackers: [Tracker] = []
                for i in 0..<category.trackers.count {
                    let tracker = category.trackers[i]
                    guard let weekdays = tracker.schedule else {
                        newTrackers.append(tracker)
                        continue
                    }
                    for i in 0..<weekdays.count {
                        let weekday = weekdays[i]
                        guard let weekday = weekday else { return nil }
                        if weekday.valueForDatePicker == forWeekdays {
                            newTrackers.append(tracker)
                        }
                    }
                }
                if !newTrackers.isEmpty {
                    let newCategory = TrackerCategory(title: category.title, trackers: newTrackers)
                    newCategories.append(newCategory)
                }
            }
        }
        if newCategories.isEmpty {
            return nil
        }
        return newCategories
    }
    
    func updateVisibleCategories(searchText: String) {
        visibleCategories = filterTrackers(searchText: searchText)
    }
    
    func deleteFilterForVisibleCategories() {
        visibleCategories = categories
    }
    
    func deleteValuesForIndexPath() {
        dataHolder.deleteValuesForIndexPath()
    }
    
    func datePickerValueDidChanged(weekday: Int?) {
        let categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: weekday
        )
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        self.visibleCategories = categories
    }
    
    func didTapLeftNavButton() {
        deleteValuesForIndexPath()
    }
}

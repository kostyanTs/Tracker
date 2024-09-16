//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Konstantin on 02.08.2024.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateTrackers(indexPath: IndexPath)
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexPath?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try? controller.performFetch()
        return controller
    }()
    
    func saveTrackerCategory(categoryTitle: String, tracker: Tracker) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.hexString()
        let encoder = JSONEncoder()
        trackerCoreData.schedule = try? encoder.encode(tracker.schedule)
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == '\(categoryTitle)'", #keyPath(TrackerCategoryCoreData.title))
        if let category = try? context.fetch(request).first {
            trackerCoreData.category = category
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.title = categoryTitle
            trackerCategoryCoreData.addToTrackers(trackerCoreData)
        }
        saveTrackerCategory()
    }
    
    func deleteTracker(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicateForName = NSPredicate(
            format: "%K == '\(tracker.name)'",
            #keyPath(TrackerCoreData.name))
        let predicateForColor = NSPredicate(
            format: "%K == '\(tracker.emoji)'",
            #keyPath(TrackerCoreData.emoji))
        let predicate = NSCompoundPredicate(
            type: NSCompoundPredicate.LogicalType.and,
            subpredicates: [predicateForName, predicateForColor])
        request.predicate = predicate
        if let newTracker = try? context.fetch(request).first {
            context.delete(newTracker)
        }
        saveTrackerCategory()
    }
    
    func deleteAllData() {
        let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        categoryRequest.returnsObjectsAsFaults = false
        do {
            guard let results = try? context.fetch(categoryRequest) else { return }
            for obj in results {
                let managedObjData = obj as NSManagedObject
                context.delete(managedObjData)
            }
        } 
        saveTrackerCategory()
        
        let trackerRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        trackerRequest.returnsObjectsAsFaults = false
        do {
            guard let results = try? context.fetch(trackerRequest) else { return }
            for obj in results {
                let managedObjData = obj as NSManagedObject
                context.delete(managedObjData)
            }
        }
        
        let trackerRecordRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        trackerRecordRequest.returnsObjectsAsFaults = false
        do {
            guard let results = try? context.fetch(trackerRecordRequest) else { return }
            for obj in results {
                let managedObjData = obj as NSManagedObject
                context.delete(managedObjData)
            }
        }
    }
    
    func updateTracker(tracker: Tracker, updateTracker: Tracker, newCategoryTitle: String) {
        let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        categoryRequest.predicate = NSPredicate(
            format: "%K == '\(newCategoryTitle)'",
            #keyPath(TrackerCategoryCoreData.title))
        guard let newCategory = try? context.fetch(categoryRequest).first else { return }
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicateForName = NSPredicate(
            format: "%K == '\(tracker.name)'",
            #keyPath(TrackerCoreData.name))
        let predicateForColor = NSPredicate(
            format: "%K == '\(tracker.emoji)'",
            #keyPath(TrackerCoreData.emoji))
        let predicate = NSCompoundPredicate(
            type: NSCompoundPredicate.LogicalType.and,
            subpredicates: [predicateForName, predicateForColor])
        request.predicate = predicate
        let encoder = JSONEncoder()
        if let newTracker = try? context.fetch(request).first {
            newTracker.category = newCategory
            newTracker.name = updateTracker.name
            newTracker.color = updateTracker.color.hexString()
            newTracker.emoji = updateTracker.emoji
            newTracker.schedule = try? encoder.encode(updateTracker.schedule)
        }
        saveTrackerCategory()
    }
    
    func updateFixTracker(tracker: Tracker) {
        let fixRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fixRequest.predicate = NSPredicate(
            format: "%K == 'Fixed'",
            #keyPath(TrackerCategoryCoreData.title))
        guard let fixCategory = try? context.fetch(fixRequest).first else { return }
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicateForName = NSPredicate(
            format: "%K == '\(tracker.name)'",
            #keyPath(TrackerCoreData.name))
        let predicateForColor = NSPredicate(
            format: "%K == '\(tracker.emoji)'",
            #keyPath(TrackerCoreData.emoji))
        let predicate = NSCompoundPredicate(
            type: NSCompoundPredicate.LogicalType.and,
            subpredicates: [predicateForName, predicateForColor])
        request.predicate = predicate
        if let newTracker = try? context.fetch(request).first {
            newTracker.extraCategory = newTracker.category
            newTracker.category = fixCategory
        }
        saveTrackerCategory()
    }
    
    func unpinTracker(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicateForName = NSPredicate(
            format: "%K == '\(tracker.name)'",
            #keyPath(TrackerCoreData.name))
        let predicateForColor = NSPredicate(
            format: "%K == '\(tracker.emoji)'",
            #keyPath(TrackerCoreData.emoji))
        let predicate = NSCompoundPredicate(
            type: NSCompoundPredicate.LogicalType.and,
            subpredicates: [predicateForName, predicateForColor])
        request.predicate = predicate
        if let newTracker = try? context.fetch(request).first {
            newTracker.category = newTracker.extraCategory
            newTracker.extraCategory = nil
        }
        saveTrackerCategory()
    }
    
    func saveOnlyTitleCategory(categoryTitle: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = categoryTitle
        trackerCategoryCoreData.trackers = []
        saveTrackerCategory()
    }
    
    func loadOnlyTitleCategories() -> [String] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let trackerCategoryCoreData = try? context.fetch(request)
        guard let trackerCategoryCoreData = trackerCategoryCoreData else { return [] }
        var newArray: [String] = []
        trackerCategoryCoreData.forEach({ category in
            guard let title = category.title else { return }
            newArray.append(title)
        })
        return newArray
    }
    
    func loadCategories() -> [TrackerCategory]? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        guard let trackerCoreData = try? context.fetch(request) else { return nil }
        var trackerCategories:[TrackerCategory] = []
        trackerCoreData.forEach({ tracker in
            let categoryTitle = tracker.category?.title ?? ""
            guard let data = tracker.schedule else { return }
            guard let id = tracker.id,
                  let name = tracker.name,
                  let color = tracker.color?.color(),
                  let emoji = tracker.emoji 
            else { return }
            let tracker = Tracker(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: try? JSONDecoder().decode([WeekDay?]?.self, from: data)
            )
            if trackerCategories.contains(where: { trackerCategory in
                trackerCategory.title == categoryTitle
            }) {
                var newTrackerArray:[Tracker] = []
                trackerCategories.forEach ({
                    if $0.title == categoryTitle {
                        newTrackerArray = $0.trackers
                        newTrackerArray.append(tracker)
                    }
                })
                trackerCategories.removeAll { trackerCategory in
                    trackerCategory.title == categoryTitle
                }
                trackerCategories.append(TrackerCategory(title: categoryTitle, trackers: newTrackerArray))
                
            } else {
                let trackerCategory = TrackerCategory(
                    title: categoryTitle,
                    trackers: [tracker])
                trackerCategories.append(trackerCategory)
            }
        })
        return trackerCategories
    }
    
    func deleteCategories() {
        //TODO: make delete func
    }
    
    private func saveTrackerCategory(){
        do{
            try context.save()
        } catch {
            print("[TrackerCategoryStore]: error to save TrackerCategory in CoreData")
            context.rollback()
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexPath()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let indexPath = insertedIndexes {
            delegate?.updateTrackers(indexPath: indexPath)
        }
        insertedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, 
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes = indexPath
            }
        default:
            break
        }
    }
}

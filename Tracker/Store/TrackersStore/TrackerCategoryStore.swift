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
        print(trackerCoreData.count)
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
    
    
    private func saveTrackerCategory(){
        do{
            try context.save()
            print("Category save")
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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

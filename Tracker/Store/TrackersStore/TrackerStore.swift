//
//  TrackerStore.swift
//  Tracker
//
//  Created by Konstantin on 02.08.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
    }

    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.hexString()
        let encoder = JSONEncoder()
        trackerCoreData.schedule = try? encoder.encode(tracker.schedule)
        saveTracker()
    }
 
    private func saveTracker(){
        do{
            try context.save()
        } catch {
            print("[TrackerStore]: error to save Tracker in CoreData")
            context.rollback()
        }
    }
}

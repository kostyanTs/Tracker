//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Konstantin on 02.08.2024.
//

import UIKit
import CoreData


final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewTrackerRecord(trackerRecord: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        saveTrackerRecord()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerRecordCoreData = try? context.fetch(request) else { return }
        trackerRecordCoreData.forEach({ record in
            if trackerRecord.id == record.id && trackerRecord.date == record.date {
                context.delete(record)
            }
        })
    }
    
    func loadTrackerRecords() -> [TrackerRecord]? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerRecordCoreData = try? context.fetch(request) else { return nil }
        var trackerRecord: [TrackerRecord] = []
        trackerRecordCoreData.forEach({ record in
            guard let id = record.id,
                  let date = record.date
            else { return }
            let newRecord = TrackerRecord(id: id, date: date)
            trackerRecord.append(newRecord)
        })
        return trackerRecord
    }

    private func saveTrackerRecord(){
        do{
            try context.save()
            print("TrackerRecord save")
        } catch {
            print("[TrackerRecordStore]: error to save TrackerRecord in CoreData")
            context.rollback()
        }
    }
}

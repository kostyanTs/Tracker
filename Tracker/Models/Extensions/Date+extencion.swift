//
//  Date+extencion.swift
//  Tracker
//
//  Created by Konstantin on 28.07.2024.
//

import Foundation

extension Date {
    func isBeforeOrEqual(date: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: selfComponents)! <= calendar.date(from: dateComponents)!
    }
    
    func getWeekday() -> Int? {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    func getDateWithoutTime() -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        guard let dateWithoutTime = calendar.date(from: dateComponents) else { return nil }
        return dateWithoutTime
    }
}

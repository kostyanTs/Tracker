//
//  WeekDay.swift
//  Tracker
//
//  Created by Konstantin on 23.07.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable{
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thuersday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
    
    var dayValue: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thuersday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var keyValue: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thuersday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var valueForDatePicker: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thuersday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
}

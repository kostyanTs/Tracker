//
//  UserDefaults+extencion.swift
//  Tracker
//
//  Created by Konstantin on 14.08.2024.
//

import Foundation

extension UserDefaults {
    var hasLaunchBefore: Bool {
        get {
            return self.bool(forKey: "LaunchKey7")
        }
        set {
            self.set(newValue, forKey: "LaunchKey7")
        }
    }
}

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
            return self.bool(forKey: "Key")
        }
        set {
            self.set(newValue, forKey: "Key")
        }
    }
}

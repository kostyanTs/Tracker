//
//  String+extencion.swift
//  Tracker
//
//  Created by Konstantin on 02.08.2024.
//

import UIKit

extension String {
    
    func color() -> UIColor {
        let hex: String = self
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//
//  UIColor+extencion.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

extension UIColor {
    var ypRed: UIColor { return UIColor(named: "YPRed") ?? UIColor.red }
    var ypBlue: UIColor { return UIColor(named: "YPBlue") ?? UIColor.blue}
    var ypWhite: UIColor { return UIColor(named: "YPWhite[day]") ?? UIColor.white}
    var ypBlack: UIColor { return UIColor(named: "YPBlack[day]") ?? UIColor.black}
    var ypBackground: UIColor { return UIColor(named: "YPBackground[day]") ?? UIColor.darkGray}
    var ypGrey: UIColor { return UIColor(named: "YPGrey") ?? UIColor.gray}
    var ypLightGrey: UIColor { return UIColor(named: "YPLightGrey") ?? UIColor.lightGray}
    var dateBackgroundColor: UIColor { return UIColor(named: "dateBackgroundColor") ?? UIColor.gray}
}

//
//  UIButton+extencions.swift
//  Tracker
//
//  Created by Konstantin on 29.07.2024.
//

import UIKit

extension UIButton {
 
    override open var isEnabled: Bool {
        
        didSet {
            super.isEnabled = isEnabled
            backgroundColor = isEnabled ? .clear : .white
            tintColor = isEnabled ? .clear : .white
            
        }
    }
    
    override open var isHighlighted: Bool {
        
        didSet {
            super.isHighlighted = isHighlighted
            backgroundColor = isHighlighted ? .clear : .white
            tintColor = isHighlighted ? .clear : .white
            
        }
    }
}

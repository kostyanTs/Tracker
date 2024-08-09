//
//  SelfSizingTableView.swift
//  Tracker
//
//  Created by Konstantin on 19.07.2024.
//

import UIKit

final class SelfSizingTableView: UITableView {
    override public var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        contentSize
    }
}

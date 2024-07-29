//
//  SelfSizingCollectionView.swift
//  Tracker
//
//  Created by Konstantin on 24.07.2024.
//

import UIKit

class SelfSizingCollectionView: UICollectionView {
    override public var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        contentSize
    }
}

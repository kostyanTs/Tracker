//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Konstantin on 01.07.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTests: XCTestCase {

    
    func testViewController() {
        let tabBarViewController = TabBarViewController()
        assertSnapshot(of: tabBarViewController, as: .image)                                             // 2
        }
}

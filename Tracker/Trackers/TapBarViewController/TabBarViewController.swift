//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        let navigationTrackerController = UINavigationController(rootViewController: trackersViewController)
        navigationTrackerController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackersItem"),
            selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statisticsItem"),
            selectedImage: nil)
        self.viewControllers = [navigationTrackerController, statisticsViewController]
    }
}



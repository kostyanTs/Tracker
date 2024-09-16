//
//  AppDelegate.swift
//  Tracker
//
//  Created by Konstantin on 01.07.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "c2da613a-2c05-4511-9e0f-3749a33c3916") else {
                return true
            }
            YMMYandexMetrica.activate(with: configuration)
            return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Tracker")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


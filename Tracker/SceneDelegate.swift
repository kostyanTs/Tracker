//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Konstantin on 01.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if !UserDefaults.standard.hasLaunchBefore {
            let onbordingViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            let navigationController = UINavigationController(rootViewController: onbordingViewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            let tabBarViewController = TabBarViewController()
            window?.rootViewController = tabBarViewController
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}


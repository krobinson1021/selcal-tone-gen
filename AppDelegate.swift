//
//  AppDelegate.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

//
//  SceneDelegate.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let mainVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

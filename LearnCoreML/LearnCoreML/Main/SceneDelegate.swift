//
//  SceneDelegate.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var appCoordinator = AppCoordinator(window: self.window!)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        appCoordinator.start()
    }
}


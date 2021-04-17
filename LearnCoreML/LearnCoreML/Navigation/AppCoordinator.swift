//
//  Coordinator.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

class AppCoordinator: MainMenuViewRouter {
    private let window: UIWindow
    private let navigationController = UINavigationController(rootViewController: UIViewController())
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController.setViewControllers([makeMainMenu()], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showCarClassifier() {
        navigationController.pushViewController(CarClassifierViewController.loadFromStoryboard(),
                                                animated: true)
    }
}

private extension AppCoordinator {
    func makeMainMenu() -> MainMenuViewController {
        let vc = MainMenuViewController()
        vc.router = self
        return vc
    }
}




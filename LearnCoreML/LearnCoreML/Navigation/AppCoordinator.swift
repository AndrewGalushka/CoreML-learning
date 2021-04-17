//
//  Coordinator.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
    }
}




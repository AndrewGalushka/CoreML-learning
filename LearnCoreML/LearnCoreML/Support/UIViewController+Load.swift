//
//  UIViewController+Load.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

extension UIViewController {
    static func loadFromStoryboard() -> Self {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self)).instantiateInitialViewController() as! Self
    }
}

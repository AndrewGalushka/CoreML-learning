//
//  UIViewController+Extensions.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

extension UIViewController {
    static func loadFromStoryboard() -> Self {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self)).instantiateInitialViewController() as! Self
    }
    
    func attach(to parentVC: UIViewController) {
        attach(to: parentVC, in: parentVC.view)
    }
    
    func attach(to parentVC: UIViewController, in parentView: UIView, inset: UIEdgeInsets = .zero) {
        self.willMove(toParent: parentVC)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: inset.left),
            view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -inset.right),
            view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: inset.top),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -inset.bottom)
        ])
        
        parentVC.addChild(self)
        self.didMove(toParent: parentVC)
    }
}

//
//  UIView+Extensions.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

extension UIView {
    func embed(to superview: UIView, inset: UIEdgeInsets = .zero, safeArea: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        
        if safeArea {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottom),
                self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: inset.left),
                self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -inset.right)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom),
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right)
            ])
        }
    }
    
    func embed(to superview: UIView, insetBy: CGFloat) {
        embed(to: superview, inset: UIEdgeInsets(top: insetBy, left: insetBy, bottom: insetBy, right: insetBy))
    }
}

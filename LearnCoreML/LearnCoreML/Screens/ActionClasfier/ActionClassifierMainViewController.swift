//
//  ActionClassifierMainViewController.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 18.04.2021.
//

import UIKit

class ActionClassifierMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CaptureViewController().attach(to: self)
    }
}

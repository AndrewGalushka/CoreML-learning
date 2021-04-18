//
//  CaptureViewController.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 18.04.2021.
//

import UIKit

class CaptureViewController: UIViewController {
    let captureSession = Camera()
    let capturePreview = CaptureVideoPreview()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.configure()
        capturePreview.embed(to: view)
        captureSession.bind(to: capturePreview.previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
}

//
//  CaptureViewController.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 18.04.2021.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {
    let captureSession = Camera()
    let capturePreview = CaptureVideoPreview()
    let posesDetector = BodyPoseDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.configure()
        capturePreview.embed(to: view, safeArea: true)
        captureSession.bind(to: capturePreview.previewLayer)
        captureSession.sampleBufferOutput = { [weak self] sampleBuffer in
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            self?.posesDetector.process(pixelBuffer: imageBuffer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
}

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
        capturePreview.embed(to: view)
        captureSession.bind(to: capturePreview.previewLayer)
        captureSession.setSampleBufferDelegate(self, queue: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        posesDetector.process(pixelBuffer: pixelBuffer)
    }
}

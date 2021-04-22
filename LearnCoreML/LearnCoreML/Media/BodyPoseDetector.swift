//
//  PoseDetector.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 21.04.2021.
//

import Vision

class BodyPoseDetector {
    func process(pixelBuffer: CVPixelBuffer) {
        DispatchQueue.global().async {
            do {
                let request = VNDetectHumanBodyPoseRequest()
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
                try handler.perform([request])
                
                guard let poses = request.results else {
                    return
                }
                
                self.log(poses.description)
            } catch let error {
                self.log(error.localizedDescription)
            }
        }
    }
    
    private func log(_ message: String) {
        DispatchQueue.global().async {
            print(message)
        }
    }
}

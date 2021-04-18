//
//  CaptureVideoPreview.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 18.04.2021.
//

import UIKit
import AVFoundation

class CaptureVideoPreview: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
}

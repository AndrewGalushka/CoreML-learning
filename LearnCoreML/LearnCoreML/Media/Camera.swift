//
//  CaptureSession.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import AVFoundation

class Camera {
    
    // Devices
    private var frontCamDevice: AVCaptureDevice!
    private var backCamDevice: AVCaptureDevice!
    private var micDevice: AVCaptureDevice!
    
    // Current Camera Device
    private var currentCamDevice: AVCaptureDevice!
    private(set) var position: CamPosition = .back
    
    // Device Inputs
    private var deviceInput: AVCaptureDeviceInput!
    
    // CaptureSession
    private var captureSession: AVCaptureSession!
    
    // Outputs
    private var captureSessionOutput: AVCaptureVideoDataOutput!
    
    private var privateQueue = DispatchQueue(label: "com.capture.session.private.queue")
    
    // MARK: - Public API
    
    func configure(camPosition: CamPosition = .front) {
        
        // Discover for devices and initialise properties
        self.frontCamDevice = self.discoverFrontDevice()
        self.backCamDevice = self.discoverBackDevice()
        self.micDevice = self.discoverMicDevice()
        
        // Add Input to Discovered device (back camera)
        self.position = camPosition
        switch camPosition {
        case .front:
            self.deviceInput = try! AVCaptureDeviceInput(device: frontCamDevice)
            self.currentCamDevice = frontCamDevice
        case .back:
            self.deviceInput = try! AVCaptureDeviceInput(device: backCamDevice)
            self.currentCamDevice = backCamDevice
        }
        
        // Initialise AVCaptureSession
        self.captureSession = AVCaptureSession()
        
        // Add Input to CaptureSession
        captureSession.addInput(self.deviceInput)
        
        // Initialise CaptureOutput
        self.configureCaptureOutput()
        
        // Add output to CaptureSession
        captureSession.addOutput(captureSessionOutput)
    }
    
    func bind(to preview: AVCaptureVideoPreviewLayer) {
        privateQueue.async { [weak self] in
            guard let self = self else { return }
            preview.session = self.captureSession
        }
    }
    
    /// Asynchronously starts the session
    func start() {
        privateQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    /// Asynchronously stops the session
    func stop() {
        privateQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    func switchCamPosition() {
        let device: AVCaptureDevice
        
        // Find current Device
        switch self.position {
        case .front:
            device = backCamDevice
        case .back:
            device = frontCamDevice
        }
        
        // Return if switching device is the same as current
        guard !device.isEqual(self.currentCamDevice) else {
            return
        }
        
        // Save switching to device
        self.currentCamDevice = device
        self.position.toggle()
        
        // Remove old device input from Capture Session
        self.captureSession.removeInput(self.deviceInput)
        
        // Create new device input with new device
        self.deviceInput = try! AVCaptureDeviceInput(device: self.currentCamDevice)
        
        // Add created device input to CaptureSession
        self.captureSession.addInput(self.deviceInput)
    }
    
    func setSampleBufferDelegate(_ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?, queue sampleBufferCallbackQueue: DispatchQueue?) {
        captureSessionOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: sampleBufferCallbackQueue)
    }
    
    // MARK: - Private API
    
    private func discoverBackDevice() -> AVCaptureDevice {
        let backDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                                          mediaType: .video,
                                                                          position: AVCaptureDevice.Position.back)
        
        guard let backCameraDevice = backDeviceDiscoverySession.devices.first else {
            fatalError("Couldn't find any back camera device")
        }
        
        return backCameraDevice
    }
    
    private func discoverFrontDevice() -> AVCaptureDevice {
        let frontDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                                          mediaType: .video,
                                                                          position: AVCaptureDevice.Position.front)
        
        guard let frontCameraDevice = frontDeviceDiscoverySession.devices.first else {
            fatalError("Couldn't find any front camera device")
        }
        
        return frontCameraDevice
    }
    
    private func discoverMicDevice() -> AVCaptureDevice {
        let micDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone],
                                                                         mediaType: AVMediaType.audio,
                                                                         position: .unspecified)

        guard let micDevice = micDeviceDiscoverySession.devices.first else {
            fatalError("Couldn't find any microphone device")
        }
        
        return micDevice
    }
}

private extension Camera {
    func configureCaptureOutput() {
        self.captureSessionOutput = AVCaptureVideoDataOutput()
        self.captureSessionOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        captureSessionOutput.connection(with: .video)?.isEnabled = true
        if let connection = captureSessionOutput.connection(with: .video) {
            if connection.isCameraIntrinsicMatrixDeliverySupported {
                connection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
    }
}

extension Camera {
    enum CamPosition {
        case front
        case back
        
        mutating func toggle() {
            switch self {
            case .front:
                self = .back
            case .back:
                self = .front
            }
        }
    }
}

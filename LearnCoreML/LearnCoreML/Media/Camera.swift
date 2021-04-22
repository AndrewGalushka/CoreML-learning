//
//  CaptureSession.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import AVFoundation

class Camera: NSObject {
    
    // MARK: - Public Properties
    
    var sampleBufferOutput: ((CMSampleBuffer) -> Void)?
    var sampleBufferDropOutput: ((CMSampleBuffer) -> Void)?
    
    // MARK: - Private Properties
    
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
    private var captureSession = AVCaptureSession()
    
    // Outputs
    private var captureSessionOutput: AVCaptureVideoDataOutput!
    
    private var serialQueue = DispatchQueue(label: "com.camera.serial.queue")
    
    // MARK: - Public API
    
    func configure(camPosition: CamPosition = .front) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Discover for devices and initialise properties
            self.frontCamDevice = self.discoverFrontDevice()
            self.backCamDevice = self.discoverBackDevice()
            self.micDevice = self.discoverMicDevice()
            
            // Add Input to Discovered device (back camera)
            self.position = camPosition
            switch camPosition {
            case .front:
                self.deviceInput = try! AVCaptureDeviceInput(device: self.frontCamDevice)
                self.currentCamDevice = self.frontCamDevice
            case .back:
                self.deviceInput = try! AVCaptureDeviceInput(device: self.backCamDevice)
                self.currentCamDevice = self.backCamDevice
            }
            
            // Initialise AVCaptureSession
            self.captureSession = AVCaptureSession()
            
            // Add Input to CaptureSession
            self.captureSession.addInput(self.deviceInput)
            
            // Initialise CaptureOutput and add output to CaptureSession
            self.addCaptureOutput()
        }
    }
    
    func bind(to preview: AVCaptureVideoPreviewLayer) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            preview.session = self.captureSession
        }
    }
    
    /// Asynchronously starts the session
    func start() {
        serialQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    /// Asynchronously stops the session
    func stop() {
        serialQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    func switchCamPosition() {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            let device: AVCaptureDevice
            
            // Find current Device
            switch self.position {
            case .front:
                device = self.backCamDevice
            case .back:
                device = self.frontCamDevice
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
    func addCaptureOutput() {
        self.captureSessionOutput = AVCaptureVideoDataOutput()
        self.captureSession.addOutput(self.captureSessionOutput)
        self.captureSessionOutput.connection(with: .video)?.isVideoMirrored = true
        
        self.captureSessionOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        captureSessionOutput.connection(with: .video)?.videoOrientation = .portrait
        captureSessionOutput.connection(with: .video)?.isVideoMirrored = true
        
        captureSessionOutput.connection(with: .video)?.isEnabled = true
        if let connection = captureSessionOutput.connection(with: .video) {
            if connection.isCameraIntrinsicMatrixDeliverySupported {
                connection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
        
        captureSessionOutput.setSampleBufferDelegate(self, queue: serialQueue)
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

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.sampleBufferOutput?(sampleBuffer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.sampleBufferDropOutput?(sampleBuffer)
    }
}

//
//  AVCodeReader.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//
import AVFoundation
import Foundation

class AVCodeReader: NSObject {
    fileprivate(set) var videoPreview = CALayer()
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var didRead: ((String) -> Void)?
    
    override init() {
        super.init()
        
        //Make sure the device can handle video
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                return
        }
        captureSession = AVCaptureSession()
        
        //input
        captureSession?.addInput(deviceInput)
        
        //output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //interprets qr codes only
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //preview
        let captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession!)
        captureVideoPreview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreview = captureVideoPreview
    }
}

extension AVCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableCode.stringValue else {
                return
        }
        //Vibrate the phone
        //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //stopReading()
        
        didRead?(code)
    }
}

protocol CodeReader {
    func startReading(completion: @escaping (String) -> Void)
    func stopReading()
    var videoPreview: CALayer {get}
}

extension AVCodeReader: CodeReader {
    func startReading(completion: @escaping (String) -> Void) {
        self.didRead = completion
        captureSession?.startRunning()
    }
    func stopReading() {
        captureSession?.stopRunning()
    }
}

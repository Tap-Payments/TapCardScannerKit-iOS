//
//  CameraView.swift
//  CreditCardScannerPackageDescription
//  Created by Osama Rabie on 24/07/2021.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

#if canImport(UIKit)
#if canImport(AVFoundation)

import AVFoundation
import UIKit
import VideoToolbox
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS

protocol CameraViewDelegate: AnyObject {
    func didCapture(image: CGImage)
    func didError(with: Error)
}

@available(iOS 13, *)
final class CameraView: UIView {
    weak var delegate: CameraViewDelegate?
    private var creditCardFrameStrokeColor: UIColor
    private var showBlur: Bool = true
    private let maskLayerColor: UIColor
    private let maskLayerAlpha: CGFloat
    
    // MARK: - Capture related
    
    private let captureSessionQueue = DispatchQueue(
        label: "com.yhkaplan.credit-card-scanner.captureSessionQueue"
    )
    
    // MARK: - Capture related
    
    private let sampleBufferQueue = DispatchQueue(
        label: "com.yhkaplan.credit-card-scanner.sampleBufferQueue"
    )
    
    init(
        delegate: CameraViewDelegate? = nil,
        creditCardFrameStrokeColor: UIColor = .green,
        maskLayerColor: UIColor = .black,
        maskLayerAlpha: CGFloat = 0.3,
        showBlur:Bool = true
    ) {
        self.delegate = delegate
        self.creditCardFrameStrokeColor = creditCardFrameStrokeColor
        self.maskLayerColor = maskLayerColor
        self.maskLayerAlpha = maskLayerAlpha
        self.showBlur = showBlur
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageRatio: ImageRatio = .vga640x480
    
    // MARK: - Region of interest and text orientation
    
    /// Region of video data output buffer that recognition should be run on.
    /// Gets recalculated once the bounds of the preview layer are known.
    var regionOfInterest: CGRect?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        return layer
    }
    
    private var videoSession: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    func stopSession() {
        DispatchQueue.main.async { [weak self] in
            self?.videoSession?.stopRunning()
        }
    }
    
    func startSession() {
        DispatchQueue.main.async { [weak self] in
            self?.videoSession?.startRunning()
        }
    }
    
    func setupCamera(with uiCustomization:TapFullScreenUICustomizer = .init()) {
        creditCardFrameStrokeColor = uiCustomization.tapFullScreenScanBorderColor
        showBlur = uiCustomization.blurCardScannerBackground
        
        captureSessionQueue.async { [weak self] in
            self?._setupCamera()
        }
    }
    
    private func _setupCamera() {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = imageRatio.preset
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back) else {
            delegate?.didError(with: "Error setup camera")
            return
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            session.canAddInput(deviceInput)
            session.addInput(deviceInput)
        } catch {
            delegate?.didError(with: error)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        
        guard session.canAddOutput(videoOutput) else {
            delegate?.didError(with: "Error setup camera")
            return
        }
        
        session.addOutput(videoOutput)
        session.connections.forEach {
            $0.videoOrientation = .portrait
        }
        session.commitConfiguration()
        
        DispatchQueue.main.async { [weak self] in
            self?.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self?.videoSession = session
            self?.startSession()
        }
    }
    
    func setupRegionOfInterest() {
        guard regionOfInterest == nil else { return }
        /// Mask layer that covering area around camera view
        /*let backLayer = CALayer()
         backLayer.frame = bounds
         if let blurFilter = CIFilter(name: "CIGaussianBlur",
         parameters: [kCIInputRadiusKey: 2]) {
         backLayer.backgroundFilters = [blurFilter]
         }
         backLayer.backgroundColor = maskLayerColor.withAlphaComponent(maskLayerAlpha).cgColor*/
        
        if let addedBlurView = viewWithTag(123123123) {
            addedBlurView.removeFromSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height)
        print("FRAME : \(blurEffectView.frame)")
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 123123123
        
        if showBlur {
            addSubview(blurEffectView)
        }
        
        //  culcurate cutoutted frame
        var cuttedWidth: CGFloat = bounds.width - 40
        if UIDevice.current.orientation.isLandscape {
            cuttedWidth = 400
        }
        let cuttedHeight: CGFloat = cuttedWidth * TapCard.heightRatioAgainstWidth
        
        let centerVertical = (bounds.height / 2.0)
        let centerHorizontal = (bounds.width / 2.0)
        let cuttedY: CGFloat = centerVertical - (cuttedHeight / 2.0)
        let cuttedX: CGFloat = centerHorizontal - (cuttedWidth / 2.0)
        
        let cuttedRect = CGRect(x: cuttedX,
                                y: cuttedY,
                                width: cuttedWidth,
                                height: cuttedHeight)
        
        
        if showBlur {
            let maskLayer = CAShapeLayer()
            let path = UIBezierPath(roundedRect: cuttedRect, cornerRadius: 10.0)
            
            path.append(UIBezierPath(rect: bounds))
            maskLayer.path = path.cgPath
            maskLayer.fillRule = .evenOdd
            //backLayer.mask = maskLayer
            //layer.addSublayer(backLayer)
            blurEffectView.layer.mask = maskLayer
        }
        
        let strokeLayer = CAShapeLayer()
        strokeLayer.lineWidth = 1.0
        strokeLayer.strokeColor = creditCardFrameStrokeColor.cgColor
        strokeLayer.path = UIBezierPath(roundedRect: cuttedRect, cornerRadius: 10.0).cgPath
        strokeLayer.fillColor = nil
        layer.sublayers?.removeAll(where: { layer in
            if let isStrokeLayer:CAShapeLayer = layer as? CAShapeLayer,
               isStrokeLayer.lineWidth == 1.0,
               isStrokeLayer.strokeColor == creditCardFrameStrokeColor.cgColor {
                return true
            }
            return false
        })
        
        layer.addSublayer(strokeLayer)
        
        let imageHeight: CGFloat = imageRatio.imageHeight
        let imageWidth: CGFloat = imageRatio.imageWidth
        
        let acutualImageRatioAgainstVisibleSize = imageWidth / bounds.width
        let interestX = cuttedRect.origin.x * acutualImageRatioAgainstVisibleSize
        let interestWidth = cuttedRect.width * acutualImageRatioAgainstVisibleSize
        let interestHeight = interestWidth * TapCard.heightRatioAgainstWidth
        let interestY = (imageHeight / 2.0) - (interestHeight / 2.0)
        regionOfInterest = CGRect(x: interestX,
                                  y: interestY,
                                  width: interestWidth,
                                  height: interestHeight)
        
        /*let dummyView:UIView = .init(frame: cuttedRect)
         dummyView.backgroundColor = .red
         addSubview(dummyView)
         print(dummyView.frame)*/
    }
}

@available(iOS 13, *)
extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        semaphore.wait()
        defer { semaphore.signal() }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            delegate?.didError(with: "Error capture camera")
            delegate = nil
            return
        }
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let regionOfInterest = regionOfInterest else {
            return
        }
        
        guard let fullCameraImage = cgImage,
              let _ = fullCameraImage.cropping(to: regionOfInterest) else {
            delegate?.didError(with: "Error capture camera")
            delegate = nil
            return
        }
        
        delegate?.didCapture(image: fullCameraImage)
    }
}
#endif
#endif

internal extension TapCard {
    // The aspect ratio of credit-card is Golden-ratio
    static let heightRatioAgainstWidth: CGFloat = 0.6180469716
}

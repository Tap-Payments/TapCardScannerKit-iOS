//
//  TapInlineCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CommonDataModelsKit_iOS

/// Delegate to listen to firing events from the scanner
@objc public protocol TapInlineScannerProtocl {
    /// This block fires when the scanner finished scanning
    @objc func tapFullCardScannerDimissed()
    /// This block fires when the scanner finished scanning
    @objc func tapCardScannerDidFinish(with tapCard:TapCard)
    /// This block fires when the scanner finished scanning
    @objc func tapInlineCardScannerTimedOut(for inlineScanner:TapInlineCardScanner)
}

/// This class represents the tap inline scanner UI controller.
@objc public class TapInlineCardScanner:NSObject {
    
    /// Analyzes text data for credit card info
    private lazy var analyzer = ImageAnalyzer(delegate: self, dataSource: dataSource)
    
    /// The data source needed to configure
    private weak var dataSource:TapScannerDataSource?
    
    /// Delegate to listen to firing events from the scanner
    @objc public var delegate:TapInlineScannerProtocl?
    
    /// This is the timeout period for the current scanner, -1 means it doesn't have one and will keep showing until parent app decides not to
    internal lazy var timeOutPeriod:Int = -1
    /// This is the UIView that scanner/camera feed will show inside it
    internal var previewView:UIView?
    /// This is the color of scan the card border. Default is green
    internal lazy var scanningBorderColor:UIColor = .green
    /// This is the backbone of the scanner object
    private lazy var cameraView: CameraView = CameraView(delegate:self)
    /// Indicates whether to add a blur effect to the camera stream with a hole of the scanning area or not. Default is false
    internal var blurBackground:Bool = false
    /// Will be used to show the required corners by UI instead of the default pay cards corners view
    internal var cornersView:BlurHoleCorners?
    /// Indicates whether to add TAP custom corners instead of the default corners provided by PaySDK
    internal var showTapCorners: Bool = false
    
    /**
     This interface decides whether the scanner can start or not based on camera usage permission granted and camera does exist.
     - Returns: TapCanScanStatusResult enum which has three values: .CanStart if all good, .CameraMissing if camera doesn't exist and .CameraPermissionMissing Scanning cannot start as camera usage permission is not granted
     */
    @objc public static func CanScan() -> TapCanScanStatusResult {
        //FlurryLogger.logEvent(with: "Can_Scan_Called")
        // Check if permission is granted to use the camera
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            // Check the camera existance
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // All good!
                return .CanStart
            }else {
                return .CameraMissing
            }
        }else {
            return .CameraPermissionMissing
        }
    }
    
   public init(dataSource:TapScannerDataSource?) {
        self.dataSource = dataSource
        super.init()
    }
    
    /**
     This interface allows the caller to extract card data from a given static image. This can also scan flatten non imposed cards
     - Parameter image: The static image you want to fetch card data from
     - Parameter maxDataSize: Tap scanner will make sure to compress the image to the given max size in KB. The bigger the allowed size, the bigger the post request will be, the longer it will take to uploade.
     - Parameter minCompression: Tap scanner will try to compress the image to the maxx size given, but it will not go below the given quality.
     - Parameter cardScanned: A block that will send back the scand card details
     - Parameter onErrorOccured: A block that will send back any error occured dring any phase of the process
     */
    @objc public func ScanCard(from image:UIImage, maxDataSize:Double = 0, minCompression:CGFloat = 0.2,cardScanned:((TapCard)->())? = nil,onErrorOccured:((String)->())? = nil) {
        
        //FlurryLogger.logEvent(with: "Scan_From_Image_Called", timed:true , params: ["maxDataSize":String(maxDataSize),"minCompression":"\(minCompression)"])
        // GET base64 of the image
        if let base64:String = image.base64Encode(maxDataSize: maxDataSize, minCompression: minCompression) {
            
            // Execute the google cloud vision api request
            googleCloudVisionApi(with: base64, onTextExtracted: { (result) in
                // If there is a success callback then call it with the potentially matched card
                if let nonNullCardScannedBlock = cardScanned {
                    nonNullCardScannedBlock(self.processGoogleVision(with: result))
                }else {
                    //FlurryLogger.endTimerForEvent(with: "Scan_From_Image_Called", params: ["success":"true","error":"","googleText":result])
                }
            }, onErrorOccured: onErrorOccured)
        }
        
    }
    
    /**
     This interface starts the scanner by showing the camera feed in the given view with the customisation parameter.
     - Parameter previewView: This is the UIView that scanner/camera feed will show inside it
     - Parameter scanningBorderColor: This is the color of scan the card border. Default is green
     - Parameter blurBackground: Indicates whether to add a blur effect to the camera stream with a hole of the scanning area or not. Defult is false
     - Parameter showTapCorners: Indicates whether to add TAP custom corners instead of the default corners provided by PaySDK
     - Parameter timoutAfter: This decides when the scanner should timeout (fires the timeout callback) in seconds. Default is -1 which means no timeout is required and it will not accept a value less than 20 seconds
     - Parameter didTimout: A block that will be called after the timeout period
     - Parameter cardScanned: A block that will be called once a card has been scanned. Note, that the scanner will pause itself aftter this, so if you can remove it or resume it using the respective interfaces
     */
    @objc public func startScanning(in previewView:UIView, scanningBorderColor:UIColor = .green, blurBackground:Bool = false,showTapCorners:Bool = false,timoutAfter:Int = -1) throws {
        
        //FlurryLogger.logEvent(with: "Scan_Inline_Called", timed:true)
        
        // Check if scanner can start first
        guard TapInlineCardScanner.CanScan() == .CanStart else {
            //FlurryLogger.endTimerForEvent(with: "Scan_Inline_Called", params: ["success":"false","error":TapInlineCardScanner.CanScan().rawValue])
            throw TapInlineCardScanner.CanScan().rawValue
        }
        
        // apply the ui customisations
        self.previewView = previewView
        self.blurBackground = blurBackground
        self.scanningBorderColor = showTapCorners ? .clear : scanningBorderColor
        self.timeOutPeriod = (timoutAfter == -1) ? -1 : (timoutAfter > 20) ? timoutAfter : 20
        self.showTapCorners = showTapCorners
        // Check if the user passed a timeout then he needs to pass timeout block
        if self.timeOutPeriod > 0 {
            resetTimeOutTimer()
        }
        
        // Configure and restart the recognizer
        startScanning()
    }
    
    /// This method is responsible for starting the camera feed logic
    internal func startScanning() {
        configureScanner()
        configureBlurOverlay()
        cameraView.startSession()
        
    }
    
    /// This method is responsible for configuring the card scanner object and attach it inside the required view with the needed customisations
    internal func configureScanner() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        // Defensive code to check there is a holding view
        if let nonNullPreviewView = self.previewView {
            nonNullPreviewView.addSubview(cameraView)
            // Apply the needed UI layout constraints for the camer feed view to fill in the preview view
            NSLayoutConstraint.activate([
                cameraView.topAnchor.constraint(equalTo: nonNullPreviewView.topAnchor),
                cameraView.bottomAnchor.constraint(equalTo: nonNullPreviewView.bottomAnchor),
                cameraView.leadingAnchor.constraint(equalTo: nonNullPreviewView.leadingAnchor),
                cameraView.trailingAnchor.constraint(equalTo: nonNullPreviewView.trailingAnchor),
            ])
            
            cameraView.layoutIfNeeded()
            
            // instruct the camera view to grap card details from anywhere in the screen
            cameraView.regionOfInterest = .init(x: 0, y: 0, width: nonNullPreviewView.frame.width, height: nonNullPreviewView.frame.height)
            cameraView.setupRegionOfInterest()
            cameraView.setupCamera()
            
        }else {
            //cardScanner = nil
        }
    }
    
    /// Configure the blur overlay to check if we have to add/remove it. And if add it, draw it on top then draw a whole at the scanner rect
    internal func configureBlurOverlay() {
        
        
        if let previousBlurEffect = previewView?.viewWithTag(1010) {
            previousBlurEffect.removeFromSuperview()
        }
        // Make sure we have a valid uiview
        guard let view = previewView, blurBackground else { return }
        
        let blurEffectView: VisualEffectView = .init(effect: UIBlurEffect(style: .light))
        blurEffectView.adjustBlurType()
        //blurEffectView.effect = UIBlurEffect(style: .dark)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.tag = 1010
        /*blurEffectView.colorTint = .yellow
         blurEffectView.colorTintAlpha = 0.48
         blurEffectView.blurRadius = 10
         blurEffectView.scale = 1*/
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(blurEffectView)
        
        
        
        // Create the correct layout constraints to show the corners view properly
        // Map the correct constraints to match the PayCards SDK scanning rect
        let constraints:[NSLayoutConstraint] = [
            blurEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        blurEffectView.layoutIfNeeded()
        
        // Add the custom corners View
        addCustomCornersView(in: blurEffectView)
        // Draw a hole in the blur layout to show the scanning rect
        showBlurringHole(in: blurEffectView)
    }
    
    /// Add the custom corners View which will show custom corner images around the hole in the blurred layout
    internal func addCustomCornersView(in blurEffectView:VisualEffectView) {
        // Make sure we have a valid uiview
        guard let view = previewView, blurBackground else { return }
        
        // Remove any old corners added if any
        cornersView?.removeFromSuperview()
        
        // Create new corners view
        cornersView = .init()
        cornersView?.isHidden = showTapCorners ? false : true
        
        guard let cornersView = cornersView else { return }
        view.addSubview(cornersView)
        view.bringSubviewToFront(cornersView)
        cornersView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the correct layout constraints to show the corners view properly
        // Map the correct constraints to match the PayCards SDK scanning rect
        let constraints:[NSLayoutConstraint] = [
            cornersView.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor),
            cornersView.heightAnchor.constraint(equalTo: cornersView.widthAnchor,multiplier: 0.63),
            cornersView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor,constant: 14),
            cornersView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor,constant: -14),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        cornersView.layoutIfNeeded()
    }
    
    /**
     Draws a hole areound rect scanning in PayCards SDK
     - Parameter blurEffectView: The VisualEffectView that represents the bluring layer, a hole will be drawn inside it to show the scanning rect in a clear way
     */
    internal func showBlurringHole(in blurEffectView:VisualEffectView) {
        
        // Make sure we have a valid uiview
        guard let view = previewView, let cornersView = cornersView, blurBackground else { return }
        
        // Define the scanning rect to show a whole in the blur overlay
        let holeView:UIView = .init()
        holeView.backgroundColor = .clear
        view.addSubview(holeView)
        holeView.translatesAutoresizingMaskIntoConstraints = false
        
        //make.centerY.equalToSuperview().priority(.high)
        //make.height.equalTo(holeView.snp.width).multipliedBy(0.66).priority(.high)
        
        // Map the correct constraints to match the PayCards SDK scanning rect
        let spacing:CGFloat = 3.5
        
        let constraints:[NSLayoutConstraint] = [
            holeView.leadingAnchor.constraint(equalTo: cornersView.leadingAnchor,constant: spacing),
            holeView.trailingAnchor.constraint(equalTo: cornersView.trailingAnchor,constant: -spacing),
            holeView.topAnchor.constraint(equalTo: cornersView.topAnchor, constant: spacing),
            holeView.bottomAnchor.constraint(equalTo: cornersView.bottomAnchor, constant: -spacing),
            holeView.centerYAnchor.constraint(equalTo: holeView.superview!.centerYAnchor),
            holeView.centerXAnchor.constraint(equalTo: holeView.superview!.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        holeView.layoutIfNeeded()
        
        // Give it a little time to redraw itself then draw the whole around the copumted frame above
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            let outerbezierPath = UIBezierPath.init(roundedRect: blurEffectView.frame, cornerRadius: 0)
            let rect = holeView.frame
            let innerCirclepath = UIBezierPath.init(roundedRect: rect,byRoundingCorners: .allCorners,
                                                    cornerRadii: CGSize(width: 8, height: 8))
            outerbezierPath.append(innerCirclepath)
            outerbezierPath.usesEvenOddFillRule = false
            let fillLayer = CAShapeLayer()
            fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
            fillLayer.fillColor = UIColor.black.cgColor
            fillLayer.path = outerbezierPath.cgPath
            blurEffectView.layer.mask = fillLayer
            //holeView.removeFromSuperview()
        }
    }
    
    /**
     This is the method responsible for POST action of successful scanning
     - Parameter scannedCard: Whoever calling, will have to pass the scanned card
     */
    internal func scannerScanned(scannedCard:TapCard) {
        //FlurryLogger.endTimerForEvent(with: "Scan_Inline_Called", params: ["success":"true","error":"","card_number":scannedCard.tapCardNumber ?? "","card_name":scannedCard.tapCardName ?? "","card_month":scannedCard.tapCardExpiryMonth ?? "","card_year":scannedCard.tapCardExpiryYear ?? ""])
        
        // Check if the scanned block is initialised, hence, utilise it and send the scannedCard to it
        delegate?.tapCardScannerDidFinish(with: scannedCard)
        cornersView?.updateCorners(with: .scanned)
    }
    
    /**
     This method shall be called once the parent app wants to stop the scanning and remove the preview view
     - Parameter stopCamera: If not set, then camera feed will still be shown in the view but no actual scanning, if set, it will destroy itself
     */
    @objc public func pauseScanner(stopCamera:Bool) {
        if stopCamera {
            stopScanner()
        }
    }
    
    /**
     This method shall be called once the parent app wants to resume the scanner again.
     */
    @objc public func resumeScanner() {
        /*if let nonNullScanner = cardScanner {
         nonNullScanner.resumeRecognizer()
         }*/
        cameraView.startSession()
        cornersView?.updateCorners(with: .normal)
    }
    
    internal func stopScanner() {
        //FlurryLogger.endTimerForEvent(with: "Scan_Inline_Called")
        /*if let nonNullScanner = cardScanner {
         nonNullScanner.stopCamera()
         }*/
        //cornersView?.updateCorners(with: .normal)
        cameraView.stopSession()
    }
    
    /**
     This is a public interface that should be called ONLY once  you get call back from the timeout block
     */
    @objc public func resetTimeOutTimer() {
        
        // Defensive code to check the user really needs to have a timeout and did not pass it as -1
        if timeOutPeriod > 0 {
            // Fire  the block after the  stated period
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timeOutPeriod)) { [weak self] in
                if let nonNullSelf = self {
                    nonNullSelf.dispatchTimeOutBlock()
                }
            }
        }
        
    }
    
    /// A helper method reponsible for executing the timeout block if exists
    internal func dispatchTimeOutBlock() {
        delegate?.tapInlineCardScannerTimedOut(for: self)
    }
}


extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

// MARK: - CamerView delegate methods

extension TapInlineCardScanner: CameraViewDelegate {
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }
    
    internal func didError(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cameraView.stopSession()
        }
    }
}

// MARK: - Image analyzer delegate methods
extension TapInlineCardScanner: ImageAnalyzerProtocol {
    internal func didFinishAnalyzation(with result: Result<TapCard, Error>) {
        switch result {
            // In case of success we need to inform the delegate that we have scanned a card
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.scannerScanned(scannedCard: creditCard)
                strongSelf.pauseScanner(stopCamera: false)
            }
            // In case of failuer for any reason we send back an empty card details
        case .failure(_):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.tapCardScannerDidFinish(with: .init())
            }
        }
    }
}

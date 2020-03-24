//
//  TapInlineCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class AVFoundation.AVCaptureDevice
import struct AVFoundation.AVMediaType
import class UIKit.UIImagePickerController
import class UIKit.UIView
import class UIKit.UIColor
import PayCardsRecognizer

/// This class represents the tap inline scanner UI controller.
@objc public class TapInlineCardScanner:NSObject,TapScannerProtocl {
    
    /// This block fires when the scanner finished scanning
    var tapCardScannerDidFinish:((ScannedTapCard)->())?
    /// This block fires when the scanner finished scanning
    var tapInlineCardScannerTimedOut:((TapInlineCardScanner)->())?
    
    /// This is the timeout period for the current scanner, -1 means it doesn't have one and will keep showing until parent app decides not to
    internal lazy var timeOutPeriod:Int = -1
    /// This is the UIView that scanner/camera feed will show inside it
    internal var previewView:UIView?
    /// This is the color of scan the card border. Default is green
    internal lazy var scanningBorderColor:UIColor = .green
    /// This is the backbone of the scanner object
    internal var cardScanner:PayCardsRecognizer?
    /**
     This interface decides whether the scanner can start or not based on camera usage permission granted and camera does exist.
     - Returns: TapCanScanStatusResult enum which has three values: .CanStart if all good, .CameraMissing if camera doesn't exist and .CameraPermissionMissing Scanning cannot start as camera usage permission is not granted
     */
    @objc public static func CanScan() -> TapCanScanStatusResult {
        
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
    
    
    /**
        This interface starts the scanner by showing the camera feed in the given view with the customisation parameter.
     - Parameter previewView: This is the UIView that scanner/camera feed will show inside it
     - Parameter scanningBorderColor: This is the color of scan the card border. Default is green
     - Parameter timoutAfter: This decides when the scanner should timeout (fires the timeout callback) in seconds. Default is -1 which means no timeout is required
     - Parameter didTimout: A block that will be called after the timeout period
     - Parameter cardScanned: A block that will be called once a card has been scanned
     */
    @objc public func startScanning(in previewView:UIView, scanningBorderColor:UIColor = .green, timoutAfter:Int = -1,didTimout:((TapInlineCardScanner)->())? = nil, cardScanned:((ScannedTapCard)->())? = nil) throws {
        
        // Check if scanner can start first
        guard TapInlineCardScanner.CanScan() == .CanStart else {
            throw TapInlineCardScanner.CanScan().rawValue
        }
        
        // hold the customisations
        self.previewView = previewView
        self.scanningBorderColor = scanningBorderColor
        self.timeOutPeriod = timoutAfter
        
        // Configure and restart the recognizer
        configureScanner()
        
        // Double check all is good
        if let _ = cardScanner {
            startScanning()
        }else {
            throw "Preview view is not defined"
        }
    }
    
    /// This method is responsible for starting the camera feed logic
    internal func startScanning() {
        cardScanner?.startCamera(with: .portrait)
    }
    
    /// This method is responsible for configuring the card scanner object and attach it inside the required view with the needed customisations
    internal func configureScanner() {
        
        // Defensive code to check there is a holding view
        if let nonNullPreviewView = self.previewView {
            cardScanner = PayCardsRecognizer(delegate: self, resultMode: .async, container: nonNullPreviewView, frameColor: scanningBorderColor)
        }else {
            cardScanner = nil
        }
    }
    
    /**
        This is the method responsible for POST action of successful scanning
     - Parameter scannedCard: Whoever calling, will have to pass the scanned card
     */
    internal func scannerScanned(scannedCard:ScannedTapCard) {
        // Check if the scanned block is initialised, hence, utilise it and send the scannedCard to it
        if let tapCardScannerDidFinishBlock = tapCardScannerDidFinish {
            tapCardScannerDidFinishBlock(scannedCard)
        }
    }
    
    /**
     This method shall be called once the parent app wants to stop the scanning and remove the preview view
     - Parameter stopCamera: If not set, then camera feed will still be shown in the view but no actual scanning, if set, it will destroy itself
     */
    @objc public func pauseScanner(stopCamera:Bool) {
        
        if let nonNullScanner = cardScanner {
            nonNullScanner.pause()
            if stopCamera {
                stopScanner()
            }
        }
    }
    
    internal func stopScanner() {
        
        if let nonNullScanner = cardScanner {
            nonNullScanner.stopCamera()
        }
    }
}

extension TapInlineCardScanner:PayCardsRecognizerPlatformDelegate {
    public func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted {
            // Scanner captured semi/complete card details
            scannerScanned(scannedCard: .init(scannedCardNumber: result.recognizedNumber, scannedCardName: result.recognizedHolderName, scannedCardExpiryMonth: result.recognizedExpireDateMonth, scannedCardExpiryYear: result.recognizedExpireDateYear))
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

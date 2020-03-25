//
//  TapFullScreenScannerViewController.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 25/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import class UIKit.UIView
import class UIKit.UIButton
import class UIKit.UIViewController
import PayCardsRecognizer

/// The view controller handling the full screen scanner
internal class TapFullScreenScannerViewController: UIViewController {

    /// This is the view that holds the cancel button at the bottom
    @IBOutlet weak var cancelButtonViewHolder: UIView!
    /// This is the cancel button
    @IBOutlet weak var cancelButton: UIButton!
    /// This is the view that holds the camera feed for the scanner
    @IBOutlet weak var scanningPreviewView: UIView!
    
    var scanner:PayCardsRecognizer?
    
    /// This block fires when the scanner finished scanning
    internal var tapFullCardScannerDidFinish:((ScannedTapCard)->())?
    /// This block fires when the scanner finished scanning
    internal var tapFullCardScannerDimissed:(()->())?
    
    lazy internal var scannerUICustomization:TapFullScreenUICustomizer = TapFullScreenUICustomizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Apply the UI
        configureUI()
        // Start the scanner
        configureScanner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanner?.stopCamera()
    }
    
    /**
        The method that is responsible for the dismissing logic
     - Parameter callDismissBlock: A boolean that will indicate based on the contextt of the caller logic flow. If true, then the dismiss block will be called.
     */
    internal func dismissScanner(callDismissBlock:Bool = true) {
        self.dismiss(animated: true) { [weak self] in
            // Check if the caller wants to call the dismiss block
            if callDismissBlock {
                if let dismissBlock = self?.tapFullCardScannerDimissed {
                    dismissBlock()
                }
            }
        }
    }
    
    /**
       The method that is responsible for the passing back the scanning results logic
    - Parameter result: The result scanned from the scanner
    */
    internal func cardScannedHandler(result: PayCardsRecognizerResult) {
        // Create the ScannedTapCard from the scanner result
        let tapCardScanned:ScannedTapCard = .init(scannedCardNumber: result.recognizedNumber, scannedCardName: result.recognizedHolderName, scannedCardExpiryMonth: result.recognizedExpireDateMonth, scannedCardExpiryYear: result.recognizedExpireDateYear)
        
        // If there is a scanned block then call it with the result
        if let scannedBlock = tapFullCardScannerDidFinish {
            scannedBlock(tapCardScanned)
            dismissScanner(callDismissBlock: false)
        }else {
            dismissScanner(callDismissBlock: true)
        }
    }
    
    /// This method is responsible for configuring the scanner logic
    internal func configureScanner() {
        scanner = PayCardsRecognizer(delegate: self, resultMode: .async, container: scanningPreviewView, frameColor: scannerUICustomization.tapFullScreenScanBorderColor)
        scanner?.startCamera()
    }
    
    /// This method is responsible for applying the ui customization for the full screen scanner
    internal func configureUI() {
        // Cancel button configuration
        cancelButton.setTitle(scannerUICustomization.tapFullScreenCancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(scannerUICustomization.tapFullScreenCancelButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = scannerUICustomization.tapFullScreenCancelButtonFont
        
        // Cancel holder configuration
        cancelButtonViewHolder.backgroundColor = scannerUICustomization.tapFullScreenCancelButtonHolderViewColor
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismissScanner()
    }
}

extension TapFullScreenScannerViewController:PayCardsRecognizerPlatformDelegate {
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted {
            cardScannedHandler(result: result)
        }
    }
}

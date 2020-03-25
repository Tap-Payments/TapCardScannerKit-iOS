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

internal class TapFullScreenScannerViewController: UIViewController {

    @IBOutlet weak var cancelButtonViewHolder: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scanningPreviewView: UIView!
    
    var scanner:PayCardsRecognizer?
    
    /// This block fires when the scanner finished scanning
    internal var tapFullCardScannerDidFinish:((ScannedTapCard)->())?
    /// This block fires when the scanner finished scanning
    internal var tapFullCardScannerDimissed:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScanner()
    }
    
    internal func dismissScanner(callDismissBlock:Bool = true) {
        self.dismiss(animated: true) { [weak self] in
            if callDismissBlock {
                if let dismissBlock = self?.tapFullCardScannerDimissed {
                    dismissBlock()
                }
            }
        }
    }
    
    internal func cardScannedHandler(result: PayCardsRecognizerResult) {
        let tapCardScanned:ScannedTapCard = .init(scannedCardNumber: result.recognizedNumber, scannedCardName: result.recognizedHolderName, scannedCardExpiryMonth: result.recognizedExpireDateMonth, scannedCardExpiryYear: result.recognizedExpireDateYear)
        
        if let scannedBlock = tapFullCardScannerDidFinish {
            scannedBlock(tapCardScanned)
            dismissScanner(callDismissBlock: false)
        }else {
            dismissScanner(callDismissBlock: true)
        }
    }
    
    internal func configureScanner() {
        scanner = PayCardsRecognizer(delegate: self, resultMode: .async, container: scanningPreviewView, frameColor: .green)
        scanner?.startCamera()
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

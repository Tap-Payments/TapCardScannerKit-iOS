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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScanner()
    }
    
    internal func configureScanner() {
        scanner = PayCardsRecognizer(delegate: self, resultMode: .async, container: scanningPreviewView, frameColor: .green)
        scanner?.startCamera()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TapFullScreenScannerViewController:PayCardsRecognizerPlatformDelegate {
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        self.closeClicked(result)
    }
}

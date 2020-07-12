//
//  InlineScannerDemoViewController.swift
//  TapCardScannerExample
//
//  Created by Osama Rabie on 26/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapCardScanner_iOS
import class CommonDataModelsKit_iOS.TapCard

class InlineScannerDemoViewController: UIViewController {

    lazy var scannerBorderColor:UIColor = .green
    lazy var timeout:Int = -1
    lazy var tapInlineScanner:TapInlineCardScanner = .init()
    
   
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tapInlineScanner.delegate = self
        do{
            try tapInlineScanner.startScanning(in: previewView, scanningBorderColor: scannerBorderColor,blurBackground: true,showTapCorners: true, timoutAfter: timeout)
        }catch{}
        
        view.bringSubviewToFront(previewView)
        previewView.bringSubviewToFront(previewView.viewWithTag(89)!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension InlineScannerDemoViewController:TapInlineScannerProtocl {
    func tapFullCardScannerDimissed() {
        
    }
    
    func tapCardScannerDidFinish(with tapCard: TapCard) {
        let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(tapCard.tapCardNumber ?? "")\nCard Name : \(tapCard.tapCardName ?? "")\nCard Expiry : \(tapCard.tapCardExpiryMonth ?? "")/\(tapCard.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
        let stopAlertAction:UIAlertAction = UIAlertAction(title: "Stop Scanning", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.pauseScanner(stopCamera: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let scanAgainAlertAction:UIAlertAction = UIAlertAction(title: "Scan Again", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.resumeScanner()
            }
        }
        alert.addAction(stopAlertAction)
        alert.addAction(scanAgainAlertAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){ [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func tapInlineCardScannerTimedOut(for inlineScanner: TapInlineCardScanner) {
        let alert:UIAlertController = UIAlertController(title: "TimeOut", message: "The timeout period ended and the scanner didn't get any card from the camera feed :(", preferredStyle: .alert)
        let stopAlertAction:UIAlertAction = UIAlertAction(title: "Stop Scanning", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.pauseScanner(stopCamera: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let scanAgainAlertAction:UIAlertAction = UIAlertAction(title: "Reset Timeout", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.tapInlineScanner.resumeScanner()
                self?.tapInlineScanner.resetTimeOutTimer()
            }
        }
        alert.addAction(stopAlertAction)
        alert.addAction(scanAgainAlertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

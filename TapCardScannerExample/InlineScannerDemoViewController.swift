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
        
        let timeOutBlock:(TapInlineCardScanner) -> () = { [weak self] scanner in
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
        
        let scannedBlock:(TapCard) -> () = { [weak self] scannedCard in
            
            let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(scannedCard.tapCardNumber ?? "")\nCard Name : \(scannedCard.tapCardName ?? "")\nCard Expiry : \(scannedCard.tapCardExpiryMonth ?? "")/\(scannedCard.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
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
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        do{
            try tapInlineScanner.startScanning(in: previewView, scanningBorderColor: scannerBorderColor,blurBackground: true, timoutAfter: timeout, didTimout: ((timeout == -1) ? nil : timeOutBlock), cardScanned: scannedBlock)
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

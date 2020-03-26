//
//  InlineScannerDemoViewController.swift
//  TapCardScannerExample
//
//  Created by Osama Rabie on 26/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapCardScanner_iOS

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
            
        }
        
        let scannedBlock:(ScannedTapCard) -> () = { [weak self] scannedCard in
            
            let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(scannedCard.scannedCardNumber ?? "")\nCard Name : \(scannedCard.scannedCardName ?? "")\nCard Expiry : \(scannedCard.scannedCardExpiryMonth ?? "")/\(scannedCard.scannedCardExpiryYear ?? "")\n", preferredStyle: .alert)
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
            try tapInlineScanner.startScanning(in: previewView, scanningBorderColor: scannerBorderColor, timoutAfter: timeout, didTimout: ((timeout == -1) ? nil : timeOutBlock), cardScanned: scannedBlock)
        }catch{}
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

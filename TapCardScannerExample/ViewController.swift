//
//  ViewController.swift
//  TapCardScannerExample
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import AVFoundation
import TapCardScanner_iOS

class ViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func scanClicked(_ sender: Any) {
        //Camera
        AVCaptureDevice.requestAccess(for: .video) { [weak self] response in
            if response {
                
            } else {

            }
        }

    }
}


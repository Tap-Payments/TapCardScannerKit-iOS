//
//  ScannerOptionsTableViewController.swift
//  TapCardScannerExample
//
//  Created by Osama Rabie on 26/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapCardScanner_iOS
import SheetyColors
import AVFoundation
import CommonDataModelsKit_iOS

class ScannerOptionsTableViewController: UITableViewController {

    var fullScanner:TapFullScreenScannerViewController?
    lazy var activityIndicatorBase : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:60.0, height:60.0);
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.orange
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            handleScannerStatus()
        }else if indexPath.row == 1 {
            handleInlineScanner()
        }else if indexPath.row == 2 {
            handleFullScanner()
        }else if indexPath.row == 3 {
            handleStaticImageScanner()
        }
    }
    
    func handleStaticImageScanner() {
        let alertControl: UIAlertController = .init(title: "Scan card from image", message: "Choose image source", preferredStyle: .actionSheet)
        let libraryAction:UIAlertAction = .init(title: "Library", style: .default) { (_) in
            DispatchQueue.main.async { [weak self] in
               let imagePicker:UIImagePickerController =  UIImagePickerController()
                          imagePicker.delegate = self
                          imagePicker.allowsEditing = true
                          imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                          imagePicker.allowsEditing = true
                          self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cameraAction:UIAlertAction = .init(title: "Camera", style: .default) { [weak self] (_) in
            
            DispatchQueue.main.async {[weak self] in
                if let cameraViewController:CameraViewController = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
                    cameraViewController.delegate = self
                    self?.navigationController?.pushViewController(cameraViewController, animated: true)
                }
            }
        }
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .cancel, handler: nil)
        alertControl.addAction(libraryAction)
        alertControl.addAction(cameraAction)
        alertControl.addAction(cancelAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func handleScannerStatus() {
        let alertControl: UIAlertController = .init(title: "Scanner Status", message: TapInlineCardScanner.CanScan().rawValue, preferredStyle: .alert)
        let okAction:UIAlertAction = .init(title: "OK", style: .cancel, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func handleInlineScanner() {
        let alertControl: UIAlertController = .init(title: "Inline Scanner Opttions", message:"Those are the ways developers can customise their experience with the inline scanner", preferredStyle: .actionSheet)
       
        let defaultAction:UIAlertAction = .init(title: "Default, no timeout and border color is green", style: .destructive, handler: { [weak self] (_) in
            self?.showInlineScanner()
        })
        
        alertControl.addAction(defaultAction)
        
        let customiseAction:UIAlertAction = .init(title: "Timeout for inactive scanner after 30 seconds of unsuccessufl scanning.\nCustomised border color", style: .default, handler: { [weak self] (_) in
            // Create a SheetyColors view with your configuration
            let config = SheetyColorsConfig(alphaEnabled: true, hapticFeedbackEnabled: true, initialColor: .green, title: "Scanner Border Color", type: .rgb)
            let sheetyColors = SheetyColorsController(withConfig: config)

            // Add a button to accept the selected color
            let selectAction = UIAlertAction(title: "Select Color", style: .destructive, handler: { [weak self] _ in
                self?.showInlineScanner(borderColor: sheetyColors.color, timeout: 30)
            })
                
            sheetyColors.addAction(selectAction)

            // Add a cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] _ in
                self?.showInlineScanner(timeout: 30)
            })
            sheetyColors.addAction(cancelAction)

            // Now, present it to the user
            self?.present(sheetyColors, animated: true, completion: nil)
        })
        alertControl.addAction(customiseAction)
        
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .cancel, handler: nil)
        alertControl.addAction(cancelAction)
        self.present(alertControl, animated: true, completion: nil)
        
        UILabel.appearance(whenContainedInInstancesOf:
        [UIAlertController.self]).numberOfLines = 2

        UILabel.appearance(whenContainedInInstancesOf:
        [UIAlertController.self]).lineBreakMode = .byWordWrapping
    }
    
    
    func handleFullScanner() {
        let alertControl: UIAlertController = .init(title: "Full Scanner Opttions", message:"Those are the ways developers can customise their experience with the full scanner", preferredStyle: .actionSheet)
       
        let defaultAction:UIAlertAction = .init(title: "Default for border color and cancel button title", style: .destructive, handler: { [weak self] (_) in
            self?.showFullScanner()
        })
        
        alertControl.addAction(defaultAction)
        
        let customiseAction:UIAlertAction = .init(title: "Colors and localisations for full screen customisation", style: .default, handler: { [weak self] (_) in
            
            DispatchQueue.main.async {[weak self] in
                if let fullScreenCustomiseDemoController:TapFullScannerCustomisationTableViewController = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TapFullScannerCustomisationTableViewController") as? TapFullScannerCustomisationTableViewController {
                    fullScreenCustomiseDemoController.delegate = self
                    self?.navigationController?.pushViewController(fullScreenCustomiseDemoController, animated: true)
                }
            }
        })
        alertControl.addAction(customiseAction)
        
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .cancel, handler: nil)
        alertControl.addAction(cancelAction)
        self.present(alertControl, animated: true, completion: nil)
        
        UILabel.appearance(whenContainedInInstancesOf:
        [UIAlertController.self]).numberOfLines = 2

        UILabel.appearance(whenContainedInInstancesOf:
        [UIAlertController.self]).lineBreakMode = .byWordWrapping
    }
    
    
    func showFullScanner(with customiser: TapFullScreenUICustomizer = .init()) {
        // First grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.async {[weak self] in
                    self?.fullScanner = TapFullScreenScannerViewController()
                    self?.fullScanner?.delegate = self
                    self?.present((self?.fullScanner)!, animated: true)
                }
            }else {
                
            }
        }
    }
    
    func showInlineScanner(borderColor:UIColor = .green, timeout:Int = -1) {
        // First grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.async {[weak self] in
                    if let inlineDemoController:InlineScannerDemoViewController = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "InlineScannerDemoViewController") as? InlineScannerDemoViewController{
                        inlineDemoController.scannerBorderColor = borderColor
                        inlineDemoController.timeout = timeout
                        self?.navigationController?.pushViewController(inlineDemoController, animated: true)
                    }
                }
                
            } else {
                //access denied
            }
        }
    }
    
    func showStaticScanner(from pickedImage:UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.backgroundView = self?.activityIndicatorBase
            self?.tableView.isUserInteractionEnabled = false
            let staticInlineScanner:TapInlineCardScanner = .init()
            staticInlineScanner.ScanCard(from: pickedImage,maxDataSize: 250,minCompression: 0.4,cardScanned: { scannedCard in
                let alertControl:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(scannedCard.tapCardNumber ?? "")\nCard Name : \(scannedCard.tapCardName ?? "")\nCard Expiry : \(scannedCard.tapCardExpiryMonth ?? "")/\(scannedCard.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
                
                let okAction:UIAlertAction = .init(title: "OK", style: .cancel, handler: nil)
                alertControl.addAction(okAction)
                DispatchQueue.main.async { [weak self] in
                    self?.present(alertControl, animated: true, completion: nil)
                    self?.tableView.backgroundView = nil
                    self?.tableView.isUserInteractionEnabled = true
                }
            }, onErrorOccured: { error in
                let alertControl: UIAlertController = .init(title: "Error happened", message: error, preferredStyle: .alert)
                
                let okAction:UIAlertAction = .init(title: "OK", style: .cancel, handler: nil)
                alertControl.addAction(okAction)
                DispatchQueue.main.async { [weak self] in
                    self?.present(alertControl, animated: true, completion: nil)
                    self?.tableView.backgroundView = nil
                    self?.tableView.isUserInteractionEnabled = true
                }
            })
        }
    }

}


extension ScannerOptionsTableViewController:TapFullScannerCustomisationDelegate {
    func customisationDone(with customiser: TapFullScreenUICustomizer) {
        showFullScanner(with: customiser)
    }
}

extension ScannerOptionsTableViewController:CameraViewControllerDelegate {
    func photoCaptured(with image: UIImage) {
        self.navigationController?.popViewController(animated: true)
        self.showStaticScanner(from: image)
    }
}


extension ScannerOptionsTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async { [unowned picker, weak self] in
            picker.dismiss(animated: true) { [weak self] in
                if let pickedImage = info[.originalImage] as? UIImage {
                    self?.showStaticScanner(from: pickedImage)
                }
            }
        }
    }
}

extension ScannerOptionsTableViewController:TapCreditCardScannerViewControllerDelegate {
    func creditCardScannerViewControllerDidCancel(_ viewController: TapFullScreenScannerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didErrorWith error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didFinishWith card: TapCard) {
        let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(card.tapCardNumber ?? "")\nCard Name : \(card.tapCardName ?? "")\nCard Expiry : \(card.tapCardExpiryMonth ?? "")/\(card.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
        let stopAlertAction:UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            
        }
        
        alert.addAction(stopAlertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

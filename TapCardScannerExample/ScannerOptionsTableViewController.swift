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

class ScannerOptionsTableViewController: UITableViewController {

    lazy var fullScanner:TapFullScreenCardScanner = TapFullScreenCardScanner()
    
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
        }
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
        
        do {
            try fullScanner.showModalScreen(presenter: self,tapCardScannerDidFinish: { [weak self] (scannedCard) in
                
                let alert:UIAlertController = UIAlertController(title: "Scanned", message: "Card Number : \(scannedCard.scannedCardNumber ?? "")\nCard Name : \(scannedCard.scannedCardName ?? "")\nCard Expiry : \(scannedCard.scannedCardExpiryMonth ?? "")/\(scannedCard.scannedCardExpiryYear ?? "")\n", preferredStyle: .alert)
                let stopAlertAction:UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                    
                }
                
                alert.addAction(stopAlertAction)
                DispatchQueue.main.async { [weak self] in
                    self?.present(alert, animated: true, completion: nil)
                }
            },scannerUICustomization: customiser)
        }catch{
            print(error.localizedDescription)
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ScannerOptionsTableViewController:TapFullScannerCustomisationDelegate {
    func customisationDone(with customiser: TapFullScreenUICustomizer) {
        showFullScanner(with: customiser)
    }
}

//
//  TapFullScannerCustomisationTableViewController.swift
//  TapCardScannerExample
//
//  Created by Osama Rabie on 26/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapCardScanner_iOS
import SheetyColors

protocol TapFullScannerCustomisationDelegate {
    func customisationDone(with customiser: TapFullScreenUICustomizer)
}

class TapFullScannerCustomisationTableViewController: UITableViewController {

    lazy var tapFullScreenCustomiser:TapFullScreenUICustomizer = .init()
    var delegate:TapFullScannerCustomisationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullScreenScannerCstomiseCell", for: indexPath)

        // Configure the cell...

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Cancel button title"
            cell.detailTextLabel?.text = "Value : \(tapFullScreenCustomiser.tapFullScreenCancelButtonTitle)"
            break
        case 1:
            cell.textLabel?.text = "Cancel button title color"
            cell.detailTextLabel?.text = "Make it looks like your app's design"
            cell.detailTextLabel?.textColor = tapFullScreenCustomiser.tapFullScreenCancelButtonTitleColor
            break
        case 2:
            cell.textLabel?.text = "Cancel view background color"
            cell.detailTextLabel?.text = "Make the cancel area looks like your app's design"
            cell.detailTextLabel?.textColor = tapFullScreenCustomiser.tapFullScreenCancelButtonHolderViewColor
            break
        case 3:
            cell.textLabel?.text = "Scanner border color"
            cell.detailTextLabel?.text = "Set the scanner border color"
            cell.detailTextLabel?.textColor = tapFullScreenCustomiser.tapFullScreenScanBorderColor
            break
        default:
            break
        }
        
        return cell
    }
    
    @IBAction func showScannerClicked(_ sender: Any) {
        
        self.dismiss(animated: true) { [weak self] in
            if let nonNullDelegate = self?.delegate {
                nonNullDelegate.customisationDone(with: (self?.tapFullScreenCustomiser) ?? .init())
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // cretea alert control with given title and message
            let ac = UIAlertController(title: title, message: "Cancel title", preferredStyle: .alert)
            ac.addTextField(configurationHandler: nil)
            // Define what to do when the user fills in the value
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac, weak self] _ in
                let answer = ac.textFields![0]
                self?.tapFullScreenCustomiser.tapFullScreenCancelButtonTitle = (answer.text ?? "" == "") ? "Cancel" : answer.text!
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            DispatchQueue.main.async {[weak self] in
                self?.present(ac, animated: true, completion: nil)
            }
            break
        case 1:
            showColorPicker(with: tapFullScreenCustomiser.tapFullScreenCancelButtonTitleColor, title: "Cancel button title color") { [weak self] (selectedColor) in
                self?.tapFullScreenCustomiser.tapFullScreenCancelButtonTitleColor = selectedColor
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
            break
        case 2:
            showColorPicker(with: tapFullScreenCustomiser.tapFullScreenCancelButtonHolderViewColor, title: "Cancel button holder color") { [weak self] (selectedColor) in
                self?.tapFullScreenCustomiser.tapFullScreenCancelButtonHolderViewColor = selectedColor
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
            break
        case 3:
            showColorPicker(with: tapFullScreenCustomiser.tapFullScreenScanBorderColor, title: "Scanner border color") { [weak self] (selectedColor) in
                self?.tapFullScreenCustomiser.tapFullScreenScanBorderColor = selectedColor
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
            break
        default:
            break
        }
    }
    
    
    internal func showColorPicker(with defaultColor:UIColor,title:String,selectedBlock: @escaping ((UIColor)->())) {
        
        // Create a SheetyColors view with your configuration
        let config = SheetyColorsConfig(alphaEnabled: true, hapticFeedbackEnabled: true, initialColor: defaultColor, title: title, type: .rgb)
        let sheetyColors = SheetyColorsController(withConfig: config)

        // Add a button to accept the selected color
        let selectAction = UIAlertAction(title: "Select Color", style: .destructive, handler: { _ in
            selectedBlock(sheetyColors.color)
        })
            
        sheetyColors.addAction(selectAction)

        // Add a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetyColors.addAction(cancelAction)

        // Now, present it to the user
        self.present(sheetyColors, animated: true, completion: nil)
        
    }
    
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

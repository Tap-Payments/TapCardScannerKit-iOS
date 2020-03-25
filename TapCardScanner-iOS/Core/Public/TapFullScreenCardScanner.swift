//
//  TapFullScreenCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 25/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard
import class UIKit.UIViewController

/// This class represents the tap full scanner UIViewController.
@objc public class TapFullScreenCardScanner:NSObject {
   
    
    /**
     This method starts the TAP full screen controller as modal controller
     - Parameter presenter: The UIViewController the TAP scanner will be presented from
     - Parameter tapFullCardScannerDimissed: The dismiss block that will be called if the user clicks on the cancel button
     - Parameter tapCardScannerDidFinish: The block that will be called whenver a card has been scanned
     */
    @objc public func showModalScreen(presenter:UIViewController,tapFullCardScannerDimissed: (() -> ())? = nil,tapCardScannerDidFinish:((ScannedTapCard)->())? = nil) throws {
        
        // Check if scanner can start first
        guard TapInlineCardScanner.CanScan() == .CanStart else {
            throw TapInlineCardScanner.CanScan().rawValue
        }
        
        // Instantiate the Full screen controller from the story board
        let bundle = Bundle(for: type(of: self))
        let kitStoryBoard:UIStoryboard = UIStoryboard.init(name: "TapScannerStoryboard", bundle: bundle)
        if let tapFullScreenScanner:TapFullScreenScannerViewController = kitStoryBoard.instantiateViewController(withIdentifier: "TapFullScreenScannerViewController") as? TapFullScreenScannerViewController {
            // Forward the blocks to the controller
            tapFullScreenScanner.tapFullCardScannerDidFinish = tapCardScannerDidFinish
            tapFullScreenScanner.tapFullCardScannerDimissed = tapFullCardScannerDimissed
            presenter.present(tapFullScreenScanner, animated: true, completion: nil)
        }
    }
}

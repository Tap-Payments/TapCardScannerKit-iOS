//
//  TapFullScreenCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 25/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard
import class UIKit.UIViewController
import class UIKit.UIFont
import class UIKit.UIColor
import class CommonDataModelsKit_iOS.TapCard

/// This class represents the tap full scanner UIViewController.
@objc public class TapFullScreenCardScanner:NSObject {
   
    
    /**
     This method starts the TAP full screen controller as modal controller
     - Parameter presenter: The UIViewController the TAP scanner will be presented from
     - Parameter tapFullCardScannerDimissed: The dismiss block that will be called if the user clicks on the cancel button
     - Parameter tapCardScannerDidFinish: The block that will be called whenver a card has been scanned
     - Parameter scannerUICustomization: Pass this object if you want to customise how the UI elements of the full screen scanner looks like. See [TapFullScreenUICustomizer](x-source-tag://TapFullScreenUICustomizer) for more details
     
     */
    @objc public func showModalScreen(presenter:UIViewController,tapFullCardScannerDimissed: (() -> ())? = nil,tapCardScannerDidFinish:((TapCard)->())? = nil,scannerUICustomization:TapFullScreenUICustomizer = TapFullScreenUICustomizer()) throws {
        //FlurryLogger.logEvent(with: "Scan_Full_Screen_Called", timed:true)
        
        // Check if scanner can start first
        guard TapInlineCardScanner.CanScan() == .CanStart else {
            //FlurryLogger.endTimerForEvent(with: "Scan_Full_Screen_Called", params: ["success":"false","error":TapInlineCardScanner.CanScan().rawValue])
            throw TapInlineCardScanner.CanScan().rawValue
        }
        
        // Instantiate the Full screen controller from the story board
        let bundle = Bundle(for: type(of: self))
        let kitStoryBoard:UIStoryboard = UIStoryboard.init(name: "TapScannerStoryboard", bundle: bundle)
        if let tapFullScreenScanner:TapFullScreenScannerViewController = kitStoryBoard.instantiateViewController(withIdentifier: "TapFullScreenScannerViewController") as? TapFullScreenScannerViewController {
            // Forward the blocks to the controller
            tapFullScreenScanner.tapFullCardScannerDidFinish = tapCardScannerDidFinish
            tapFullScreenScanner.tapFullCardScannerDimissed = tapFullCardScannerDimissed
            tapFullScreenScanner.scannerUICustomization = scannerUICustomization
            presenter.present(tapFullScreenScanner, animated: true, completion: nil)
        }
    }
}

/**
 This class represents the way you pass all the available ui customizations to be applied to tap full screen scanner
 - Tag: TapFullScreenUICustomizer
 **/
@objcMembers public class TapFullScreenUICustomizer:NSObject {
    
    /// The cancel button title default is "Cancel"
    public lazy var tapFullScreenCancelButtonTitle:String = "Cancel"
    /// The cancel button font default is system with 15
    public lazy var tapFullScreenCancelButtonFont:UIFont  = UIFont.systemFont(ofSize: 15)
    /// The cancel button color default is "White"
    public lazy var tapFullScreenCancelButtonTitleColor:UIColor  = .white
    /// The cancel button holder background color default is "Black"
    public lazy var tapFullScreenCancelButtonHolderViewColor:UIColor  = .black
    /// The borders of scan card color default is "Green"
    public lazy var tapFullScreenScanBorderColor:UIColor  = .green
}

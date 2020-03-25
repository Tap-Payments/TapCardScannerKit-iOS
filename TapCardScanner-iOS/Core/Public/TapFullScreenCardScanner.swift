//
//  TapFullScreenCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 25/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard
import class UIKit.UIViewController

/// This class represents the tap inline scanner UI controller.
@objc public class TapFullScreenCardScanner:NSObject {
   
    
    @objc public func showModalScreen(presenter:UIViewController,tapFullCardScannerDimissed: (() -> ())? = nil,tapCardScannerDidFinish:((ScannedTapCard)->())? = nil) {
        
        let bundle = Bundle(for: type(of: self))
        let kitStoryBoard:UIStoryboard = UIStoryboard.init(name: "TapScannerStoryboard", bundle: bundle)
        if let tapFullScreenScanner:TapFullScreenScannerViewController = kitStoryBoard.instantiateViewController(withIdentifier: "TapFullScreenScannerViewController") as? TapFullScreenScannerViewController {
            tapFullScreenScanner.tapFullCardScannerDidFinish = tapCardScannerDidFinish
            tapFullScreenScanner.tapFullCardScannerDimissed = tapFullCardScannerDimissed
            presenter.present(tapFullScreenScanner, animated: true, completion: nil)
        }
    }
}

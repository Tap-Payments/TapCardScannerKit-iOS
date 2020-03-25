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
@objc public class TapFullScreenCardScanner:NSObject,TapScannerProtocl {
    
    /// This block fires when the scanner finished scanning
    var tapCardScannerDidFinish:((ScannedTapCard)->())?
    /// This block fires when the scanner finished scanning
    var tapInlineCardScannerTimedOut:((TapInlineCardScanner)->())?
    
    @objc public func showModalScreen(presenter:UIViewController) {
        
        let bundle = Bundle(for: type(of: self))
        let kitStoryBoard:UIStoryboard = UIStoryboard.init(name: "TapScannerStoryboard", bundle: bundle)
        if let tapFullScreenScanner:TapFullScreenScannerViewController = kitStoryBoard.instantiateViewController(withIdentifier: "TapFullScreenScannerViewController") as? TapFullScreenScannerViewController {
            presenter.present(tapFullScreenScanner, animated: true, completion: nil)
        }
    }
}

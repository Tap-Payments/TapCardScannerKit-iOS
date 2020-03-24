//
//  TapScannerProtocl.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// This class will hold the shared methods/vars between different card scanners. This is to make sure that all are using same interfaces
internal protocol TapScannerProtocl:NSObject {
    
    
    /// This block fires when the scanner finished scanning
    var tapCardScannerDidFinish:((ScannedTapCard)->())? { get set }
    /// This block fires when the scanner finished scanning
    var tapInlineCardScannerTimedOut:((TapInlineCardScanner)->())? { get set }
}

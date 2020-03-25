//
//  ScannedTapCard.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// This is the model the scanner will return after scanning a card
@objc public class ScannedTapCard:NSObject {
    
    /// Represents the scanned card number if any. Otherwise, it will be nil
    @objc public var scannedCardNumber:String?
    /// Represents the scanned card name if any. Otherwise, it will be nil
    @objc public var scannedCardName:String?
    /// Represents the scanned card expiration month MM if any. Otherwise, it will be nil
    @objc public var scannedCardExpiryMonth:String?
    /// Represents the scanned card exxpiration year YYYY or YY if any. Otherwise, it will be nil
    @objc public var scannedCardExpiryYear:String?
    
    /**
     This is the default constructor for creating the ScannedTapCard model
     - Parameter scannedCardNumber: Represents the scanned card number if any. Otherwise, it will be nil
     - Parameter scannedCardName: Represents the scanned card name if any. Otherwise, it will be nil
     - Parameter scannedCardExpiryMonth: Represents the scanned card expiration month MM if any. Otherwise, it will be nil
     - Parameter scannedCardExpiryYear: Represents the scanned card exxpiration year YYYY or YY if any. Otherwise, it will be nil
     */
    @objc public init(scannedCardNumber:String? = nil,scannedCardName:String? = nil,scannedCardExpiryMonth:String? = nil, scannedCardExpiryYear:String? = nil) {
        
        super.init()
        
        self.scannedCardName = scannedCardName
        self.scannedCardNumber = scannedCardNumber
        self.scannedCardExpiryMonth = scannedCardExpiryMonth
        self.scannedCardExpiryYear = scannedCardExpiryYear
    }
    
}

//
//  Tax.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 6/13/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
/// Tax data model to be added to the payment items
@objcMembers public final class Tax: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Tax title.
    public var title: String
    
    /// Tax description.
    public var descriptionText: String?
    
    /// Tax amount and type whether fixed or percentage
    public var amount: AmountModificatorModel
    
    // MARK: Methods
    
    /// Initializes `Tax` with `title` and `amount`.
    ///
    /// - Parameters:
    ///   - title: Tax title.
    ///   - amount: Tax amount.
    public convenience init(title: String, amount: AmountModificatorModel) {
        
        self.init(title: title, descriptionText: nil, amount: amount)
    }
    
    /// Initializes `Tax` with `title`, `descriptionText` and `amount`.
    ///
    /// - Parameters:
    ///   - title: Tax title.
    ///   - descriptionText: Tax description.
    ///   - amount: Tax amount.
    public required init(title: String, descriptionText: String?, amount: AmountModificatorModel) {
        
        self.title = title
        self.amount = amount
        self.descriptionText = descriptionText
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case title              = "name"
        case descriptionText    = "description"
        case amount             = "amount"
    }
}

// MARK: - NSCopying
extension Tax: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let amountCopy = self.amount.copy() as! AmountModificatorModel
        
        return Tax(title: self.title, descriptionText: self.descriptionText, amount: amountCopy)
    }
}

//
//  CreateTokenSavedCard.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/7/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Model that holds existing card details for token creation.
public struct CreateTokenSavedCard: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card identifier.
    internal let cardIdentifier: String
    
    /// Customer identifier.
    internal let customerIdentifier: String
    
    // MARK: Methods
    
    /// Initializes the model with card identifier and customer identifier.
    ///
    /// - Parameters:
    ///   - cardIdentifier: Card identifier.
    ///   - customerIdentifier: Customer identifier.
    public init(cardIdentifier: String, customerIdentifier: String) {
        
        self.cardIdentifier = cardIdentifier
        self.customerIdentifier = customerIdentifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case cardIdentifier     = "card_id"
        case customerIdentifier = "customer_id"
    }
}

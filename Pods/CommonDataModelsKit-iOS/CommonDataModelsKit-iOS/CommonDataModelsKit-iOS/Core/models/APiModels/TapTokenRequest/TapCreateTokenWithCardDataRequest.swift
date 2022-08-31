//
//  TapCreateTokenWithCardDataRequest.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/7/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Request model for token creation with card data.
public struct TapCreateTokenWithCardDataRequest: TapCreateTokenRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card to create token for.
    internal let card: CreateTokenCard
    /// The api endpoint path for tokens
    public let route: TapNetworkPath = .tokens
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the request with card.
    ///
    /// - Parameter card: Card.
    public init(card: CreateTokenCard) {
        
        self.card = card
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case card = "card"
    }
}

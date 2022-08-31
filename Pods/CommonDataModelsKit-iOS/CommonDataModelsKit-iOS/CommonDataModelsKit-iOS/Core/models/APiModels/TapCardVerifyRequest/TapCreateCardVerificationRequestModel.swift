//
//  CreateCardVerificationRequest.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/6/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Create charge request model.
public struct TapCreateCardVerificationRequestModel: Encodable {
    
    /// Create charge request model.
    public init(is3DSecureRequired: Bool?, shouldSaveCard: Bool, metadata: TapMetadata?, customer: TapCustomer, currency: TapCurrencyCode, source: SourceRequest, redirect: TrackingURL) {
        self.is3DSecureRequired = is3DSecureRequired
        self.shouldSaveCard = shouldSaveCard
        self.metadata = metadata
        self.customer = customer
        self.currency = currency
        self.source = source
        self.redirect = redirect
    }
    
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Whether we need to activate 3ds or not
    public let is3DSecureRequired: Bool?
    
    /// Whether we need  to save the card
    public let shouldSaveCard: Bool
    
    /// Any additional data the merchant wants to attach to
    public let metadata: TapMetadata?
    
    /// The customer who is saving the card
    public let customer: TapCustomer
    
    /// The currency for the saved card
    public let currency: TapCurrencyCode
    
    /// The request source
    public let source: SourceRequest
    
    /// The url the merchant wants to repost the result to
    public let redirect: TrackingURL
    
    
    
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case is3DSecureRequired = "threeDSecure"
        case shouldSaveCard        = "save_card"
        case metadata            = "metadata"
        case customer            = "customer"
        case currency            = "currency"
        case source                = "source"
        case redirect            = "redirect"
    }
}

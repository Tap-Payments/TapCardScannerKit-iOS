//
//  TapCreateCardVerificationResponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/6/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Card Verification class.
@objcMembers public class TapCreateCardVerificationResponseModel: NSObject, Decodable, IdentifiableWithString {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier.
    public let identifier: String
    
    /// Object type.
    public let object: String
    
    /// Defines whether the object was created in live mode.
    public let isLiveMode: Bool
    
    /// Verification status.
    public let status: CardVerificationStatus
    
    /// Card currency.
    public let currency: TapCurrencyCode
    
    /// Defines whether 3D secure is required.
    public let is3DSecureRequired: Bool
    
    /// Defines whether the card should be saved.
    public let shouldSaveCard: Bool
    
    /// Metadata.
    public let metadata: TapMetadata?
    
    /// Authorization transaction details (authorization used internally to verify the card).
    public let transactionDetails: TransactionDetails
    
    /// Customer, the cardholder.
    public let customer: TapCustomer
    
    /// Source object.
    public let source: Source
    
    /// Redirect.
    public let redirect: TrackingURL
    
    /// Saved card.
    public let card: SavedCard
    
    /// The response message to display an error if any
    public let response: SaveCardResponse?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case object                 = "object"
        case isLiveMode             = "live_mode"
        case status                 = "status"
        case currency               = "currency"
        case is3DSecureRequired     = "threeDSecure"
        case shouldSaveCard         = "save_card"
        case metadata               = "metadata"
        case transactionDetails     = "transaction"
        case customer               = "customer"
        case source                 = "source"
        case redirect               = "redirect"
        case card                   = "card"
        case response               = "response"
    }
}

// MARK: - Retrievable
extension TapCreateCardVerificationResponseModel: Retrievable {
    
    public static var retrieveRoute: TapNetworkPath {
        
        return .cardVerification
    }
}


public protocol Retrievable: IdentifiableWithString, Decodable {
    
    static var retrieveRoute: TapNetworkPath { get }
}





/// Card Verification class.
@objcMembers public class SaveCardResponse: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// response message
    public let message: String?
    
    /// response code
    public let code: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case message                = "message"
        case code                   = "code"
    }
}

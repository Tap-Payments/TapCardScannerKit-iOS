//
//  OptionallyIdentifiableWithString.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 11/15/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// All models that have identifier are conforming to this protocol.
public protocol OptionallyIdentifiableWithString {
    
    // MARK: Properties
    
    /// Unique identifier of an object.
    var identifier: String? { get }
}


/// A protocol used to imply that the sub class has an array of supported currencies and can be filtered regarding it
public protocol FilterableByCurrency {
    
    var supportedCurrencies: [TapCurrencyCode] { get }
}

/// A protocol used to imply that the sub class has an array can be sorted by a given KEY
public protocol SortableByOrder {
    
    var orderBy: Int { get }
}


public protocol Authenticatable: Decodable {
    
    /// Unique object identifier.
    var identifier: String { get }
    
    /// Charge authentication if required.
    var authentication: Authentication? { get }
    
    /// Authentication route.
    static var authenticationRoute: TapNetworkPath { get }
}


public protocol AuthorizeProtocol: ChargeProtocol {
    
    /// Authorize action.
    var authorizeAction: AuthorizeActionResponse { get }
}



public protocol ChargeProtocol: Authenticatable, Retrievable {
    
    /// API version.
    var apiVersion: String { get }
    
    /// Amount.
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    var amount: Decimal { get }
    
    /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
    var currency: TapCurrencyCode { get }
    
    /// Customer.
    var customer: TapCustomer { get }
    
    /// Flag indicating whether the object exists in live mode or test mode.
    var isLiveMode: Bool { get }
    
    /// Defines if the card used in transaction was saved.
    var cardSaved: Bool { get }
    
    /// Objects of the same type share the same value
    var object: String { get }
    
    /// Information related to the payment page redirect.
    var redirect: TrackingURL { get }
    
    /// Post URL.
    var post: TrackingURL? { get }
    
    /// Saved card. Available only with card payment.
    var card: SavedCard? { get }
    
    /// Charge source.
    var source: Source { get }
    
    /// Charge destinations.
    var destinations: DestinationGroup? { get }
    
    /// Charge status.
    var status: ChargeStatus { get set }
    
    /// Defines if 3D secure is required for the transaction.
    var requires3DSecure: Bool { get }
    
    /// Transaction details.
    var transactionDetails: TransactionDetails { get }
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    var descriptionText: String? { get }
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    var metadata: TapMetadata? { get }
    
    /// Charge reference.
    var reference: Reference? { get }
    
    /// Receipt settings.
    var receiptSettings: Receipt? { get }
    
    /// Acquirer information.
    var acquirer: Acquirer? { get }
    
    /// Charge response.
    var response: Response? { get }
    
    /// Extra information about a charge.
    /// This will appear on your customer’s credit card statement.
    /// It must contain at least one letter.
    var statementDescriptor: String? { get }
}


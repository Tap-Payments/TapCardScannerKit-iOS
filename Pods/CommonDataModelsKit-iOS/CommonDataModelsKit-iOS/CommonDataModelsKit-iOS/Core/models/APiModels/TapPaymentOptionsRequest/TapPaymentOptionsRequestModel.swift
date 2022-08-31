//
//  TapPaymentOptionsRequest.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

public struct TapPaymentOptionsRequestModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Transaction mode.
    public let transactionMode: TransactionMode?
    
    /// Items to pay for.
    public let items: [ItemModel]?
    
    /// Items shippings.
    public var shipping: [Shipping]?
    
    /// Taxes.
    public var taxes: [Tax]?
    
    /// Items currency.
    public let currency: TapCurrencyCode?
    
    /// Merchant ID.
    public let merchantID: String?
    
    /// Customer (payer).
    public var customer: TapCustomer?
    
    /// List of destinations (grouped by "destination" key).
    public private(set) var destinationGroup: DestinationGroup?
    
    /// Payment type.
    public private(set) var paymentType: TapPaymentType = .All
    
    // MARK: Methods
    
    public init(customer: TapCustomer?) {
        
        self.init(transactionMode: nil, amount: nil, items: nil, shipping: nil, taxes: nil, currency: nil, merchantID: nil, customer: customer, destinationGroup: nil, paymentType: .All, totalAmount: 0)
    }
    
    public init(transactionMode:      TransactionMode?,
                  amount:               Double?,
                  items:                [ItemModel]?,
                  shipping:             [Shipping]?,
                  taxes:                [Tax]?,
                  currency:             TapCurrencyCode?,
                  merchantID:           String?,
                  customer:             TapCustomer?,
                  destinationGroup:     DestinationGroup?,
                  paymentType:          TapPaymentType,
                  totalAmount:          Double
                  
    ) {
        
        self.transactionMode        = transactionMode
        self.shipping               = shipping
        self.taxes                  = taxes
        self.currency               = currency
        self.merchantID             = merchantID
        self.customer               = (((customer?.identifier ?? "").tap_length == 0) && ((customer?.emailAddress?.value ?? "").tap_length == 0) && ((customer?.phoneNumber?.phoneNumber ?? "").tap_length == 0) ) ? nil : customer
        self.destinationGroup       = destinationGroup
        self.paymentType            = paymentType
        
        if let nonnullItems         = items, nonnullItems.count > 0 {
            
            self.items = items
        }
        else {
            
            self.items = nil
        }
        
        self.totalAmount = totalAmount
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case transactionMode        = "transaction_mode"
        case items                  = "items"
        case shipping               = "shipping"
        case taxes                  = "taxes"
        case currency               = "currency"
        case customer               = "customer"
        case totalAmount            = "total_amount"
        case merchantID             = "merchant_id"
        case destinationGroup       = "destinations"
        case paymentType            = "payment_type"
    }
    
    // MARK: Properties
    
    private let totalAmount: Double
}

// MARK: - Encodable
extension TapPaymentOptionsRequestModel: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.transactionMode, forKey: .transactionMode)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encodeIfPresent(self.paymentType, forKey: .paymentType)
        
        if self.shipping?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.shipping, forKey: .shipping)
        }
        
        if self.taxes?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.taxes, forKey: .taxes)
        }
        
        try container.encodeIfPresent(self.currency, forKey: .currency)
        
        try container.encodeIfPresent(self.merchantID, forKey: .merchantID)
        
        if let customer:TapCustomer = self.customer {
            // Check if we need to pass ONLY the customer ID of the full customer object
            if let customerID = customer.identifier {
                try container.encode(customerID, forKey: .customer)
            }else{
                try container.encodeIfPresent(customer, forKey: .customer)
            }
        }
        
        if self.totalAmount > 0.0 {
            
            try container.encodeIfPresent(self.totalAmount, forKey: .totalAmount)
        }
        
        if self.destinationGroup?.destinations?.count ?? 0 > 0 {
            
            try container.encodeIfPresent(self.destinationGroup, forKey: .destinationGroup)
        }
    }
}

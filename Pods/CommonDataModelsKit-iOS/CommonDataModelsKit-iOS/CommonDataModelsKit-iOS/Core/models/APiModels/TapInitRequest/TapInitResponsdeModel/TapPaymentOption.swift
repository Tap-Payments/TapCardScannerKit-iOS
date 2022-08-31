//
//  PaymentOption.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import struct PassKit.PKPaymentNetwork
import TapCardVlidatorKit_iOS
/// Payment Option model.
public struct PaymentOption: IdentifiableWithString {
    
    public init(identifier: String, brand: CardBrand, title: String, backendImageURL: URL, isAsync: Bool, paymentType: TapPaymentType, sourceIdentifier: String? = nil, supportedCardBrands: [CardBrand], supportedCurrencies: [TapCurrencyCode], orderBy: Int, threeDLevel: ThreeDSecurityState, savedCard: SavedCard? = nil, extraFees: [ExtraFee] = []) {
        self.identifier = identifier
        self.brand = brand
        self.title = title
        self.backendImageURL = backendImageURL
        self.isAsync = isAsync
        self.paymentType = paymentType
        self.sourceIdentifier = sourceIdentifier
        self.supportedCardBrands = supportedCardBrands
        self.supportedCurrencies = supportedCurrencies
        self.orderBy = orderBy
        self.threeDLevel = threeDLevel
        self.savedCard = savedCard
        self.extraFees = extraFees
    }
    
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public let identifier: String
    
    /// Payment option card brand.
    public var brand: CardBrand
    
    /// Name of the payment option.
    public var title: String
    
    /// Image URL of the payment option.
    public let backendImageURL: URL
    
    /// If the payment option is async or not
    internal let isAsync: Bool
    
    /// Payment type.
    public var paymentType: TapPaymentType
    
    /// Source identifier.
    public private(set) var sourceIdentifier: String?
    
    /// Supported card brands.
    public let supportedCardBrands: [CardBrand]
    
    
    /// List of supported currencies.
    public let supportedCurrencies: [TapCurrencyCode]
    
    /// Ordering parameter.
    public let orderBy: Int
    
    /// Decide if the 3ds should be disabled, enabled or set by user for this payment option
    public let threeDLevel: ThreeDSecurityState
    
    /// Will hold the related saved card if the user selected saved card to pay with
    public var savedCard:SavedCard? = nil
    
    /// Will hold the related extra fees in case of saved card payment
    public var extraFees:[ExtraFee] = []
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case title                  = "name"
        case backendImageURL        = "image"
        case paymentType            = "payment_type"
        case sourceIdentifier       = "source_id"
        case supportedCardBrands    = "supported_card_brands"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
        case isAsync                = "asynchronous"
        case threeDLevel            = "threeDS"
    }
    
    private static func mapThreeDLevel(with threeD:String) -> ThreeDSecurityState
    {
        if threeD.lowercased() == "n"
        {
            return .never
        }else if threeD.lowercased() == "y"
        {
            return .always
        }else
        {
            return .definedByMerchant
        }
    }
    
    
    /// Converts the payment option from Tap format to the acceptable format by Apple pay kit
    public func applePayNetworkMapper() -> [PKPaymentNetwork]
    {
        var applePayMappednNetworks:[PKPaymentNetwork] = []
        
        // Check if the original brand is in the supported, otherwise add it to the list we need to search
        var toBeCheckedCardBrands:[CardBrand] = supportedCardBrands
        
        if !toBeCheckedCardBrands.contains(brand)
        {
            toBeCheckedCardBrands.insert(brand, at: 0)
        }
        for cardBrand:CardBrand in toBeCheckedCardBrands
        {
            if cardBrand == .visa
            {
                applePayMappednNetworks.append(PKPaymentNetwork.visa)
            }else if cardBrand == .masterCard
            {
                applePayMappednNetworks.append(PKPaymentNetwork.masterCard)
            }else if cardBrand == .americanExpress
            {
                applePayMappednNetworks.append(PKPaymentNetwork.amex)
            }else if cardBrand == .maestro
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.maestro)
                }
            }else if cardBrand == .visaElectron
            {
                if #available(iOS 12.0, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.electron)
                }
            }else if cardBrand == .mada
            {
                if #available(iOS 12.1.1, *) {
                    applePayMappednNetworks.append(PKPaymentNetwork.mada)
                }
            }
        }
        
        return applePayMappednNetworks.removingDuplicates()
    }
}

// MARK: - Decodable
extension PaymentOption: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,               forKey: .identifier)
        let brand               = try container.decode          (CardBrand.self,            forKey: .title)
        let title               = try container.decode          (String.self,               forKey: .title)
        let imageURL            = try container.decode          (URL.self,                  forKey: .backendImageURL)
        let paymentType         = try container.decode          (TapPaymentType.self,       forKey: .paymentType)
        let sourceIdentifier    = try container.decodeIfPresent (String.self,               forKey: .sourceIdentifier)
        var supportedCardBrands = try container.decode          ([CardBrand].self,          forKey: .supportedCardBrands)
        let supportedCurrencies = try container.decode          ([TapCurrencyCode].self,    forKey: .supportedCurrencies)
        let orderBy             = try container.decode          (Int.self,                  forKey: .orderBy)
        let isAsync             = try container.decode          (Bool.self,                 forKey: .isAsync)
        let threeDLevel         = try container.decodeIfPresent (String.self,               forKey: .threeDLevel) ?? "U"
        
        supportedCardBrands = supportedCardBrands.filter { $0 != .unknown }
        
        self.init(identifier: identifier,
                  brand: brand,
                  title: title,
                  backendImageURL: imageURL,
                  isAsync: isAsync, paymentType: paymentType,
                  sourceIdentifier: sourceIdentifier,
                  supportedCardBrands: supportedCardBrands,
                  supportedCurrencies: supportedCurrencies,
                  orderBy: orderBy,
                  threeDLevel: PaymentOption.mapThreeDLevel(with: threeDLevel))
    }
}

public enum ThreeDSecurityState {
    
    case always
    case never
    case definedByMerchant
}

// MARK: - FilterableByCurrency
extension PaymentOption: FilterableByCurrency {}

// MARK: - SortableByOrder
extension PaymentOption: SortableByOrder {}

// MARK: - Equatable
extension PaymentOption: Equatable {
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: PaymentOption, rhs: PaymentOption) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}

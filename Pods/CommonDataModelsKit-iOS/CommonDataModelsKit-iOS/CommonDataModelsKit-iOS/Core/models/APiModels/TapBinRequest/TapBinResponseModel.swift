//
//  TapBinResponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/2/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import TapCardVlidatorKit_iOS

/// BIN Response model.
public struct TapBinResponseModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Defines if address is required
    internal let isAddressRequired: Bool
    
    /// Card issuer bank.
    internal let bank: String?
    
    /// Bank logo URL.
    internal let bankLogoURL: URL?
    
    /// Card BIN number.
    public let binNumber: String
    
    /// Card brand.
    public let cardBrand: CardBrand
    
    /// Card scheme.
    public let scheme: CardScheme?
    
    /// Card issuing country.
    internal let country: Country?
    
    /// Card Type.
    public let cardType: CardType
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isAddressRequired  = "address_required"
        case bank               = "bank"
        case bankLogoURL        = "bank_logo"
        case binNumber          = "bin"
        case cardBrand          = "card_brand"
        case scheme             = "card_scheme"
        case country            = "country"
        case cardType           = "card_type"
    }
}

// MARK: - Equatable
extension TapBinResponseModel: Equatable {
    
    public static func == (lhs: TapBinResponseModel, rhs: TapBinResponseModel) -> Bool {
        
        return lhs.binNumber == rhs.binNumber
    }
}

// MARK: - Decodable
extension TapBinResponseModel: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isAddressRequired   = try container.decodeIfPresent(Bool.self, forKey: .isAddressRequired) ?? false
        let bank                = try container.decodeIfPresent(String.self, forKey: .bank)
        let bankLogoURL         = container.decodeURLIfPresent(for: .bankLogoURL)
        let binNumber           = try container.decode(String.self, forKey: .binNumber)
        let cardBrand           = try container.decodeIfPresent(CardBrand.self, forKey: .cardBrand) ?? .unknown
        let cardType            = CardType(cardTypeString:try container.decodeIfPresent(String.self, forKey: .cardType) ?? "")
        let scheme              = try container.decodeIfPresent(CardScheme.self, forKey: .scheme)
        
        var country: Country? = nil
        if let countryString = try container.decodeIfPresent(String.self, forKey: .country), !countryString.isEmpty {
            
            country = try container.decodeIfPresent(Country.self, forKey: .country)
        }
        
        self.init(isAddressRequired: isAddressRequired, bank: bank, bankLogoURL: bankLogoURL, binNumber: binNumber, cardBrand: cardBrand, scheme: scheme, country: country, cardType: cardType)
    }
}

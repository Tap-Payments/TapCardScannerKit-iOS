//
//  CardScheme.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
import TapCardVlidatorKit_iOS

public struct CardScheme {
    
    // MARK: - Internal -
    // MARK: Properties
    
    public let cardBrand: CardBrand
    
    // MARK: - Private -
    // MARK: Methods
    
    private init(_ brand: CardBrand) {
        
        self.cardBrand = brand
    }
}

// MARK: - Decodable
extension CardScheme: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let brand = try container.decode(CardBrand.self)
        
        self.init(brand)
    }
}

// MARK: - Equatable
extension CardScheme: Equatable {
    
    public static func == (lhs: CardScheme, rhs: CardScheme) -> Bool {
        
        return lhs.cardBrand == rhs.cardBrand
    }
}

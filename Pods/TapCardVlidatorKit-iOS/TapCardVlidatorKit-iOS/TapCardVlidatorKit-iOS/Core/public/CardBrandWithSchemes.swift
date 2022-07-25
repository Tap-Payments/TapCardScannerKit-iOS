//
//  CardBrandWithSchemes.swift
//  TapCardVlidatorKit-iOS
//
//  Created by Osama Rabie on 7/4/21.
//
import Foundation
/// Struct of a card brand attached to it the schemes and formats it supports Like Mada --> VISA & MASTERCARD
public struct CardBrandWithSchemes {
    
    /// Represents all the supported card formats for this structure, including the brand itself with all possible allowed card schemes under it
    internal var allSupportedSchemes:[CardBrand] {
        return ((supportedSchemes.contains(cardBrand)) ? [] : [cardBrand]) + supportedSchemes
    }
    
    /// The schemes formats the brand supports
    public internal(set) var supportedSchemes: [CardBrand]
    
    /// The Card brand itself.
    public internal(set) var cardBrand: CardBrand
    
    /// Initializes the struct of a card brand attached to it the schemes and formats it supports Like Mada --> VISA & MASTERCARD
    ///
    /// - Parameters:
    ///   - supportedSchemes: The schemes formats the brand supports
    ///   - cardBrand: The Card brand itself.
    public init(_ supportedSchemes: [CardBrand], _ cardBrand: CardBrand) {
        
        self.supportedSchemes = supportedSchemes
        self.cardBrand = cardBrand
    }
}
// MARK: - Equatable -
extension CardBrandWithSchemes: Equatable {
    
    public static func == (lhs: CardBrandWithSchemes, rhs: CardBrandWithSchemes) -> Bool {
        
        guard lhs.cardBrand == rhs.cardBrand else { return false }
        
        return lhs.supportedSchemes == rhs.supportedSchemes
    }
}

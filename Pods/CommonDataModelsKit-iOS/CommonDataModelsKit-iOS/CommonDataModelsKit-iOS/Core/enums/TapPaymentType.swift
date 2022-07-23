//
//  TapPaymentType.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 8/26/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// An enum to define all the possible payment methods/types provided by the checkout SDK
@objc public enum TapPaymentType:Int, Codable, RawRepresentable, CaseIterable {
    /// Meaning, all availble payment options will be visible for the customers
    case All = 1
    /// Meaning, only web (redirectional) payments wil be visible (like KNET, BENEFIT, FAWRY, etc.)
    case Web = 2
    /// Meaning, only card (debit and credit) form payment will be visible
    case Card = 3
    /// Meaning, only telecom operators payments wil be visible (like VIVA, STC, etc.)
    case Telecom = 4
    /// Meaning, only Apple pay will be visible
    case ApplePay = 5
    /// Only device payments. (e.g. Apple pay)
    case Device = 6
    /// If the user is paying with a saved card
    case SavedCard = 7
    
    public init(stringValue:String) {
        switch stringValue.lowercased() {
        case "web":
            self = .Web
        case "card":
            self = .Card
        case "telecom":
            self = .Telecom
        case "apple_pay":
            self = .ApplePay
        case "device":
            self = .Device
        case "saved_card":
            self = .SavedCard
        default:
            self = .All
        }
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = TapPaymentType.init(stringValue: rawValue)
    }
    
    public var stringValue: String {
        switch self {
        case .Web:
            return "web"
        case .Card:
            return "card"
        case .Telecom:
            return "telecom"
        case .ApplePay:
            return "apple_pay"
        case .Device:
            return "device"
        case .SavedCard:
            return "saved_card"
        default:
            return "all"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case stringValue = "stringValue"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
    
}

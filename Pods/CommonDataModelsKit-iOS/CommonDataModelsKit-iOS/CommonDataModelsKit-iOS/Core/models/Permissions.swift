//
//  Permissions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Permissions option set.
public struct Permissions: OptionSet, Decodable {
    
    // MARK: - public -
    
    public var rawValue: Set<String>
    
    // MARK: Properties
    
    public static let pci                     = Permissions(rawValue: Set<String>([Constants.pciKey]))
    public static var merchantCheckoutAllowed:Bool {
        return true
    }
    public static let merchantCheckout     = Permissions(rawValue: Set<String>([Constants.merchantCheckoutKey]))
    public static let non3DSecureTransactions = Permissions(rawValue: Set<String>([Constants.threeDSecureDisabledKey]))
    
    // MARK: Methods
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let value = try container.decode(RawValue.self)
        
        self.init(rawValue: value)
    }
    
    public init(rawValue: Set<String>) {

        self.rawValue = rawValue.filter { Constants.availableOptions.contains($0) }
    }
    
    public init() {

        self.rawValue = Set<String>()
    }

    public mutating func formUnion(_ other: Permissions) {

        self.rawValue.formUnion(other.rawValue)
    }

    public mutating func formIntersection(_ other: Permissions) {

        self.rawValue.formIntersection(other.rawValue)
    }

    public mutating func formSymmetricDifference(_ other: Permissions) {

        self.rawValue.formSymmetricDifference(other.rawValue)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let pciKey                   = "pci"
        fileprivate static let merchantCheckoutKey      = "merchant_checkout"
        fileprivate static let threeDSecureDisabledKey  = "threeDSecure_disabled"
        
        fileprivate static let availableOptions: [String] = {
            
            return [
                Constants.pciKey,
                Constants.merchantCheckoutKey,
                Constants.threeDSecureDisabledKey
            ]
        }()
        
        //@available(*, unavailable) private init() { }
    }
}

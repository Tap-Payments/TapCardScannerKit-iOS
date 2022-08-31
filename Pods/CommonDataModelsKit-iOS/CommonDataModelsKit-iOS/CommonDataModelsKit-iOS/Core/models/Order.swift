//
//  Order.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

public struct Order: IdentifiableWithString, Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    public let identifier: String
    
    // MARK: Methods
    
    public init(identifier: String) {
        
        self.identifier = identifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
    }
}

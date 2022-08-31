//
//  TapAuthenticationRequest.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/7/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Structure to authenticate the charge.
public struct TapAuthenticationRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Authentication type.
    internal let type: AuthenticationType
    
    /// Authentication value.
    internal let value: String
    
    // MARK: Methods
    
    public init(type: AuthenticationType, value: String) {
        
        self.type   = type
        self.value  = value
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case value  = "value"
    }
}

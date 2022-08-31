//
//  Gateway.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 24/03/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation
/// Gateway part of the Config api request model
public struct Gateway: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The config details part of the request model
    internal let config: Config
    /// The id of the current merchant
    internal let merchantId: String?
    /// The public key identifier for the current merchant
    internal let publicKey: String
    
    // MARK: Methods
    
    public init(config: Config, merchantId: String?, publicKey: String) {
        
        self.config     = config
        self.merchantId = merchantId
        self.publicKey  = publicKey
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case config     = "config"
        case merchantId = "merchantId"
        case publicKey  = "publicKey"
    }
}

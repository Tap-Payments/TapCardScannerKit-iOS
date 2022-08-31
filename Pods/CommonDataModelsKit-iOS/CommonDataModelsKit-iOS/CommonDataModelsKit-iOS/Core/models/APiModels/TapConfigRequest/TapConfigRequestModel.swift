//
//  TapConfigRequestModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 24/03/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation

/// Config request model.
public struct TapConfigRequestModel: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The actual gateway body model for the request
    public let gateway: Gateway
    
    /// Config request model.
    /// - Parameter gateway: The actual gateway body model for the request
    public init(gateway:Gateway) {
        self.gateway = gateway
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        case gateway    =   "gateway"
    }
}

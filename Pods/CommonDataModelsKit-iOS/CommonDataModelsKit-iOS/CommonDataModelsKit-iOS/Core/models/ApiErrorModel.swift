//
//  ApiErrorModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/14/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Model to parse errors coming from the backend
public struct ApiErrorModel {
    
    // MARK: - Internal -
    // MARK: Properties
    /// Determines if there are errors from the backend if any
    public let errors:[ErrorDetail]
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        case errors = "errors"
    }
}

// MARK: - Decodable
extension ApiErrorModel: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errors    = try container.decodeIfPresent([ErrorDetail].self, forKey: .errors) ?? []
        
        self.init(errors: errors)
    }
}

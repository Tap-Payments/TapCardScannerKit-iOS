//
//  AuthorizeActionResponse.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/1/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
/// Authorize action response class.
@objcMembers public final class AuthorizeActionResponse: AuthorizeAction {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Authorize action status.
    public private(set) var status: AuthorizeActionStatus = .failed
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case time   = "time"
        case status = "status"
    }
}

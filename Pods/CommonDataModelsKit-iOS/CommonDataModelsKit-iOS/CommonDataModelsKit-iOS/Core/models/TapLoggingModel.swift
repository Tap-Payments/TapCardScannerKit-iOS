//
//  TapLoggingModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// TapLoggedRequestModel model.
public struct TapLoggingModel: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// The logged in requests and responses
    public var loggedRequests:[String] = [""]
    
    /// The error occureed at the end
    public var error: String = ""
    
    /// Current Merchant
    public var merchant:Merchant?
    
    /// Current Customet
    public var customer:TapCustomer?
    
    // MARK: Methods
    
    /**
     Creates a new TapLoggedRequestModel model.
     - Parameter loggedRequests:    The logged in requests and responses
     - Parameter error:             The error occureed at the end
     - Parameter merchant:          The Current Merchant
     - Parameter customer:          The Current Customer
     */
    public init(loggedRequests:[String], error:String?, merchant:Merchant?, customer:TapCustomer?) {
        self.loggedRequests = loggedRequests
        self.error          = error ?? ""
        self.merchant       = merchant
        self.customer       = customer
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case loggedRequests = "loggedRequests"
        case error          = "error"
        case merchant       = "merchant"
        case customer       = "customer"
    }
}


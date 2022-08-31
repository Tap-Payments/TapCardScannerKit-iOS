//
//  TapNetworkPath.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 8/22/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// Represents a routing enum, which will has the end point of each needed request
public enum TapNetworkPath : String {
    /// Loading the Intent API
    case IntentAPI = "5720fa1c-9b7e-4b68-810f-dbb79228405c"
    //case IntentAPI = "7b0b86c3-1e22-40f7-bf28-ad0ae58c391d" // case IntentAPI = "5720fa1c-9b7e-4b68-810f-dbb79228405c"
    /// Login to GoPay
    case GoPayLoginAPI = "7ffceaa7-0b86-4a18-88bb-c157c9a27aae"
    /// Calling CONFIG  api which is the kickstart for a starting a new session and construct a connection with the middleware
    case ConfigAPI                  = "checkout/config"
    /// Calling INIT api which is the kickstart for a starting a new session, get the merchant data and the payment options
    case InitAPI                    = "checkout/init"
    /// Calling PAYMENT OPTIONS api which is needed to have all the info to configure the view models of the checkout SDK
    case PaymentOptionsAPI          = "checkout/payment/types/"
    /// Calling Authorize card api which is needed to authorize a certain card
    case authorize                  = "checkout/authorize/"
    /// Calling Billing address card api
    case billingAddress             = "billing_address/"
    /// Calling card bin lookup api which is needed to get info about a card
    case bin                        = "card/bin/"
    /// Calling card api which is needed to get info about a card
    case card                       = "card/"
    /// Calling card   which is needed to verify the details of a card
    case cardVerification           = "card/verify/"
    /// Calling charges ap   which is needed to execute and perform a certain charge
    case charges                    = "checkout/charge/"
    /// Calling customers api   which is needed to get the customers list
    case customers                  = "customers/"
    /// Calling token api to tokenize
    //case token                      = "checkout/token/"
    /// Calling token api to tokenize
    case tokens                     = "token/"
    /// Calling logging api
    case logging                    = "log/"
    
    
    /// A special decoder to map the string values we get from the backend into a valid SWIFT date object to deal with.
    /// Based on the routing we decide how we will convert the string value into a valid Date
    internal var decoder: JSONDecoder {
        
        let decoder = JSONDecoder()
        
        switch self {
            
        case .charges, .authorize, .cardVerification:
            
            decoder.dateDecodingStrategy = .custom { (aDecoder) -> Date in
                
                let container = try aDecoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                let double = NumberFormatter().number(from: dateString)?.doubleValue ?? 0.0
                return Date(timeIntervalSince1970: double / 1000.0)
            }
            
        case .tokens:
            
            decoder.dateDecodingStrategy = .secondsSince1970
            
        default:
            
            break
        }
        
        return decoder
    }
}

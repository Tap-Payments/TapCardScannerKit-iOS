//
//  TapCreateTokenRequest.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 7/2/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation


/// A protocol to be implemented by all create token requests, we have till now three different token modes for card, saved card and apple pay token.
public protocol TapCreateTokenRequest: Encodable {
    
    var route: TapNetworkPath { get }
}


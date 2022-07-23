//
//  OptionallyIdentifiableWithString.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 11/15/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// All models that have identifier are conforming to this protocol.
internal protocol OptionallyIdentifiableWithString {
    
    // MARK: Properties
    
    /// Unique identifier of an object.
    var identifier: String? { get }
}

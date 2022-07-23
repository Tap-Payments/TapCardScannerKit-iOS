//
//  AmountMoficiationType.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 6/13/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
/// Represent an enum to decide all the possible amount modifications types
@objc public enum AmountModificationType: Int, CaseIterable {
    
    /// Percent-based modification.
    @objc(Percents) case Percentage
    
    /// Fixed amount modification.
    @objc(FixedAmount) case Fixed
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let percentBasedKey  = "P"
        fileprivate static let fixedAmountKey   = "F"
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
        
        case .Percentage:           return Constants.percentBasedKey
        case .Fixed:          return Constants.fixedAmountKey
            
        }
    }
    
    // MARK: Methods
    
    private init(string: String) throws {
        
        switch string {
        
        case Constants.percentBasedKey: self = .Percentage
        case Constants.fixedAmountKey:  self = .Fixed
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.amountModificatorType: string]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidAmountModificatorType.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
    }
}

// MARK: - CustomStringConvertible
extension AmountModificationType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        case .Fixed:        return "Fixed amount"
        case .Percentage:   return "Percents"
            
        }
    }
}

// MARK: - Decodable
extension AmountModificationType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}

// MARK: - Encodable
extension AmountModificationType: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}

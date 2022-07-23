//
//  TapPhone.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 11/15/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/** Represents the model for parsing the phone object coming from Tap backend
 {
 "phone": {
 "country_code": "965",
 "number": "00000000"
 }
 }
 - tag: TapPhone
 */
@objc public class TapPhone : NSObject,Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// ISD number.
    public let isdNumber: String
    
    /// Phone number (digits after country code).
    public let phoneNumber: String
    
    // MARK: Methods
    
    /// Intiailizes `PhoneNumber` with ISD number and a phone number.
    ///
    /// - Parameters:
    ///   - isdNumber: ISD number.
    ///   - phoneNumber: Phone number.
    /// - Throws: An error in case ISD number or phone number is not valid (currently checking only digits).
    @objc public required init(isdNumber: String, phoneNumber: String) throws {
        
        let isd = TapPhone.extractISDNumber(from: isdNumber)
        let number = phoneNumber
        
        guard isd.tap_length > 0 && isd.tap_containsOnlyInternationalDigits else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.isdNumber: isd]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidISDNumber.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
        
        guard number.tap_length > 0 && number.tap_containsOnlyInternationalDigits else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.phoneNumber: number]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidPhoneNumber.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
        
        self.isdNumber = isd
        self.phoneNumber = number
        
        super.init()
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherPhoneNumber = object as? TapPhone else { return false }
        
        return self.isdNumber == otherPhoneNumber.isdNumber && self.phoneNumber == otherPhoneNumber.phoneNumber
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `fale` otherwise.
    public static func == (lhs: TapPhone, rhs: TapPhone) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let plusSign     = "+"
        fileprivate static let doubleZero   = "00"
        
        //@available(*, unavailable) private init() { }
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case isdNumber      = "country_code"
        case phoneNumber    = "number"
    }
    
    // MARK: Methods
    
    private static func extractISDNumber(from unextractedNumber: String) -> String {
        
        var result = unextractedNumber
        
        let prefixesToRemove = [Constants.plusSign, Constants.doubleZero]
        
        prefixesToRemove.forEach { result.tap_removePrefix($0) }
        
        return result
    }
    
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isdNumber, forKey: .isdNumber)
        try container.encode(self.phoneNumber, forKey: .phoneNumber)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isdNumber   = try container.decode(String.self, forKey: .isdNumber)
        let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
        try self.init(isdNumber: isdNumber, phoneNumber: phoneNumber)
    }
}

// MARK: - NSCopying
extension TapPhone: NSCopying {
    
    /// Creates copy of the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return try! TapPhone(isdNumber: self.isdNumber, phoneNumber: self.phoneNumber)
    }
}

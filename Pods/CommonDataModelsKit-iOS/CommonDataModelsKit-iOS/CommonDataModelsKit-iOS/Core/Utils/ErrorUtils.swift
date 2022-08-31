//
//  ErrorUtils.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
 public class ErrorUtils {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func createEnumStringInitializationError<T>(for enumerationType: T.Type, value: String) -> TapSDKError {
        
        let userInfo: [String: String] = [
            
            ErrorConstants.UserInfoKeys.enumName: String(describing: enumerationType),
            ErrorConstants.UserInfoKeys.enumValue: value
        ]
        
        let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidEnumValue.rawValue, userInfo: userInfo)
		return TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    //@available(*, unavailable) private init() { }
}


public struct ErrorConstants {
    
    internal static let internalErrorDomain = "company.tap.gosellsdk"
    
    public struct UserInfoKeys {
        
        internal static let addressType             = "address_type"
        internal static let tokenType               = "token_type"
        internal static let amountModificatorType   = "amount_modificator_type"
        internal static let authorizeActionType     = "authorize_action_type"
        internal static let countryCode             = "country_code"
        internal static let currencyCode            = "currency_code"
        internal static let customerInfo            = "customer_info"
        internal static let emailAddress            = "email_address"
        internal static let isdNumber               = "isd_number"
        internal static let measurementCategory     = "measurement_category"
        internal static let measurementUnit         = "measurement_unit"
        internal static let phoneNumber             = "phone_number"
        internal static let unitOfMeasurement       = "unit_of_measurement"
        internal static let enumName                = "enum_name"
        internal static let enumValue               = "enum_value"
        
        //@available(*, unavailable) private init() { }
    }
    
    //@available(*, unavailable) private init() { }
}



internal enum InternalError: Int {
    
    case invalidCountryCode = 1
    case invalidAddressType
    case invalidAmountModificatorType
    case invalidAuthorizeActionType
    case invalidCurrency
    case invalidCustomerInfo
    case invalidTokenType
    case customerAlreadyExists
    case cardAlreadyExists
    case invalidEmail
    case invalidISDNumber
    case invalidPhoneNumber
    case invalidUnitOfMeasurement
    case invalidMeasurement
    case invalidEnumValue
    case noMerchantData
}

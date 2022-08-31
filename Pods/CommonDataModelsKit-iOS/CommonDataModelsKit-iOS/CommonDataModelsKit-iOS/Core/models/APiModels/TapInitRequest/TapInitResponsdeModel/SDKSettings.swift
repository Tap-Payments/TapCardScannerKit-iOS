//
//  TapInitResponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/14/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
/// goSell SDK Settings model.
public struct SDKSettings {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payments mode.
    internal let isLiveMode: Bool?
    
    /// Permissions.
    public let permissions: Permissions?
    
    /// Encryption key.
    public let encryptionKey: String?
    
    /// Unique device ID.
    // FIXME: Remove optionality here once backend is ready.
    internal let deviceID: String?
    
    /// Merchant information.
    public let merchant: Merchant?
    
    /// Internal SDK settings.
    internal let internalSettings: InternalSDKSettings?
    
    /// Session token.
    public private(set) var sessionToken: String?
    
    /// Determine if the passed data is correct ones by the backend
    internal let verifiedApplication:Bool?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode             = "live_mode"
        case permissions            = "permissions"
        case merchantLogo           = "logo"
        case merchantName           = "name"
        case encryptionKey          = "encryption_key"
        case deviceID               = "device_id"
        case merchant               = "merchant"
        case internalSettings       = "sdk_settings"
        case sessionToken           = "session_token"
        case verifiedApplication    = "verified_application"
    }
}

// MARK: - Decodable
extension SDKSettings: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isLiveMode              = try container.decode(Bool.self,                   forKey: .isLiveMode)
        let encryptionKey           = try container.decode(String.self,                 forKey: .encryptionKey)
        let merchantName            = try container.decode(String.self,                 forKey: .merchantName)
        let merchantLogo            = try container.decode(String.self,                 forKey: .merchantLogo)
        let merchant                = Merchant(logoURL: merchantLogo, name: merchantName)
        let verifiedApplication     = try container.decode(Bool.self,                   forKey: .verifiedApplication)
        let internalSettings        = try container.decode(InternalSDKSettings.self,    forKey: .internalSettings)
        
        let permissions             = try container.decodeIfPresent(Permissions.self,   forKey: .permissions) ?? .tap_none
        let deviceID                = try container.decodeIfPresent(String.self,        forKey: .deviceID)
        let sessionToken            = try container.decodeIfPresent(String.self,        forKey: .sessionToken)
        
        
        if encryptionKey == "" {
            throw "TAP SDK ERROR : Empty Encryption Key"
        }
        
        SharedCommongDataModels.sharedCommongDataModels.encryptionKey = encryptionKey
        
        self.init(isLiveMode:           isLiveMode,
                  permissions:          permissions,
                  encryptionKey:        encryptionKey,
                  deviceID:             deviceID,
                  merchant:             merchant,
                  internalSettings:     internalSettings,
                  sessionToken:         sessionToken,
                  verifiedApplication:  verifiedApplication)
    }
}


/// goSell SDK settings data model.
public struct TapInitResponseModel:Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Data.
    public var data: SDKSettings
    /// Payment options.
    public var cardPaymentOptions: TapPaymentOptionsReponseModel
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case data               = "merchant"
        case cardPaymentOptions = "payment_options"
    }
}

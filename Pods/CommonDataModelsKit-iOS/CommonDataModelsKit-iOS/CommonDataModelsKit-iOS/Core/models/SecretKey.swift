//
//  SecretKey.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation

/// The model that represents the Secret key providede to your app bunlde from TAP
/// - tag: SecretKey
@objcMembers public final class SecretKey: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Sandbox secret key.
    public let sandbox: String
    
    /// Production secret key.
    public let production: String
    
    /// The used key based on the  selected mode production or sandbox
    public var usedKey:String {
        switch SharedCommongDataModels.sharedCommongDataModels.sdkMode {
        case .production:
            return production
        case .sandbox:
            return sandbox
        }
    }
    
    // MARK: Methods
    
    /// Initializes secret key with sandbox and production keys.
    ///
    /// - Parameters:
    ///   - sandbox: Sandbox key.
    ///   - production: Production key.
    public required init(sandbox: String, production: String) {
        
        self.sandbox    = sandbox
        self.production = production
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let empty: SecretKey = SecretKey(sandbox: .tap_empty, production: .tap_empty)
}

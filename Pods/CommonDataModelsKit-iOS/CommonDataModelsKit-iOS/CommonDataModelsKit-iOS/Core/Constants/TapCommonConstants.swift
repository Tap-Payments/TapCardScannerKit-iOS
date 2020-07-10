//
//  TapCommonConstants.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 03/05/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// Presents the interface for common constants
@objc public class TapCommonConstants:NSObject {
    
    /**
     Compute the common localisation file path shared as the default file to be used inside all KITS
     - Returns: The default URL path of the json localisation file
     */
    @objc public static func pathForDefaultLocalisation() -> URL {
        let bundle:Bundle = Bundle(for: TapCommonConstants.self)
        let defaultLocalisationFilePath:URL = URL(fileURLWithPath: bundle.path(forResource: "DefaultTapLocalisation", ofType: "json")!)
        return defaultLocalisationFilePath
    }
    
}

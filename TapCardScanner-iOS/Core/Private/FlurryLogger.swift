//
//  //FlurryLogger.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 31/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/*import Flurry_iOS_SDK

/// This class is a singleton class responsible for dealing with Flurry SDK
internal class FlurryLogger {
    
    /// Init the Flurry session or return the already activated one
    static func activateSession() {
        Flurry.startSession("4H7NXGZ9536V45T9CQF4", with: FlurrySessionBuilder
               .init()
               .withCrashReporting(true)
               .withLogLevel(FlurryLogLevelAll))
    }
    
    /**
     Log a certain event with the given details and adds to it the common params
     - Parameter name: The event name
     - Parameter timed: If this is a timed event. Default is false
     - Parameter params: The params needed with the given event. Default is nothing
     */
    static func logEvent(with name:String,timed:Bool = false,params:[String:String] = [:]) {
        activateSession()
        
        var finalParams = //FlurryLogger.defaultParams()
        finalParams.merge(dict: params)
        Flurry.logEvent(name, withParameters: finalParams, timed: timed);
        
    }
    
    /// Generates  the default/common params we will record with every event
    static func defaultParams() -> [String:String] {
        
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let at = String(NSTimeIntervalSince1970)
        
        let commonParams:[String:String] = ["appID":bundleIdentifier,"at":at]
        
        return commonParams
    }
    
    /// Used when you want to end a previously reported timed event
    static func endTimerForEvent(with name:String, params:[String:String] = [:]) {
        Flurry.endTimedEvent(name, withParameters: params);
    }
}


internal extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

*/

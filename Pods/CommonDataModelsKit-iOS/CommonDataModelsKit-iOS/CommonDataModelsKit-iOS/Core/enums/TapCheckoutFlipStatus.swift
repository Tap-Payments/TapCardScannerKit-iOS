//
//  TapCheckoutFlipStatus.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 8/12/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// Indicates the required status for flipping the checkout SDK sheet when used with RTl languages like Arabic
@objc public enum TapCheckoutFlipStatus: Int {
    /// This means that the your project is using MOLH library and already the MOLH language is set to the same LOCALE required to start the SDK
    case NoFlipping = 1
    /// This means that your project is using different storyboards for RTL, hence, it is not globally reversing all the views. So the SDK needs to handle itself and reverse itself. The SDK will then revert all to original when it is being dismissed so your app will not be affected
    case FlipOnLoadWithFlippingBack = 2
    /// This means that your project is using different storyboards for RTL, hence, it is not globally reversing all the views. So the SDK needs to handle itself and reverse itself. The SDK will not cancel the global reverse it did to show the RTL language
    case FlipOnLoadWithOutFlippingBack = 3
}

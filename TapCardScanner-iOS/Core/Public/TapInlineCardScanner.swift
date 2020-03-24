//
//  TapInlineCardScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class AVFoundation.AVCaptureDevice
import struct AVFoundation.AVMediaType
import class UIKit.UIImagePickerController

/// This class represents the tap inline scanner UI controller.
@objc public class TapInlineCardScanner:NSObject {
    
    /**
     This interface decides whether the scanner can start or not based on camera usage permission granted and camera does exist.
     - Returns: TapCanScanStatusResult enum which has three values: .CanStart if all good, .CameraMissing if camera doesn't exist and .CameraPermissionMissing Scanning cannot start as camera usage permission is not granted
     */
    @objc public static func CanScan() -> TapCanScanStatusResult {
        
        // Check if permission is granted to use the camera
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            // Check the camera existance
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // All good!
                return .CanStart
            }else {
                return .CameraMissing
            }
        }else {
            return .CameraPermissionMissing
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

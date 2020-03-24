//
//  TapCanScanStatusResult.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

/// Enum to define  the results of the can scan check
@objc public enum TapCanScanStatusResult: Int, RawRepresentable, CaseIterable {
    /// All good and scanning can start
    case CanStart
    /// Scanning cannot start as no camera in the device
    case CameraMissing
    /// Scanning cannot start as camera usage permission is not granted
    case CameraPermissionMissing
    
    
    
    /// Coming constcutors to spport creating enums from String in case of parsing it from JSON
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
            case "CanStart":
                self = .CanStart
            case "CameraMissing":
                self = .CameraMissing
            case "CameraPermissionMissing":
                self = .CameraPermissionMissing
            default:
                return nil
        }
    }
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
            case .CanStart:
                return "All good and scanning can start"
            case .CameraMissing:
                return "Scanning cannot start as no camera in the device"
            case .CameraPermissionMissing:
                return "Scanning cannot start as camera usage permission is not granted"
        }
    }
}

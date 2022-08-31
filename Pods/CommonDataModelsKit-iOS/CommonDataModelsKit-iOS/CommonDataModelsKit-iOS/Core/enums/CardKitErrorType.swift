//
//  CardKitErrorType.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 24/07/2022.
//

import Foundation


/// Enum defining SDK errors.
@objc public enum CardKitErrorType: Int, CaseIterable {
    
    @objc(Network)          case Network
    @objc(InvalidCardType)  case InvalidCardType
}

// MARK: - CustomStringConvertible
extension CardKitErrorType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .Network:          return "Network error occured"
        case .InvalidCardType:  return "The user entered a card not matching the given allowed type"
        }
    }
}


/// Enum defining different events passed from card kit
@objc public enum CardKitEventType: Int, CaseIterable {
    
    @objc(CardNotReady)             case CardNotReady
    @objc(CardReady)                case CardReady
    @objc(TokenizeStarted)          case TokenizeStarted
    @objc(TokenizeEnded)            case TokenizeEnded
    @objc(SaveCardStarted)          case SaveCardStarted
    @objc(SaveCardEnded)            case SaveCardEnded
    @objc(ThreeDSStarter)           case ThreeDSStarter
    @objc(ThreeDSEnded)             case ThreeDSEnded
}

// MARK: - CustomStringConvertible
extension CardKitEventType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        case .CardNotReady:
            return "Card data is not ready for any action"
        case .CardReady:
            return "Card data is ready for tokenize or save when needed"
        case .TokenizeStarted:
            return "Tokenize process started"
        case .TokenizeEnded:
            return "Tokenize process ended"
        case .SaveCardStarted:
            return "Save card process started"
        case .SaveCardEnded:
            return "Save card process ended"
        case .ThreeDSStarter:
            return "ThreeDS process started"
        case .ThreeDSEnded:
            return "ThreeDS process ended"
        }
    }
}

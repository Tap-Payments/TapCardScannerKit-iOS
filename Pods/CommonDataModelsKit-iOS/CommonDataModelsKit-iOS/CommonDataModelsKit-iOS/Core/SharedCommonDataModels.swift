//
//  SharedCommonDataModels.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 07/08/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation

/// Shared access to the  common data models shared data
public class SharedCommongDataModels {
    /// Singleton shared access to the  common data models shared data
    public static let sharedCommongDataModels = SharedCommongDataModels()
    
    /// The sdk mode for the current running transction
    public var sdkMode:SDKMode = .sandbox
    /// The encryption key for the merchant
    public var encryptionKey:String?
    
    /// allowed Card Types, if not set all will be accepeted.
    public var allowedCardTypes:[CardType] = [CardType(cardType: .Debit), CardType(cardType: .Credit)] {
        didSet {
            if allowedCardTypes.count == 1 && allowedCardTypes[0].cardType == .All {
                allowedCardTypes = [CardType(cardType: .Debit), CardType(cardType: .Credit)]
            }
        }
    }
}


// MARK: Element: Hashable
extension Array where Element: Hashable {
    /// Removes dublicates of the array
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    /// Removes dublicates of the array
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

/// Creates an error with a string
extension String {
    var errorDescription: String? { return self }
}

extension String: Error {}

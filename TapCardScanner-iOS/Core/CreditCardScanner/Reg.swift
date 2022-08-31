import Foundation

//  Regex.swift
//  Created by Osama Rabie on 24/07/2021.
//  Copyright © 2021 Tap Payments. All rights reserved.

/// A class to wrap and provide easy access to some of the common methods regarding dealing with regular expressions
internal struct Regex: ExpressibleByStringLiteral {
    /// The pattern we are searching for
    private let pattern: String
    
    /// The regular expression object that holds the pattern
    private var nsRegularExpression: NSRegularExpression? {
        return try? NSRegularExpression(pattern: pattern)
    }
    
    /// Define a nice name for the Regex format to be passed by the consumer
    typealias StringLiteralType = String
    
    /// - Parameter stringLiteral: Define a nice name for the Regex format to be passed by the consumer
    init(stringLiteral value: StringLiteralType) {
        pattern = value
    }
    
    init(_ string: String) {
        pattern = string
    }
    
    /**
     Fetches all the matches in a given string
     - Parameter in: The string we will search in
     */
    func matches(in string: String) -> [String] {
        
        var allMatches:[String] = []
        
        
        for i in 0 ... string.count {
            let newString:String = string.tap_substring(from: i)
            // Defensive coding to make sure all what we need is available
            let ranges = nsRegularExpression?
                .matches(in: newString, options: [], range: searchRange(for: newString))
                .compactMap { Range($0.range, in: newString) } ?? []
            
            allMatches.append(contentsOf: ranges
                .map { newString[$0] }
                .map(String.init))
            
            
        }
        return allMatches.tap_removingDuplicates
        /*
         
         // Defensive coding to make sure all what we need is available
         let ranges = nsRegularExpression?
         .matches(in: string, options: [], range: searchRange(for: string))
         .compactMap { Range($0.range, in: string) }
         ?? []
         
         return ranges
         .map { string[$0] }
         .map(String.init)*/
    }
    
    /// Detects if the pattern exists in a given string
    /// - Parameter in: The string we will seach in
    func hasMatch(in string: String) -> Bool {
        return firstMatch(in: string) != nil
    }
    
    /**
     Fetches  the 1st matches in a given string
     - Parameter in: The string we will search in
     */
    func firstMatch(in string: String) -> String? {
        // Defensive coding to make sure all what we need is available
        guard
            let match = nsRegularExpression?.firstMatch(
                in: string,
                options: [],
                range: searchRange(for: string)
            ),
            let matchRange = Range(match.range, in: string)
        else {
            return nil
        }
        
        return String(string[matchRange])
    }
    
    private func searchRange(for string: String) -> NSRange {
        return NSRange(location: 0, length: string.utf16.count)
    }
}

// MARK: Operator related

infix operator =~
infix operator !~

internal extension Regex {
    static func =~ (string: String, regex: Regex) -> Bool {
        return regex.hasMatch(in: string)
    }
    
    static func =~ (regex: Regex, string: String) -> Bool {
        return regex.hasMatch(in: string)
    }
    
    static func !~ (string: String, regex: Regex) -> Bool {
        return !regex.hasMatch(in: string)
    }
    
    static func !~ (regex: Regex, string: String) -> Bool {
        return !regex.hasMatch(in: string)
    }
}

/// An extension to include all needed regex throughout card analyzing process
internal extension Regex {
    
    /// The card number regex
    static let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
    /// The month regex
    static let month: Regex = #"/^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})$/"#
    /// The year regex
    static let year: Regex = #"\d{2}\/(\d{2})"#
    // These may be contained in the date strings, so ignore them only for names
    /// The words to skip always and may be there on a card
    static let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward"]
    /// The words to skip always and may be there on a card
    static let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year"]
    /// The name regex
    static let name: Regex = #"^(?=.{3,26}$)[A-Za-zÀ-ú][A-Za-zÀ-ú.'-]+(?: [A-Za-zÀ-ú.'-]+)* *$"#
    
    
}

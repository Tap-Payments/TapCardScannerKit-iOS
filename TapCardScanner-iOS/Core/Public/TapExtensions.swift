//
//  TapExtensions.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 25/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import struct UIKit.CGFloat

@objc extension UIImage
{
    /**
     This an extention to covert a given image to ASCII base64 string and making sure the size is under a given limit
     - Parameter maxDataSize: This will tell the method how much to compress the given uiimage and not to pass this given size in KB
     - Parameter minCompression: This is the minimum quality value allowed to go to while trying to compress the given image. ALlowed values from 0 .. 1
     - Returns: ASCII base64 string
     */
    @objc func base64Encode(maxDataSize:Double = 0, minCompression:CGFloat = 0.2) -> String?
    {
        // Try always with the best quality
        var compressionRate:CGFloat = 1
        
        // Make sure the given image is a valid one
        guard var imageData = self.jpegData(compressionQuality: compressionRate) else
        {
            return nil
        }

        // Always yry toc ompress the image as long as we are not going lower than the minimum given quality
        if maxDataSize > 0 {
            
            while(compressionRate >= minCompression && maxDataSize < (Double(imageData.count) / 1000.0)) {
                compressionRate = compressionRate - 0.1
                imageData = self.jpegData(compressionQuality: compressionRate)!
            }
        }
        
        print("Compression : \(compressionRate) && Size : \((Double(imageData.count) / 1000.0)) KB")
        
        let base64String = imageData.base64EncodedString()
        return base64String
    }
}

extension String
{
    /**
    This an extention to guess that a given string could be a card number
    - Returns: true if the given  string has only numbers and spaces, has at least two spaces and length of minimum 10. False other wise
    */
    func isPotentialCardNumber() -> Bool {
        
        // Card numbers have only digits and spaces
        if self.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789 ").inverted) == nil {
            if self.components(separatedBy: " ").count > 2 && self.count > 10 {
                return true
            }
        }
        
        return false
    }
    
    /**
    This an extention to guess that a given string could be a card name
    - Returns: true if the given  string has only upper cased letters and spaces, has at least two spaces and length of minimum 10. False other wise
    */
    func isaPotentialCardName() -> Bool {
        
        // Card name always has only upper cased letters and spaces
        let allowedCharachters = "abcdefghijklmnopqrstuvwxyz .'".uppercased()
        if self.rangeOfCharacter(from: CharacterSet(charactersIn: allowedCharachters).inverted) == nil {
            if self.components(separatedBy: " ").count > 2 && self.count > 10 {
                return true
            }
        }
        
        return false
    }
    
    /**
    This an extention to guess that a given string has a valid expiry date for a credit card which is in format MM/YYYY or MM/YY
    - Returns: true if the given  string has a string with the format MM/YY or MM/YYYY and makes sure this matching string is an actual date
    */
    func extractCardExpiry() -> String? {
        
        do {
            // Regex for detecting the credit card exxpiry format which is MM/YY or MM/YYYY
            let regex = try NSRegularExpression(pattern: #"[0-9]?[0-9]\/[0-9][0-9]([0-9][0-9])?"#)
            let matches = regex.matches(in: self, range: NSRange(0..<self.utf16.count))
            let matchingWords = matches.map {
                String(self[Range($0.range, in: self)!])
            }
            print(matchingWords)
            // Defensive coding, check if any can be created as A DATE
            for matchingWord in matchingWords {
                let dateFormatter1:DateFormatter = DateFormatter()
                dateFormatter1.dateFormat = "MM/yy"
                
                if let _:Date = dateFormatter1.date(from: matchingWord) {
                    return matchingWord
                }
                let dateFormatter2:DateFormatter = DateFormatter()
                dateFormatter2.dateFormat = "MM/yyyy"
                
                if let _:Date = dateFormatter2.date(from: matchingWord) {
                    return matchingWord
                }
            }
        } catch {}
        
        return nil
    }
    
    /**
       This an extention to enumerate the lines in a given string in a shorthand way
       - Returns: Array of strings each of which is a line in the given string
       */
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

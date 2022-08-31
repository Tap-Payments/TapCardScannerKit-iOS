//
//  ImageAnalyzer.swift
//  Created by Osama Rabie on 24/07/2021.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
#if canImport(Vision)
import Vision
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS

/// The data source needed to configure
public protocol TapScannerDataSource: AnyObject {
    func allowedCardBrands() -> [CardBrand]
}



///  A delegate to pass callbacks from the image analyzer
internal protocol ImageAnalyzerProtocol: AnyObject {
    func didFinishAnalyzation(with result: Result<TapCard, Error>)
}

@available(iOS 13, *)
internal final class ImageAnalyzer {
    
    /// Enum to know which field we will confirm its existance when needed
    enum Candidate: Hashable {
        case number(String), name(String)
        case expireDate(DateComponents)
    }
    
    typealias PredictedCount = Int
    
    /// The fetched card after confirming the extracted data
    private var selectedCard = TapCard()
    /// A predicate based logic to give a trust value for a detected text with regards its type
    private var predictedCardInfo: [Candidate: PredictedCount] = [:]
    ///  A delegate to pass callbacks from the image analyzer
    private weak var delegate: ImageAnalyzerProtocol?
    /// The data source needed to configure
    private weak var dataSource:TapScannerDataSource?
    
    /// - Parameter delegate: A delegate to pass callbacks from the image analyzer
    /// /// - Parameter dataSource: The data source needed to configure
    init(delegate: ImageAnalyzerProtocol, dataSource: TapScannerDataSource?) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    /// Computed variable to tell the analyzer which card brand schemes should be accepted while scanning
    private var allowedCardBrands:[CardBrand] {
        // If the caller needs specific brands we apply them
        if let dataSourceFromBrands = dataSource?.allowedCardBrands(),
           dataSourceFromBrands.count > 0 {
            return dataSourceFromBrands
        }else{
            // Otherwise, we will allow any valid card
            return CardBrand.allCases
        }
    }
    
    // MARK: - Vision-related
    
    /// The request to pass to the vision api
    lazy var request = VNRecognizeTextRequest(completionHandler: requestHandler)
    
    /// Start analyzing and passing the image to the vision api
    /// - Parameter image: The image we need to start analyzing and detecting objects from it
    func analyze(image: CGImage) {
        // Create the vision request
        let requestHandler = VNImageRequestHandler(
            cgImage: image,
            orientation: .up,
            options: [:]
        )
        
        do {
            try requestHandler.perform([request])
        } catch {
            delegate?.didFinishAnalyzation(with: .failure(error))
            delegate = nil
        }
    }
    
    /// The handler that takes in the result fro the vision api and tries to extract card retated info from it
    lazy var requestHandler: ((VNRequest, Error?) -> Void)? = { [weak self] request, _ in
        guard let strongSelf = self else { return }
        // Make sure the vision api worked and returned something to analyze
        guard let results = request.results as? [VNRecognizedTextObservation] else { return }
        // A temp card object to hold detecting data, will be used to confirm before calling the callback
        var creditCard = TapCard()
        
        let maxCandidates = 1
        
        if strongSelf.selectedCard.tapCardNumber?.tap_length ?? 0 != 0 {
            return
        }
        
        for result in results {
            
            guard
                let candidate = result.topCandidates(maxCandidates).first,
                candidate.confidence > 0.1
            else { continue }
            
            let string = candidate.string
            // If the detected string is one of the to skip values, then we simply Skip!
            if Regex.wordsToSkip.contains(where: { string.lowercased().contains($0) }) { continue }
            
            // check if it is  valid caard number
            if let cardNumber = Regex.creditCardNumber.firstMatch(in: string)?
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            {
                // check again if it is a valid brand detected with this number
                let definedCard = CardValidator.validate(cardNumber: cardNumber,preferredBrands: self?.allowedCardBrands)
                
                if let definedBrand = definedCard.cardBrand,
                   definedCard.validationState != .invalid {
                    creditCard.tapCardNumber = cardNumber
                }
                // the first capture is the entire regex match, so using the last
            } else if let expiry:String = Regex.year.matches(in: string).last,
                      expiry.components(separatedBy: "/").count == 2 {
                let components = expiry.components(separatedBy: "/")
                // Make sure that detected Month and Year parts are actually integres!
                if let yearInt:Int = Int(components[1]), let monthInt:Int = Int(components[0]) {
                    creditCard.tapCardExpiryYear = components[1]
                    creditCard.tapCardExpiryMonth = components[0]
                }
                
            } /*else if let name = Regex.name.firstMatch(in: string) {
               let containsInvalidName = Regex.invalidNames.contains { name.lowercased().contains($0) }
               if containsInvalidName { continue }
               //creditCard.tapCardName = name
               let count = strongSelf.predictedCardInfo[.name(name), default: 0]
               strongSelf.predictedCardInfo[.name(name)] = count + 1
               if count > 2 {
               print("POSSIBLE NAME : \(name)")
               }
               }*/ else {
                   continue
               }
        }
        
        // Check vertical card number
        if let verticalCardNumber:String = self?.checkVerticalCardNumber(maxCandidates: maxCandidates, results: results) {
            creditCard.tapCardNumber = verticalCardNumber
        }
        
        // Name
        /*if let name = creditCard.tapCardName {
         let count = strongSelf.predictedCardInfo[.name(name), default: 0]
         strongSelf.predictedCardInfo[.name(name)] = count + 1
         if count > 2 {
         strongSelf.selectedCard.tapCardName = name
         }
         }*/
        
        // ExpireDate
        strongSelf.selectedCard.tapCardExpiryYear   = creditCard.tapCardExpiryYear
        strongSelf.selectedCard.tapCardExpiryMonth  = creditCard.tapCardExpiryMonth
        
        // Number
        if let number = creditCard.tapCardNumber {
            let count = strongSelf.predictedCardInfo[.number(number), default: 0]
            strongSelf.predictedCardInfo[.number(number)] = count + 1
            if count > 2 {
                strongSelf.selectedCard.tapCardNumber = number
            }
        }
        
        // If we detected a valid card number, it is time to callback the delegate with what we got!
        if strongSelf.selectedCard.tapCardNumber != nil {
            strongSelf.delegate?.didFinishAnalyzation(with: .success(strongSelf.selectedCard))
            strongSelf.delegate = nil
        }
    }
    
    
    /**
     Parses given extracted strings to check the possibility of a card number in vertical format
     - Parameter maxCandidates: How many candidates we are looking to
     - Parameter results: The extracted text snippets we are looking into
     - returns : A valid defined card number and null otherwise
     */
    internal func checkVerticalCardNumber(maxCandidates:Int = 1,results:[VNRecognizedTextObservation]) -> String? {
        
        // Let us filte ronly text peices that have digits only
        var filteredValues:[String] = results.filter { result in
            
            guard
                let candidate = result.topCandidates(maxCandidates).first,
                candidate.confidence > 0.1,
                candidate.string.tap_containsOnlyDigitsVerticalCardNumber
            else { return false }
            
            return true
            // Then let us merge them togeter
        }.map { $0.topCandidates(maxCandidates).first?.string ?? "" }
        
        // The vertical numbers has a structure that confuses with digit 1 because it shows the numbers like this
        // |2222|
        // |2222| etc
        // So for vertical detection only, if a peice of text is of lenght 5 and ends or starts with 1, we will remove this 1
        
        filteredValues = filteredValues.map { filteredValue -> String in
            // remove (,),[,] which comes because of confusion happens in vertical number format
            // |2222|
            // |2222|
            let onlyDigitsValue = filteredValue.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            if onlyDigitsValue.count == 5 {
                if onlyDigitsValue.hasPrefix("1") {
                    return onlyDigitsValue.tap_substring(from: 1)
                }else if onlyDigitsValue.hasSuffix("1") {
                    return onlyDigitsValue.tap_substring(to: onlyDigitsValue.count - 1)
                }
            }
            return onlyDigitsValue
        }
        
        // For every detected line let us scan it get it all possible card number Regex matches
        if filteredValues.count > 0 {
            let joinedString = (filteredValues.reduce(""){ "\($0)\($1)" }).components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            let matches = Regex.creditCardNumber.matches(in: joinedString)
            /*let validNumbers = matches.filter({ match in
             let definedCard = CardValidator.validate(cardNumber: match,preferredBrands: self.allowedCardBrands)
             
             if let _ = definedCard.cardBrand,
             definedCard.validationState == .valid {
             return true
             }
             return false
             })*/
            for match in matches {
                // Check if there is a match, that is can be validated as an accepted card brand from the allowed brands
                let definedCard = CardValidator.validate(cardNumber: match,preferredBrands: self.allowedCardBrands)
                
                if let _ = definedCard.cardBrand,
                   definedCard.validationState == .valid {
                    return match
                }
            }
        }
        return nil
    }
}
#endif

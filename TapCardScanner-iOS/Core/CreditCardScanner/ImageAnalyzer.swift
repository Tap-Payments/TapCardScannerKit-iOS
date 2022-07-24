//
//  ImageAnalyzer.swift
//  Created by Osama Rabie on 24/07/2021.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
#if canImport(Vision)
import Vision
import CommonDataModelsKit_iOS

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
    
    /// - Parameter delegate: A delegate to pass callbacks from the image analyzer
    init(delegate: ImageAnalyzerProtocol) {
        self.delegate = delegate
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
                .replacingOccurrences(of: "-", with: "") {
                creditCard.tapCardNumber = cardNumber

                // the first capture is the entire regex match, so using the last
            } else if let expiry:String = Regex.year.matches(in: string).last,
                      expiry.components(separatedBy: "/").count == 2 {
                let components = expiry.components(separatedBy: "/")
                // Make sure that detected Month and Year parts are actually integres!
                if let yearInt:Int = Int(components[1]), let monthInt:Int = Int(components[0]) {
                    creditCard.tapCardExpiryYear = components[1]
                    creditCard.tapCardExpiryMonth = components[0]
                }

            } else if let name = Regex.name.firstMatch(in: string) {
                let containsInvalidName = Regex.invalidNames.contains { name.lowercased().contains($0) }
                if containsInvalidName { continue }
                creditCard.tapCardName = name

            } else {
                continue
            }
        }

        // Name
        if let name = creditCard.tapCardName {
            let count = strongSelf.predictedCardInfo[.name(name), default: 0]
            strongSelf.predictedCardInfo[.name(name)] = count + 1
            if count > 2 {
                strongSelf.selectedCard.tapCardName = name
            }
        }
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
}
#endif

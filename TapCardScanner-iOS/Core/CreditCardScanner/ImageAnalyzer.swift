//
//  ImageAnalyzer.swift
//
//
//  Created by miyasaka on 2020/07/30.
//

import Foundation
#if canImport(Vision)
import Vision
import CommonDataModelsKit_iOS

protocol ImageAnalyzerProtocol: AnyObject {
    func didFinishAnalyzation(with result: Result<TapCard, Error>)
}

@available(iOS 13, *)
final class ImageAnalyzer {
    enum Candidate: Hashable {
        case number(String), name(String)
        case expireDate(DateComponents)
    }

    typealias PredictedCount = Int

    private var selectedCard = TapCard()
    private var predictedCardInfo: [Candidate: PredictedCount] = [:]

    private weak var delegate: ImageAnalyzerProtocol?
    init(delegate: ImageAnalyzerProtocol) {
        self.delegate = delegate
    }

    // MARK: - Vision-related

    public lazy var request = VNRecognizeTextRequest(completionHandler: requestHandler)
    func analyze(image: CGImage) {
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

    lazy var requestHandler: ((VNRequest, Error?) -> Void)? = { [weak self] request, _ in
        guard let strongSelf = self else { return }

        let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
        let month: Regex = #"/^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})$/"#
        let year: Regex = #"\d{2}\/(\d{2})"#
        let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward"]
        // These may be contained in the date strings, so ignore them only for names
        let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year"]
        let name: Regex = #"^[\\p{L}'][\\p{L}' -]{1,25}$"#

        guard let results = request.results as? [VNRecognizedTextObservation] else { return }

        var creditCard = TapCard()

        let maxCandidates = 1
        for result in results {
            guard
                let candidate = result.topCandidates(maxCandidates).first,
                candidate.confidence > 0.1
            else { continue }

            let string = candidate.string
            let containsWordToSkip = wordsToSkip.contains { string.lowercased().contains($0) }
            if containsWordToSkip { continue }

            if let cardNumber = creditCardNumber.firstMatch(in: string)?
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "") {
                creditCard.tapCardNumber = cardNumber

                // the first capture is the entire regex match, so using the last
            } else if let expiry:String = year.matches(in: string).last,
                      expiry.components(separatedBy: "/").count == 2 {
                // Appending 20 to year is necessary to get correct century
                let components = expiry.components(separatedBy: "/")
                if let yearInt:Int = Int(components[1]), let monthInt:Int = Int(components[0]) {
                    creditCard.tapCardExpiryYear = components[1]
                    creditCard.tapCardExpiryMonth = components[0]
                }

            } else if let name = name.firstMatch(in: string) {
                let containsInvalidName = invalidNames.contains { name.lowercased().contains($0) }
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

        if strongSelf.selectedCard.tapCardNumber != nil {
            strongSelf.delegate?.didFinishAnalyzation(with: .success(strongSelf.selectedCard))
            strongSelf.delegate = nil
        }
    }
}
#endif

//
//  GoogleVisionScanner.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 24/07/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation
import CommonDataModelsKit_iOS

/// Extension to encapsulate the needed google vision integration methods
internal extension TapInlineCardScanner {
    /**
     A method responsible for talking to google cloud vision API to exttact text from image
     - Parameter imageBase64: The base64 encoding in ASCII representation of the uiimage
     - Parameter onTextExtracted: A block that will send back the extracted text
     - Parameter onErrorOccured: A block that will send back any error occured dring any phase of the process
     */
    func googleCloudVisionApi(with imageBase64:String, onTextExtracted:((String)->())? = nil,onErrorOccured:((String)->())? = nil) {
        // Create the request
        let request = createGoogleCloudVisionRequest(with: imageBase64)
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorMessage:String? = nil
            // Check for Error
            if let error = error {
                errorMessage = "Error took place \(error)"
            }else {
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    do {
                        // Check that google accepted the reqest and it did extract any peice of text from the given image
                        let responseDict:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        if let response:[[String:Any]] = responseDict["responses"] as? [[String : Any]], response.count == 1,
                           let fullAnotation:[String:Any] = response[0]["fullTextAnnotation"] as? [String:Any],
                           let parsedText:String = fullAnotation["text"] as? String {
                            if let onTextExtractedBlock = onTextExtracted {
                                onTextExtractedBlock(parsedText)
                            }
                        }else {
                            errorMessage = "Error took place Wrong data from google as follows : \(dataString)"
                        }
                    }catch{
                        errorMessage = "Error took place \(error)"
                    }
                }else {
                    errorMessage = "Unkown Error took place"
                }
            }
            
            if let nonNullErrorMessage = errorMessage,
               let errorBlock = onErrorOccured {
                //FlurryLogger.endTimerForEvent(with: "Scan_From_Image_Called", params: ["success":"false","error":nonNullErrorMessage])
                errorBlock(nonNullErrorMessage)
            }
        }
        task.resume()
    }
    
    /**
     A method responsible for creating the URL request to be utilised in performing a POST to google cloud vision API
     - Parameter imageBase64: The base64 encoding in ASCII representation of the uiimage
     - Returns: The url request
     */
    func createGoogleCloudVisionRequest(with imageBase64:String)->URLRequest {
        // Prepare URL
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCZs_vdFd2lI7650JuXabYNJUh4ljzTFgk")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "{'requests': [{'image': {'content': '\(imageBase64)' },'imageContext':{'languageHints':['en']}, 'features': [{'type': 'TEXT_DETECTION' }]}]}";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        return request
    }
    
    /**
     This method holds the logic for matching the text extracted from google vision cloud api to a potential card result
     - Parameter extractedText: The extracted text by google cloud vision for the given image
     - Returns: The potential scanned tap card from the extracted text.
     */
    func processGoogleVision(with extractedText:String) -> TapCard {
        let scannedCard:TapCard = .init()
        // Let us go through the extracted lines
        extractedText.enumerateLines { [weak self] line, _ in
            self?.match(string: line, to: scannedCard)
        }
        //FlurryLogger.endTimerForEvent(with: "Scan_From_Image_Called", params: ["success":"true","error":"","card_number":scannedCard.tapCardNumber ?? "","card_name":scannedCard.tapCardName ?? "","card_month":scannedCard.tapCardExpiryMonth ?? "","card_year":scannedCard.tapCardExpiryYear ?? ""])
        return scannedCard
    }
    
    /**
     The methoid that holds the logic for trying to match a given string to any part of a credit card
     - Parameter string: The textt we want to check if it matches any card details
     - Parameter scannedCard: The scanned card object we need to add the details into
     */
    func match(string:String, to scannedCard:TapCard) {
        // First check if we already parsed a card number
        if let _ = scannedCard.tapCardNumber{
            // Check For Card name
            // We check for name after filling in the number to avoid bank names at the top of the cards
            if let _ = scannedCard.tapCardName {}else{
                if string.isaPotentialCardName() {
                    scannedCard.tapCardName = string
                }
            }
        } else {
            // Check if it is a potential card number
            if string.isPotentialCardNumber() {
                scannedCard.tapCardNumber = string
            }
        }
        if let _ = scannedCard.tapCardExpiryMonth{} else {
            if let nonNullExpiryDateFound = string.extractCardExpiry() {
                scannedCard.tapCardExpiryMonth = nonNullExpiryDateFound.components(separatedBy: "/")[0]
                scannedCard.tapCardExpiryYear = nonNullExpiryDateFound.components(separatedBy: "/")[1]
            }
        }
    }
}

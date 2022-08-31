//
//  ExtraFee.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation

/// Represents the extra fees model. This will be used when a user selects a payment option like credit card, he has to know he will be paying some more money for it :)
/// - tag: ExtraFee
public final class ExtraFee: AmountModificatorModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency code.
    internal let currency: TapCurrencyCode
    
    // MARK: Methods
    
    public required init(type: AmountModificationType, value: Double, currency: TapCurrencyCode, minFee:Double = 0, maxFee:Double = 0) {
        self.currency = currency
        super.init(type: type, value: value, minFee: minFee, maxFee: maxFee)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(AmountModificationType.self, forKey: .type)
        let value = try container.decode(Double.self, forKey: .value)
        let maxFee = try container.decodeIfPresent(Double.self, forKey: .maxFee) ?? 0
        let minFee = try container.decodeIfPresent(Double.self, forKey: .minFee) ?? 0
        let currency = try container.decode(TapCurrencyCode.self, forKey: .currency)
        
        self.init(type: type, value: value, currency: currency,minFee:minFee, maxFee: maxFee)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type       = "type"
        case value      = "value"
        case currency   = "currency"
        case maxFee     = "maximum_fee"
        case minFee     = "minimum_fee"
    }
    
    /**
     Used to compute the correct extra fees to be applied
     - Parameter for: The amount we need to compute the extra fees regards to
     - Returns: The computed extra fees, putting in mind the type of the extra fees, the min and the max fees
     */
    public func extraFeeValue(for amount:Double) -> Double {
        // First get the correct extra fee with regards the amount and the extra fee type Percentage or Fixed
        let computedExtraFee:Double = caluclateActualModificationValue(with: amount)
        // We need to make sure if the computed fixed fee is in the range of min/max, otherwise if it is less than than min we set it to min and if more than max we set it to max
        // In the case where min and max = 0 then we compute the value right away
        if minFee == 0 && maxFee == 0 {
            return computedExtraFee
        }else {
            return max(minFee,min(computedExtraFee, maxFee))
        }
    }
}

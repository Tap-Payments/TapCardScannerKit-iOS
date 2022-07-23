/*
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation

/// Represent the model of an amount modification object for a payment item
@objc open class AmountModificatorModel : NSObject, Codable {
    
    /// The type of the applied discount whether fixed or percentage
    public let type : AmountModificationType?
    /// The value of the discount itself
    public let value : Double?
    /// The minimum fees allowed for this extra fees.
    public var minFee: Double
    /// The maximum fees allowed for this extra fees.
    public var maxFee: Double
    /**
     - Parameter type: The type of the applied discount whether fixed or percentage
     - Parameter value: The value of the discount itself
     */
    @objc public init(type: AmountModificationType = .Fixed, value: Double = 0, minFee: Double = 0, maxFee: Double = 0) {
        self.type   = type
        self.value  = value
        self.maxFee = maxFee
        self.minFee = minFee
    }
    
    enum CodingKeys: String, CodingKey {
        
        case type       = "type"
        case value      = "value"
        case maxFee     = "maximum_fee"
        case minFee     = "minimum_fee"
    }
    
    
    required public init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        type        = try values.decodeIfPresent(AmountModificationType.self, forKey: .type) ?? .Fixed
        value       = try values.decodeIfPresent(Double.self, forKey: .value)
        minFee      = try values.decodeIfPresent(Double.self, forKey: .minFee) ?? 0
        maxFee      = try values.decodeIfPresent(Double.self, forKey: .maxFee) ?? 0
    }
    
    /**
     Calculates and apply the correct modification value scheme for a given a price
     - Parameter originalPrice: The original price the modification will be applied to
     - Returns: The modification value to be applied. Whether the original value if it is a fixed based or the correct value if percentage modification based
     */
    public func caluclateActualModificationValue(with originalPrice:Double) -> Double {
        
        var modificationValue:Double = 0
        
        // We first need to know the type of the modification
        switch type {
        case .Fixed:
            modificationValue = calculateFixedAmount()
        case .Percentage:
            modificationValue = ( calculatePercentageAmount() * originalPrice )
        default:
            modificationValue = 0
        }
        
        // Make sure now that the discounted value is bigger than 0 otherwise return the original value
        guard modificationValue >= 0 else { return 0 }
        return modificationValue
    }
    
    /**
     Calculates and apply the correct amount modification scheme in case of a fixed amount modification is applied
     - Returns: The amount value as is or 0 if the amount value is negative
     */
    private func calculateFixedAmount() -> Double {
        // Check if the passed amount modification is a correct one, and return the correct value
        guard let nonNullValue = value, nonNullValue >= 0.0 else { return 0 }
        return nonNullValue
    }
    
    /**
     Calculates and apply the correct amount modification scheme in case of a percentage modification is applied
     - Returns: The percentage value of the amount value or 0 if the percentage value is outside the range of 0..100
     */
    private func calculatePercentageAmount() -> Double {
        // Check if the passed percentage is a correct one, and return the correct value
        guard let nonNullValue = value, nonNullValue >= 0.0, nonNullValue <= 100 else { return 0 }
        return (nonNullValue/100)
    }
}


/*
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation

/// Represent the model of an ITEM inside an order/transaction
@objcMembers public class ItemModel : NSObject, Codable {
    
    /// The title of the item
    public var title : String?
    /// A description of the item
    public let itemDescription : String?
    /// The raw original price in the original currency
    public let price : Double?
    /// The quantity added to this item
    internal let quantityy : Quantity
    /// The discount applied to the item's price
    public let discount : AmountModificatorModel?
    /// The list of Taxes to be applied to the item's price after discount
    public let taxes : [Tax]?
    /// The price final amount after applyig discount & taxes
    public var totalAmount:Double {
        didSet {
            // Check if we need to auto compute it
            if totalAmount == 0 { totalAmount = itemFinalPrice() }
        }
    }
    
    public var quantity : Int? {
        return Int(quantityy.value)
    }
    /**
     - Parameter title: The title of the item
     - Parameter description: A description of the item
     - Parameter price: The raw original price in the original currency
     - Parameter quantity: The quantity added to this item
     - Parameter discount: The discount applied to the item's price
     - Parameter taxes: The list of Taxs to be applied to the item's price after discount
     - Parameter totalAmount: The price final amount after applyig discount & taxes
     */
    @objc public init(title: String?, description: String?, price: Double = 0, quantity: Quantity = .init(value: 0, unitOfMeasurement: .units), discount: AmountModificatorModel?,taxes:[Tax]? = nil,totalAmount:Double = 0) {
        self.title = title
        self.itemDescription = description
        self.price = price
        self.quantityy = quantity
        self.discount = discount
        self.taxes = taxes
        self.totalAmount = totalAmount
        super.init()
        defer {
            self.totalAmount = totalAmount
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case title              = "name"
        case itemDescription    = "description"
        case quantityy          = "quantity"
        case price              = "amount_per_unit"
        case discount           = "discount"
        case taxes              = "taxes"
        case totalAmount        = "total_amount"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        itemDescription = try values.decodeIfPresent(String.self, forKey: .itemDescription)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        quantityy = try values.decode(Quantity.self, forKey: .quantityy)
        discount = try values.decodeIfPresent(AmountModificatorModel.self, forKey: .discount)
        taxes = try values.decodeIfPresent([Tax].self, forKey: .taxes) ?? []
        totalAmount = try values.decodeIfPresent(Double.self, forKey: .price) ?? 0
    }
    
    /**
     Holds the logic to calculate the final price of the item based on price, quantity and discount
     - Parameter convertFromCurrency: The original currency if needed to convert from
     - Parameter convertToCurrenct: The new currency if needed to convert to
     - Returns: The total price of the item as follows : (itemPrice-discount+taxes) * quantity
     */
    public func itemFinalPrice(convertFromCurrency:AmountedCurrency? = nil,convertToCurrenct:AmountedCurrency? = nil) -> Double {
        
        // Defensive coding, make sure all values are set
        guard let price = price else { return 0 }
        
        // First apply the discount if any
        let discountedItemPrice:Double = price - (discount?.caluclateActualModificationValue(with: price) ?? 0)
        // Secondly apply the taxes if any
        var discountedWithTaxesPrice:Double = taxes?.reduce(discountedItemPrice) { $0 + $1.amount.caluclateActualModificationValue(with: discountedItemPrice) } ?? discountedItemPrice
        // Put in the quantity in action
        discountedWithTaxesPrice = discountedWithTaxesPrice * quantityy.value
        
        // Check if the caller wants to make a conversion to a certain currency
        guard let originalCurrency = convertFromCurrency, let conversionCurrency = convertToCurrenct,
              originalCurrency.currency != .undefined, conversionCurrency.currency !=  .undefined else {
            return discountedWithTaxesPrice
        }
        
        return discountedWithTaxesPrice * (conversionCurrency.rate ?? 1)
    }
    
}

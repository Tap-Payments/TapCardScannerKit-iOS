/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
/// Struct to hold info about an item in a transaction
@objc public class TransactionItemModel : NSObject, Codable {
    /// The displayed title of the item
	@objc public let title : String?
    /// The displayed description of the item
	@objc public let itemDescription : String?
    /// The original price of the item
	@objc public var price : Double = 0
    /// The discount applied
	@objc public var discount : Double = 0
    /// How many insances of this item are there
	@objc public var quantity : Double = 0

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case itemDescription = "description"
		case price = "price"
		case discount = "discount"
		case quantity = "quantity"
	}

    required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		itemDescription = try values.decodeIfPresent(String.self, forKey: .itemDescription)
        price = try values.decodeIfPresent(Double.self, forKey: .price) ?? 0
		discount = try values.decodeIfPresent(Double.self, forKey: .discount) ?? 0
		quantity = try values.decodeIfPresent(Double.self, forKey: .quantity) ?? 0
	}
}

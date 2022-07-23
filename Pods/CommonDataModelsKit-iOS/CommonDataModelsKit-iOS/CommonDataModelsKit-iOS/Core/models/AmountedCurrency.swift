//
//  AmountedCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Structure holding currency and the amount.
@objc public class AmountedCurrency: NSObject,Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency.
    public var currency: TapCurrencyCode
    
    /// The decimal digits.
    public var decimalDigits: Int
    
    /// Amount.
    public var amount: Double
    
    /// Currency symbol.
    public var currencySymbol: String
    
    /// Currency flag icon url.
    public var flag: String
    
    /// Conversion factor to transaction currency from baclend
    public var rate: Double?
    
    // MARK: Methods
    
    @objc public convenience init(_ currency: TapCurrencyCode, _ amount: Double, _ flag: String, _ decimalDigits: Int = 2) {
        self.init(currency, amount, currency.symbolRawValue, flag, decimalDigits)
    }
    
    @objc public init(_ currency: TapCurrencyCode, _ amount: Double, _ currencySymbol: String, _ flag: String, _ decimalDigits: Int = 2) {
        
        self.currency       = currency
        self.amount         = amount
        self.currencySymbol = currencySymbol
        self.flag           = flag
        self.decimalDigits  = decimalDigits
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency       = "currency"
        case amount         = "amount"
        case currencySymbol = "symbol"
        case rate           = "rate"
        case flag           = "flag"
        case decimalDigits  = "decimal_digit"
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        return currency.appleRawValue == (object as? AmountedCurrency)?.currency.appleRawValue
    }
}

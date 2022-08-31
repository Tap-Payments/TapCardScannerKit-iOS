//
//  TapAmountedCurrencyFormatter.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 6/11/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

/// A dictionary to allow any caller to set the custom currency symbols as per his demand. By settin a dictionary where keys are currency raw values and values are the needed symbol


/// The methods to be implemented by the Currency Formatter
public protocol TapAmountedCurrencyFormatterProtocol {
    var numberFormatter: NumberFormatter! { get }
    var maxDigitsCount: Int { get }
    var decimalDigits: Int { get set }
    var maxValue: Double? { get set }
    var minValue: Double? { get set }
    var initialText: String { get }
    var currencySymbol: String { get set }
    var currencyCodeSpace: Bool { get set }
    var localizeCurrencySymbol: Bool { get set }
    
    func string(from double: Double?) -> String?
    func unformatted(string: String) -> String?
    func double(from string: String) -> Double?
    func updated(formattedString string: String) -> String?
}
/// Tap Currency formatter responsible for formatting a given number to its correct market representation of the selected currency with many options

@objcMembers public class TapAmountedCurrencyFormatter:NSObject, TapAmountedCurrencyFormatterProtocol {
    
    @objc public static var customCurrencySymbols:[Int:String]?
    
    @objc public var localizeCurrencySymbol: Bool = false
    
    
    /// Indicates a space between currency code and amount or not. $ 100 or $100
    @objc public var currencyCodeSpace: Bool = true
    
    
    /// Set the locale to retrieve the currency from
    /// You can pass a Swift type Locale or one of the
    /// Locales enum options - that encapsulates all available locales.
    public var locale: LocaleConvertible {
        set { self.numberFormatter.locale = newValue.locale }
        get { return self.numberFormatter.locale }
    }
    
    /// Set the desired currency type
    /// * Note: The currency take effetcs above the displayed currency symbol,
    /// however details such as decimal separators, grouping separators and others
    /// will be set based on the defined locale. So for a precise experience, please
    /// preferarbly setup both, when you are setting a currency that does not match the
    /// default/current user locale.
    public var currency: TapCurrencyCode {
        set { numberFormatter.currencyCode = newValue.appleRawValue }
        get { return TapCurrencyCode(appleRawValue: numberFormatter.currencyCode) ?? TapCurrencyCode.USD }
    }
    
    /// Define if currency symbol should be presented or not.
    /// Note: when set to false the current currency symbol is removed
    public var showCurrencySymbol: Bool = true {
        didSet {
            numberFormatter.currencySymbol = showCurrencySymbol ? numberFormatter.currencySymbol : ""
        }
    }
    
    /// The currency's symbol.
    /// Can be used to read or set a custom symbol.
    /// Note: showCurrencySymbol must be set to true for
    /// the currencySymbol to be correctly changed.
    public var currencySymbol: String {
        set {
            guard showCurrencySymbol else { return }
            numberFormatter.currencySymbol = newValue
        }
        get { return numberFormatter.currencySymbol }
    }
    
    /// The lowest number allowed as input.
    /// This value is initially set to the text field text
    /// when defined.
    public var minValue: Double? {
        set {
            guard let newValue = newValue else { return }
            numberFormatter.minimum = NSNumber(value: newValue)
        }
        get {
            if let minValue = numberFormatter.minimum {
                return Double(truncating: minValue)
            }
            return nil
        }
    }
    
    /// The highest number allowed as input.
    /// The text field will not allow the user to increase the input
    /// value beyond it, when defined.
    public var maxValue: Double? {
        set {
            guard let newValue = newValue else { return }
            numberFormatter.maximum = NSNumber(value: newValue)
        }
        get {
            if let maxValue = numberFormatter.maximum {
                return Double(truncating: maxValue)
            }
            return nil
        }
    }
    
    /// The number of decimal digits shown.
    /// default is set to zero.
    /// * Example: With decimal digits set to 3, if the value to represent is "1",
    /// the formatted text in the fractions will be ",001".
    /// Other than that with the value as 1, the formatted text fractions will be ",1".
    public var decimalDigits: Int {
        set {
            numberFormatter.minimumFractionDigits = newValue
            numberFormatter.maximumFractionDigits = newValue
        }
        get { return numberFormatter.minimumFractionDigits }
    }
    
    /// Set decimal numbers behavior.
    /// When set to true decimalDigits are automatically set to 2 (most currencies pattern),
    /// and the decimal separator is presented. Otherwise decimal digits are not shown and
    /// the separator gets hidden as well
    /// When reading it returns the current pattern based on the setup.
    /// Note: Setting decimal digits after, or alwaysShowsDecimalSeparator can overlap this definitios,
    /// and should be only done if you need specific cases
    public var hasDecimals: Bool {
        set {
            self.decimalDigits = newValue ? 2 : 0
            self.numberFormatter.alwaysShowsDecimalSeparator = newValue ? true : false
        }
        get { return decimalDigits != 0 }
    }
    
    /// Defines the string that is the decimal separator
    /// Note: only presented when hasDecimals is true OR decimalDigits
    /// is greater than 0.
    public var decimalSeparator: String {
        set { self.numberFormatter.currencyDecimalSeparator = newValue }
        get { return numberFormatter.currencyDecimalSeparator }
    }
    
    /// Can be used to set a custom currency code string
    public var currencyCode: String {
        set { self.numberFormatter.currencyCode = newValue }
        get { return numberFormatter.currencyCode }
    }
    
    /// Sets if decimal separator should always be presented,
    /// even when decimal digits are disabled
    public var alwaysShowsDecimalSeparator: Bool {
        set { self.numberFormatter.alwaysShowsDecimalSeparator = newValue }
        get { return numberFormatter.alwaysShowsDecimalSeparator }
    }
    
    /// The amount of grouped numbers. This definition is fixed for at least
    /// the first non-decimal group of numbers, and is applied to all other
    /// groups if secondaryGroupingSize does not have another value.
    public var groupingSize: Int {
        set { self.numberFormatter.groupingSize = newValue }
        get { return numberFormatter.groupingSize }
    }
    
    /// The amount of grouped numbers after the first group.
    /// Example: for the given value of 99999999999, when grouping size
    /// is set to 3 and secondaryGroupingSize has 4 as value,
    /// the number is represented as: (9999) (9999) [999].
    /// Beign [] grouping size and () secondary grouping size.
    public var secondaryGroupingSize: Int {
        set { self.numberFormatter.secondaryGroupingSize = newValue }
        get { return numberFormatter.secondaryGroupingSize }
    }
    
    /// Defines the string that is shown between groups of numbers
    /// * Example: a monetary value of a thousand (1000) with a grouping
    /// separator == "." is represented as `1.000` *.
    /// Note: It automatically sets hasGroupingSeparator to true.
    public var groupingSeparator: String {
        set {
            self.numberFormatter.currencyGroupingSeparator = newValue
            self.numberFormatter.usesGroupingSeparator = true
        }
        get { return self.numberFormatter.currencyGroupingSeparator }
    }
    
    /// Sets if has separator between all group of numbers.
    /// * Example: when set to false, a bug number such as a million
    /// is represented by tight numbers "1000000". Otherwise if set
    /// to true each group is separated by the defined `groupingSeparator`. *
    /// Note: When set to true only works by defining a grouping separator.
    public var hasGroupingSeparator: Bool {
        set { self.numberFormatter.usesGroupingSeparator = newValue }
        get { return self.numberFormatter.usesGroupingSeparator }
    }
    
    /// Value that will be presented when the text field
    /// text values matches zero (0)
    public var zeroSymbol: String? {
        set { numberFormatter.zeroSymbol = newValue }
        get { return numberFormatter.zeroSymbol }
    }
    
    /// Value that will be presented when the text field
    /// is empty. The default is "" - empty string
    public var nilSymbol: String {
        set { numberFormatter.nilSymbol = newValue }
        get { return numberFormatter.nilSymbol }
    }
    
    /// Encapsulated Number formatter
    public var numberFormatter: NumberFormatter!
    
    /// Maximum allowed number of integers
    public var maxIntegers: Int? {
        set {
            guard let maxIntegers = newValue else { return }
            numberFormatter.maximumIntegerDigits = maxIntegers
        }
        get { return numberFormatter.maximumIntegerDigits }
    }
    
    /// Returns the maximium allowed number of numerical characters
    public var maxDigitsCount: Int {
        return numberFormatter.maximumIntegerDigits + numberFormatter.maximumFractionDigits
    }
    
    /// The value zero formatted to serve as initial text.
    public var initialText: String {
        numberFormatter.string(from: 0) ?? "0.0"
    }
    
    //MARK: - INIT
    
    /// Handler to initialize a new style.
    public typealias InitHandler = ((TapAmountedCurrencyFormatter) -> (Void))
    
    /// Initialize a new currency formatter with optional configuration handler callback.
    ///
    /// - Parameter handler: configuration handler callback.
    public init(_ handler: InitHandler? = nil) {
        super.init()
        numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.numberStyle = .currency
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        
        handler?(self)
    }
}

// MARK: Format
extension TapAmountedCurrencyFormatter {
    
    /// Returns a currency string from a given double value.
    ///
    /// - Parameter double: the monetary amount.
    /// - Returns: formatted currency string.
    public func string(from double: Double?) -> String? {
        let validValue = getAdjustedForDefinedInterval(value: double)
        var formattedValue:String? = ""
        // Let us check if the caller asked to localize the currency code + value string, to make sure even non English characters for currency symbols will come in the lead
        if localizeCurrencySymbol {
            // Then we need to make sure the generated string is localized to make sure the symbol comes always as a prefix
            let currentSymbol =  numberFormatter.currencySymbol
            // ask the formatter not to the put the code as per his native development
            numberFormatter.currencySymbol = ""
            // Localize the result to make sure it is always prefixed with the currency symbol
            formattedValue = String.localizedStringWithFormat("%@%@", (currentSymbol ?? ""),(numberFormatter.string(from: validValue) ?? ""))
            // Set the currency symbol back
            numberFormatter.currencySymbol = currentSymbol
        }else {
            // Then we check if the user set a custom code for this currency, we have to use it
            if let customCurrencySymbols:[Int:String] = TapAmountedCurrencyFormatter.customCurrencySymbols,
               let customCurrencySymbol:String = customCurrencySymbols[currency.rawValue] {
                numberFormatter.currencySymbol = "\(customCurrencySymbol) "
            }
            // Not forced by the caller, hence we leave it to the default formatting for this currency as per Apple development.
            formattedValue = numberFormatter.string(from: validValue)
        }
        
        return currencyCodeSpace ? formattedValue : formattedValue?.replacingOccurrences(of: " ", with: "")
    }
    
    /// Returns a double from a string that represents a numerical value.
    ///
    /// - Parameter string: string that describes the numerical value.
    /// - Returns: the value as a Double.
    public func double(from string: String) -> Double? {
        return Double(string)
    }
    
    /// Receives a currency formatted string and returns its
    /// numerical/unformatted representation.
    ///
    /// - Parameter string: currency formatted string
    /// - Returns: numerical representation
    public func unformatted(string: String) -> String? {
        return string.numeralFormat()
    }
}

extension TapAmountedCurrencyFormatter {
    
    /// Returns the update of an already formatted string, replacing its decimal separator
    /// and adjusting it to formater's min and max values if needed.
    ///
    /// - Parameter string: formatted string
    /// - Returns: updated formatted string
    public func updated(formattedString string: String) -> String? {
        var updatedString = string.numeralFormat()
        
        let isNegative: Bool = string.contains(String.negativeSymbol)
        updatedString = isNegative ? .negativeSymbol + updatedString : updatedString
        
        updatedString.updateDecimalSeparator(decimalDigits: decimalDigits)
        
        let value = getAdjustedForDefinedInterval(value: double(from: updatedString))
        return self.string(from: value)
    }
    
    /// Returns the given value adjusted to respect
    /// formatter's max an min values.
    ///
    /// - Parameter value: value to be adjusted if needed
    /// - Returns: Ajusted value
    private func getAdjustedForDefinedInterval(value: Double?) -> Double? {
        if let minValue = minValue, value ?? 0 < minValue {
            return minValue
        } else if let maxValue = maxValue, value ?? 0 > maxValue {
            return maxValue
        }
        return value
    }
}

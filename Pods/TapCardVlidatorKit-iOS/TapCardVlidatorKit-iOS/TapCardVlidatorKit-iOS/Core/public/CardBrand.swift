//
//  CardBrand.swift
//  TapCardValidator
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//
/// Card Brand.
import Foundation

@objc public enum CardBrand: Int,CaseIterable {
    
    case aiywaLoyalty
    case americanExpress
    case benefit
    case careemPay
    case cardGuard
    case cbk
    case dankort
    case discover
    case dinersClub
    case fawry
    case instaPayment
    case interPayment
    case jcb
    case knet
    case mada
    case maestro
    case masterCard
    case naps
    case nspkMir
    case omanNet
    case sadad
    case tap
    case uatp
    case unionPay
    case verve
    case visa
    case visaElectron
    case viva
    case wataniya
    case zain
    case orange
    case etisalat
    case vodafone
    case meeza
    
    case unknown
    
    // MARK: - Private -
    
    private struct RawValues {
        
        fileprivate static let table: [CardBrand: [String]] = [
            
            .aiywaLoyalty       : RawValues.aiywaLoyalty,
            .americanExpress    : RawValues.americanExpress,
            .benefit            : RawValues.benefit,
            .careemPay          : RawValues.careemPay,
            .cardGuard          : RawValues.cardGuard,
            .cbk                : RawValues.cbk,
            .dankort            : RawValues.dankort,
            .discover           : RawValues.discover,
            .dinersClub         : RawValues.dinersClub,
            .fawry              : RawValues.fawry,
            .instaPayment       : RawValues.instaPayment,
            .interPayment       : RawValues.interPayment,
            .jcb                : RawValues.jcb,
            .knet               : RawValues.knet,
            .mada               : RawValues.mada,
            .maestro            : RawValues.maestro,
            .masterCard         : RawValues.masterCard,
            .naps               : RawValues.naps,
            .nspkMir            : RawValues.nspkMir,
            .omanNet            : RawValues.omanNet,
            .sadad              : RawValues.sadad,
            .tap                : RawValues.tap,
            .uatp               : RawValues.uatp,
            .unionPay           : RawValues.unionPay,
            .verve              : RawValues.verve,
            .visa               : RawValues.visa,
            .visaElectron       : RawValues.visaElectron,
            .viva               : RawValues.viva,
            .wataniya           : RawValues.wataniya,
            .zain               : RawValues.zain,
            .orange             : RawValues.orange,
            .etisalat           : RawValues.etisalat,
            .vodafone           : RawValues.vodafone,
            .meeza              : RawValues.meeza
        ]
        
        private static let aiywaLoyalty     = ["Aiywa Loyalty"]
        private static let americanExpress  = ["AMERICAN_EXPRESS", "AMEX"]
        private static let benefit          = ["BENEFIT"]
        private static let careemPay        = ["Careem Pay"]
        private static let cardGuard        = ["CARDGUARD"]
        private static let cbk              = ["CBK"]
        private static let dankort          = ["DANKORT"]
        private static let discover         = ["DISCOVER"]
        private static let dinersClub       = ["DINERS_CLUB", "DINERS"]
        private static let fawry            = ["FAWRY"]
        private static let instaPayment     = ["INSTAPAY"]
        private static let interPayment     = ["INTERPAY"]
        private static let jcb              = ["JCB"]
        private static let knet             = ["KNET"]
        private static let mada             = ["MADA"]
        private static let maestro          = ["MAESTRO"]
        private static let masterCard       = ["MASTERCARD"]
        private static let naps             = ["NAPS"]
        private static let nspkMir          = ["NSPK"]
        private static let omanNet          = ["OMAN_NET","OMANNET"]
        private static let sadad            = ["SADAD_ACCOUNT"]
        private static let tap              = ["TAP"]
        private static let uatp             = ["UATP"]
        private static let unionPay         = ["UNION_PAY", "UNIONPAY"]
        private static let verve            = ["VERVE"]
        private static let visa             = ["VISA"]
        private static let visaElectron     = ["VISA_ELECTRON"]
        private static let viva             = ["Viva PAY"]
        private static let wataniya         = ["Wataniya PAY"]
        private static let zain             = ["Zain PAY"]
        private static let orange           = ["ORANGE PAY"]
        private static let etisalat         = ["ETISALAT PAY"]
        private static let vodafone         = ["VODAFONE PAY"]
        private static let meeza            = ["MEEZA"]
        
        @available(*, unavailable) private init() {}
    }
    
    /// Represents which type of brands is this cards or telecom or apple pay
    public var brandSegmentIdentifier:String {
        get {
            switch self {
            case .zain,.viva,.wataniya,.vodafone,.etisalat,.orange:
                return "telecom"
            default:
                return "cards"
            }
        }
    }
}

// MARK: - Encodable
extension CardBrand: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        guard let value = RawValues.table[self]?.first else {
            
            fatalError("Unknown card brand.")
        }
        
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Decodable
extension CardBrand: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        for (brand, rawValues) in RawValues.table {
            
            guard rawValues.contains(value) else { continue }
            
            self = brand
            return
        }
        
        self = .unknown
    }
}

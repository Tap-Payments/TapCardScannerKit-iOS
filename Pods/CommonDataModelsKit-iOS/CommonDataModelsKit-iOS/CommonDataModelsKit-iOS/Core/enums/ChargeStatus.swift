//
//  ChargeStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//



/// Status of the charge or authorize.
@objc public enum ChargeStatus: Int {
    
    /// Initiated.
    case initiated
    
    /// In progress.
    case inProgress
    
    /// Charge/authorize was abandoned.
    case abandoned
    
    /// Charge/authorize cancelled.
    case cancelled
    
    /// Charge/authorize failed.
    case failed
    
    /// Charge/authorize declined.
    case declined
    
    /// Charge/authorize restricted.
    case restricted
    
    /// Charge was captured.
    case captured
    
    /// Authorize succeed.
    case authorized
	
	/// Charge status is unknown.
	case unknown
	
    /// Charge/authorize void.
    case void
    
    // MARK: - Internal -
    // MARK: Properties
	
    internal var localizedDescription: String {
		
        return self.stringValue
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .initiated:    return "INITIATED"
        case .inProgress:   return "IN_PROGRESS"
        case .abandoned:    return "ABANDONED"
        case .cancelled:    return "CANCELLED"
        case .failed:       return "FAILED"
        case .declined:     return "DECLINED"
        case .restricted:   return "RESTRICTED"
        case .captured:     return "CAPTURED"
        case .authorized:   return "AUTHORIZED"
		case .unknown:		return "UNKNOWN"
        case .void:         return "VOID"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case ChargeStatus.initiated.stringValue:    self = .initiated
        case ChargeStatus.inProgress.stringValue:   self = .inProgress
        case ChargeStatus.abandoned.stringValue:    self = .abandoned
        case ChargeStatus.cancelled.stringValue:    self = .cancelled
        case ChargeStatus.failed.stringValue:       self = .failed
        case ChargeStatus.declined.stringValue:     self = .declined
        case ChargeStatus.restricted.stringValue:   self = .restricted
        case ChargeStatus.captured.stringValue:     self = .captured
        case ChargeStatus.authorized.stringValue:   self = .authorized
		case ChargeStatus.unknown.stringValue:		self = .unknown
        case ChargeStatus.void.stringValue:         self = .void
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: ChargeStatus.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension ChargeStatus: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}

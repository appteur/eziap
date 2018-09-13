//
//  ReceiptValidationError.swift
//  EzIAP
//
//  Created by Seth on 9/12/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public enum ReceiptValidationError: Int16, Error {
    case requestError           = 1899
    case receiptLoadError       = 2000
    case jsonReadFailure        = 21000
    case dataMalformed          = 21002
    case authenticationError    = 21003
    case sharedSecret           = 21004
    case serverUnavailable      = 21005
    case subscriptionExpired    = 21006 // only for iOS 6 style receipts
    case validateOnSandbox      = 21007
    case validateOnLive         = 21008
    case authorizationFailed    = 21010
    
    var code: Int16 {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .requestError: return "Unable to generate a receipt validation request."
        case .receiptLoadError: return "Unable to locate purchase receipt."
        case .jsonReadFailure: return "App store could not read receipt json."
        case .dataMalformed: return "Receipt data malformed or missing."
        case .authenticationError: return "Receipt could not be authenticated."
        case .sharedSecret: return "Shared secret error."
        case .serverUnavailable: return "Receipt server unavailable."
        case .subscriptionExpired: return "Subscription expired."
        case .validateOnSandbox: return "Receipt is a sandbox receipt but sent to production server. Resubmit receipt verification to sandbox."
        case .validateOnLive: return "Receipt is a production receipt but sent to sandbox server. Resubmit receipt to production server."
        case .authorizationFailed: return "The receipt could not be authorized."
        }
    }
}

public func ==(lhs: ReceiptValidationError, rhs: ReceiptValidationError) -> Bool {
    switch (lhs,rhs) {
    case (.requestError, .requestError),
         (.receiptLoadError, .receiptLoadError),
         (.jsonReadFailure, .jsonReadFailure),
         (.dataMalformed, .dataMalformed),
         (.authenticationError, .authenticationError),
         (.sharedSecret, .sharedSecret),
         (.serverUnavailable, .serverUnavailable),
         (.subscriptionExpired, .subscriptionExpired),
         (.validateOnSandbox, .validateOnSandbox),
         (.validateOnLive, .validateOnLive):
        return true
    default:
        return false
    }
}

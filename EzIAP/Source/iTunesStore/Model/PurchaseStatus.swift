//
//  PurchaseStatus.swift
//  sketch2
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

/// Discreet states that an in app purchase transaction can be in during processing.
///
/// - initiated: Transaction was just initiated and is starting to be processed.
/// - complete: Transaction has completed successfully.
/// - cancelled: Transaction was cancelled by the user.
/// - failed: Transaction failed to complete successfully.
public enum PurchaseState {
    case initiated
    case complete
    case cancelled
    case failed
}

/// Encapsulates transaction status for updating the app during the purchase process.
open class PurchaseStatus {
    
    // the current state of the transaction
    public var state: PurchaseState
    
    // if an error was triggered this property will be set
    public var error: Error?
    
    // the corresponding SKPaymentTransaction for the users purchase request
    public var transaction: SKPaymentTransaction?
    
    // a display message for the current status
    public var message: String
    
    public init(state:PurchaseState, error:Error?, transaction:SKPaymentTransaction?, message:String) {
        self.state = state
        self.error = error
        self.transaction = transaction
        self.message = message
    }
}

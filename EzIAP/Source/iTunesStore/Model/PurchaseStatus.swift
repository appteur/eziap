//
//  PurchaseStatus.swift
//  sketch2
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

/// An enumeration of discreet states a purchase transaction can be in during processing.
/// Used in status update callbacks from the iTunesStore class during purchase or restore operations.
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

/// This class encapsulates transaction status values for updating the app during the purchase process via callbacks.
open class PurchaseStatus {
    
    /// The current state of the transaction.
    public var state: PurchaseState
    
    /// Set if an error was triggered, else nil.
    public var error: Error?
    
    /// A reference to the corresponding SKPaymentTransaction for the users purchase request
    public var transaction: SKPaymentTransaction?
    
    /// A user friendly message for the current transaction status.
    public var message: String
    
    public init(state:PurchaseState, error:Error?, transaction:SKPaymentTransaction?, message:String) {
        self.state = state
        self.error = error
        self.transaction = transaction
        self.message = message
    }
}

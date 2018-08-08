//
//  IAPObserver.swift
//  sketch2
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

/**
 This class encapsulates transaction observer behaviors and provides status updates to the iTunesStore class for significant changes to transaction state.
 
 It is not designed to be used outside the framework. It should not need to be modified and should only be used by the iTunesStore class.
 
 */
class IAPObserver: NSObject, SKPaymentTransactionObserver {
    
    /// This delegate will receive status updates for significant transaction changes.
    weak var delegate: iTunesPurchaseStatusReceiver?
    
    override init() {
        super.init()
        
        // add self as a listener/observer on the SKPaymentQueue
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        // remove self as a listener/observer from the SKPaymentQueue
        SKPaymentQueue.default().remove(self)
    }
    
    /// This is a callback from the SKPaymentQueue.
    /// It handles notifying the delegate of status changes for transactions and finishing transactions when required.
    ///
    /// - Parameters:
    ///   - queue: The active SKPaymentQueue for processing transactions.
    ///   - transactions: A list of transactions that have been updated.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        // iterate transaction list
        for transaction in transactions {
            
            // handle each transaction based on its current state
            switch transaction.transactionState {
                
                // Transaction is being added to the server queue
                case .purchasing:
                    break
                
                // Transaction is in queue, user has been charged. Complete transaction now
                case .purchased:
                    // Notify purchase complete status
                    delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .complete, error: nil, transaction: transaction, message: "Purchase Complete."))
                    SKPaymentQueue.default().finishTransaction(transaction)
                
                // Transaction was cancelled or failed before being added to the server queue
                case .failed:
                    // An error occured, notify
                    delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: transaction.error, transaction: transaction, message: "An error occured."))
                    SKPaymentQueue.default().finishTransaction(transaction)
                
                // transaction was rewtored from the users purchase history. Complete transaction now.
                case .restored:
                    // notify purchase completed with status... success
                    delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .complete, error: nil, transaction: transaction, message: "Restore Success!"))
                    SKPaymentQueue.default().finishTransaction(transaction)
                
                // transaction is in the queue, but it's final status is pending user/external action
                case .deferred:
                    break
            }
        }
    }
    
    /// This is a callback from the SKPaymentQueue.
    /// It provides handling for restore purchase requests. We only call 'finishTransaction' here as 'updatedTransactions' function above is called during the restore process and delegate calls are handled there.
    ///
    /// - Parameter queue: The SKPaymentQueue handling the transactions.
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        // check that there are actually transactions
        guard queue.transactions.count > 0 else {
            
            // Queue does not include any transactions, so either user has not yet made a purchase
            // or the user's prior purchase is unavailable, so notify app (and user) accordingly.
            
            print("restore queue.transaction.count === 0")
            return
        }
        
        // process transactions
        for transaction in queue.transactions {
            
            // TODO: provide content access here??
            print("Product restored with id: \(String(describing: transaction.original?.payment.productIdentifier))")
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    /// This is a callback from the SKPaymentQueue.
    /// It is the failure delegate call for the restore purchases process and notifies the delegate of the status change.
    ///
    /// - Parameters:
    ///   - queue: The SKPaymentQueue handling the transactions.
    ///   - error: The error that occured during the restore process.
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        // fire notification to dismiss spinner, restore error
        delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .failed, error: error, transaction: nil, message:"Restore Failed."))
    }
}

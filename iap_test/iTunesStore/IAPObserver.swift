//
//  IAPObserver.swift
//  sketch2
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

class IAPObserver: NSObject, SKPaymentTransactionObserver {
    
    // delegate to propagate status update up
    weak var delegate: iTunesPurchaseStatusReceiver?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing:   // Transaction is being added to the server queue
                    break
                
                case .purchased:    // Transaction is in queue, user has been charged. Complete transaction now
                    // Notify purchase complete status
                    delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .complete, error: nil, transaction: transaction, message: "Purchase Complete."))
                    SKPaymentQueue.default().finishTransaction(transaction)
                
                case .failed:   // Transaction was cancelled or failed before being added to the server queue
                        // An error occured, notify
                    delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: transaction.error, transaction: transaction, message: "An error occured."))
                    SKPaymentQueue.default().finishTransaction(transaction)
                
                case .restored: // transaction was rewtored from the users purchase history. Complete transaction now.
                    // notify purchase completed with status... success
                    delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .complete, error: nil, transaction: transaction, message: "Restore Success!"))
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                case .deferred: // transaction is in the queue, but it's final status is pending user/external action
                    break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        guard queue.transactions.count > 0 else {
            // Queue does not include any transactions, so either user has not yet made a purchase
            // or the user's prior purchase is unavailable, so notify app (and user) accordingly.
            
            print("restore queue.transaction.count === 0")
            return
        }
        
        for transaction in queue.transactions {
            // TODO: provide content access here??
            print("Product restored with id: \(String(describing: transaction.original?.payment.productIdentifier))")
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // fire notification to dismiss spinner, restore error
        delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .failed, error: error, transaction: nil, message:"Restore Failed."))
    }
}

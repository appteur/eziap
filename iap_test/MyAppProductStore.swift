//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

class MyAppProductStore: Store {
    static let shared = MyAppProductStore()
    
    // purchase processor
    var itunes: iTunesStore = iTunesStore()
    
    init() {
        // register for purchase status update callbacks
        itunes.delegate = self
        
        validateProducts(MyProductIds.allIdentifiers())
    }
    
    /// This function is called during the purchase/restore purchase process with each status change in the flow. If the status is complete then access to the product should be granted at this point.
    ///
    /// - Parameter status: The current status of the transaction.
    internal func processPurchaseStatus(_ status: PurchaseStatus) {
        switch status.state {
        case .initiated:
            // TODO: show alert that purchase is in progress...
            break
        case .complete:
            if let productID = status.transaction?.payment.productIdentifier {
                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        case .cancelled:
            break
        case .failed:
            // TODO: notify user with alert...
            break
        }
    }
}

extension MyAppProductStore: iTunesPurchaseStatusReceiver, iTunesProductStatusReceiver {
    func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // process based on received status
        processPurchaseStatus(status)
    }
    
    func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // pass this into the same flow as purchasing for unlocking products
        processPurchaseStatus(status)
    }
    
    func didValidateProducts(_ products: [SKProduct]) {
        print("Product identifier validation complete with products: \(products)")
        // TODO: if you have a local representation of your products you could
        // sync them up with the itc version here
    }
    
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String]) {
        // TODO: filter out invalid products? maybe... by default isActive is false
    }
}


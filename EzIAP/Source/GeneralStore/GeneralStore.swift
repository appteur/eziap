//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

open class GeneralStore: Store {
    
    // purchase processor (handles communication with the App Store/iTunesConnect)
    public var itunes: iTunesStore = iTunesStore()
    
    // transaction handlers
    public var onTransactionInitiated: ((PurchaseStatus) -> Void)?
    public var onTransactionComplete: ((PurchaseStatus) -> Void)?
    public var onTransactionCancelled: ((PurchaseStatus) -> Void)?
    public var onTransactionFailed: ((PurchaseStatus) -> Void)?
    
    // validation handlers
    public var onProductsValidated: (([SKProduct]) -> Void)?
    public var onReceivedInvalidProducts: (([String]) -> Void)?
    
    public init() {
        
        // register for purchase status update callbacks
        itunes.delegate = self
    }
    
    /// This function is called during BOTH the purchase AND restore user flows for each status change in the transaction flow. If the status is complete then access to the product should be granted at this point.
    ///
    /// - Parameter status: The current status of the transaction.
    internal func processPurchaseStatus(_ status: PurchaseStatus) {
        
        switch status.state {
            
        // This is called when the purchase process starts... show alert etc here...
        case .initiated:
            onTransactionInitiated?(status)
            
        // This is where you unlock functionality based on the purchased product.
        case .complete:
            onTransactionComplete?(status)
            
        // Handle any custom logic when a user taps 'cancel' here if desired
        case .cancelled:
            onTransactionCancelled?(status)
            
        // Show notification with failure/error reason.
        case .failed:
            onTransactionFailed?(status)
        }
    }
}

extension GeneralStore: iTunesPurchaseStatusReceiver, iTunesProductStatusReceiver {
    
    /// This is a delegate function that gets called when a purchase status changes.
    ///
    /// - Parameter status: The current status of the purchase action.
    public func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // process based on received status
        processPurchaseStatus(status)
    }
    
    /// This is a delegate function that gets called when a restore action status changes.
    ///
    /// - Parameter status: The current status of the restore action.
    public func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // pass this into the same flow as purchasing for unlocking products
        processPurchaseStatus(status)
    }
    
    /// This is a delegate function that gets called when product validation is complete. Product validation should be performed when the class is instantiated. You can customize this to filter out products that were not validated if you wish or you can associate the validated SKProduct with your own local model of your own products if desired.
    ///
    /// - Parameter products: An array of validated products available for purchase via in app purchase and the iTunesConnect store.
    public func didValidateProducts(_ products: [SKProduct]) {
        print("Product identifier validation complete with products: \(products)")
        onProductsValidated?(products)
    }
    
    /// This is called during product validation and provides a hook to filter out invalid product identifiers, or identifiers that will error when trying to purchase. This would prevent end users from seeing invalid products, or seeing them but with an 'unavailable' flag if you set it up that way.
    ///
    /// - Parameter identifiers: An array of invalid product identifiers.
    public func didReceiveInvalidProductIdentifiers(_ identifiers: [String]) {
        onReceivedInvalidProducts?(identifiers)
    }
}


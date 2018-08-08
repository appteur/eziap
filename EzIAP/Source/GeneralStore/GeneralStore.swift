//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

/**
 This class provides a default implementation of the `Store` protocol and is designed to bootstrap projects that do not require complex purchasing rules.

 ### Usage
 
 A basic use case could look something like this:
 ```Swift
 
 var store: Store!
 
 init() {
    store = setupStore()
 }

 internal func setupStore() -> GeneralStore {
 
    let store = GeneralStore()
 
    store.onTransactionInitiated = { status in
        self.showSpinner(true)
    }
 
    store.onTransactionComplete = { status in
        self.showSpinner(false)
 
        if let productID = status.transaction?.payment.productIdentifier {
 
            // Store product id in UserDefaults or some other method of tracking purchases
            UserDefaults.standard.set(true , forKey: productID)
            UserDefaults.standard.synchronize()
        }
    }
 
    store.onTransactionCancelled = { status in
        self.showSpinner(false)
    }
 
    store.onTransactionFailed = { status in
        self.showSpinner(false)
        if let error = status.error {
            print("Purchase Error: \(error.localizedDescription)")
        }
    }
 
    return store
 }
 
 ```
 */
open class GeneralStore: Store {
    
    /// Instance of iTunesStore for handling communication with the App Store/iTunesConnect
    public var itunes: iTunesStore = iTunesStore()
    
    // MARK: Purchase/Restore status update closures
    /// Closure that is called when a transaction triggers a callback with the .initiated status. (Purchase or restore has just begun).
    public var onTransactionInitiated: ((PurchaseStatus) -> Void)?
    
    /// Closure that is called when a transaction triggers a .complete status. (The transaction completed successfully) Note that access to the purchased product should occur in this closure.
    public var onTransactionComplete: ((PurchaseStatus) -> Void)?
    
    /// Closure that is called when the user manually cancels a transaction.
    public var onTransactionCancelled: ((PurchaseStatus) -> Void)?
    
    /// Closure that is called when a transaction fails for any reason.
    public var onTransactionFailed: ((PurchaseStatus) -> Void)?
    
    // MARK: Validation callback closures
    /// Closure that is called when product validation call to the App Store is completed.
    /// Here you could associate the validated SKProduct with your own local model of your own products if desired. This would be beneficial if you wanted to use product information you had setup in iTunesConnect for the product in your UI.
    public var onProductsValidated: (([SKProduct]) -> Void)?
    
    /// Closure that is called when product validation completes with 1 or more invalid products.
    /// Here you could filter out products that were not validated so that you will not display products to the user that are not available for purchase.
    public var onReceivedInvalidProducts: (([String]) -> Void)?
    
    /// Sets up the class and sets `self` as the delegate of the `itunes` instance to receive validation and purchase/restore callbacks
    public init() {
        
        // register for purchase status update callbacks
        itunes.delegate = self
    }
    
    /// Handles triggering the appropriate closure based on callbacks received from `itunes` during the purchase & restore flows.
    /// Note that this is called during BOTH the purchase AND restore user flows for each status change in the transaction flow. If the status is complete then access to the product should be granted at this point.
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
    
    /// Implementation of `iTunesPurchaseStatusReceiver` delegate function.
    /// This gets called when a purchase status changes.
    ///
    /// - Parameter status: The current status of the purchase action.
    public func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // process based on received status
        processPurchaseStatus(status)
    }
    
    /// Implementation of `iTunesPurchaseStatusReceiver` delegate function.
    /// This gets called when a restore action status changes.
    ///
    /// - Parameter status: The current status of the restore action.
    public func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // pass this into the same flow as purchasing for unlocking products
        processPurchaseStatus(status)
    }
    
    /// Implementation of `iTunesProductStatusReceiver` delegate function.
    /// This gets called when product validation is complete.
    /// Product validation should be called when the class is instantiated after the product list has been loaded.
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


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
    
    // singleton if you want to use it...
    static let shared = MyAppProductStore()
    
    // purchase processor
    var itunes: iTunesStore = iTunesStore()
    
    init() {
        
        // register for purchase status update callbacks
        itunes.delegate = self
        
        // this validates the products with the App Store.
        validateProducts(MyProductIds.allIdentifiers())
    }
    
    /// This function is called during BOTH the purchase AND restore user flows for each status change in the transaction flow. If the status is complete then access to the product should be granted at this point.
    ///
    /// - Parameter status: The current status of the transaction.
    internal func processPurchaseStatus(_ status: PurchaseStatus) {
        switch status.state {
        case .initiated:
            // ---------------------------------------------------------------------
            // This is called when the purchase process starts... show alert etc here...
            // ---------------------------------------------------------------------
            break
        case .complete:
            
            // ---------------------------------------------------------------------
            // This is where you unlock functionality based on the purchased product.
            // ---------------------------------------------------------------------
            if let productID = status.transaction?.payment.productIdentifier {
                
                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        case .cancelled:
            // ---------------------------------------------------------------------
            // Handle any custom logic when a user taps 'cancel' here if desired
            // ---------------------------------------------------------------------
            break
        case .failed:
            // ---------------------------------------------------------------------
            // Show notification here with failure/error reason.
            // ---------------------------------------------------------------------
            
            if let error = status.error {
                print("Purchase Error: \(error.localizedDescription)")
            }
            
            break
        }
    }
}

extension MyAppProductStore: iTunesPurchaseStatusReceiver, iTunesProductStatusReceiver {
    
    /// This is a delegate function that gets called when a purchase status changes.
    ///
    /// - Parameter status: The current status of the purchase action.
    func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // process based on received status
        processPurchaseStatus(status)
    }
    
    /// This is a delegate function that gets called when a restore action status changes.
    ///
    /// - Parameter status: The current status of the restore action.
    func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // pass this into the same flow as purchasing for unlocking products
        processPurchaseStatus(status)
    }
    
    /// This is a delegate function that gets called when product validation is complete. Product validation should be performed when the class is instantiated. You can customize this to filter out products that were not validated if you wish or you can associate the validated SKProduct with your own local model of your own products if desired.
    ///
    /// - Parameter products: An array of validated products available for purchase via in app purchase and the iTunesConnect store.
    func didValidateProducts(_ products: [SKProduct]) {
        print("Product identifier validation complete with products: \(products)")
        // TODO: if you have a local representation of your products you could
        // sync them up with the itc version here
    }
    
    /// This is called during product validation and provides a hook to filter out invalid product identifiers, or identifiers that will error when trying to purchase. This would prevent end users from seeing invalid products, or seeing them but with an 'unavailable' flag if you set it up that way.
    ///
    /// - Parameter identifiers: An array of invalid product identifiers.
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String]) {
        // TODO: filter out invalid products? maybe... by default isActive is false
    }
}


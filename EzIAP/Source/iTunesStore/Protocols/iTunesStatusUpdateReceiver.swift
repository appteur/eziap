//
//  iTunesStatusUpdateReceiver.swift
//  MagicBubbles
//
//  Created by Seth on 8/19/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import StoreKit

/// This protocol defines callbacks that will occur during the product validation process with the iTunes Store.
/// Conforming objects should update their available products list based on the information returned from these callbacks.
public protocol iTunesProductStatusReceiver: class {
    
    /// This is called once validation of a product list has succeeded.
    /// At this point you can associate the returned SKProducts with your local product models if desired.
    /// This would provide access to product information you setup in iTunesConnect for use in your UI.
    ///
    /// - Parameter products: On success this will return an array of SKProduct objects returned from the iTunesConnect store.
    func didValidateProducts(_ products: [SKProduct])
    
    /// Called when a request to validate products returns invalid identifiers.
    /// This could be caused by improper entry of the product id's in your product model or failure to setup your products in iTunesConnect correctly.
    /// In any case, at this point you should remove any invalid products specified from your UI or fix the reason they are unavailable.
    ///
    /// - Parameter identifiers: Returns a list of invalid product identifiers, this is a subset of the original product identifiers requested to be validated.
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String])
}

/// This protocol defines callbacks that occur during the purchase or restore process.
/// Conforming objects should manage the display of messaging alerts to the user to notify of the progress of the transaction, unlock purchases or prompt the user to resolve issues depending on the status.
public protocol iTunesPurchaseStatusReceiver: class {
    
    /// Called when a status changes during the purchase process of a product.
    ///
    /// - Parameter status: The current status for the purchase currently in process.
    func purchaseStatusDidUpdate(_ status: PurchaseStatus)
    
    /// Called when a status changes during the restore process.
    ///
    /// - Parameter status: The current status for the restore in process.
    func restoreStatusDidUpdate(_ status: PurchaseStatus)
}

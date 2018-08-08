//
//  iTunesStatusUpdateReceiver.swift
//  MagicBubbles
//
//  Created by Seth on 8/19/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import StoreKit

/// Defines callbacks that will occur when products are being validated with the iTunes Store.
public protocol iTunesProductStatusReceiver: class {
    
    /// Called once validation of a product list has succeeded. You can associate the returned SKProducts with your local products if desired so you can access and use the information for the product that you setup in iTunesConnect. This would allow for dynamic configuration of price/description/name/etc.
    ///
    /// - Parameter products: On success this will return an array of SKProduct objects returned from the iTunesConnect store.
    func didValidateProducts(_ products: [SKProduct])
    
    /// Called when a request to validate products returns invalid identifiers. This could be caused by improper entry of the product id's in your product model or failure to setup your products in iTunesConnect.
    ///
    /// - Parameter identifiers: Returns a list of invalid product identifiers, this is a subset of the original product identifiers requested to be validated.
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String])
}

/// Defines callbacks that occur during the purchase or restore process
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

//
//  iTunesStatusUpdateReceiver.swift
//  MagicBubbles
//
//  Created by Seth on 8/19/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import StoreKit

/// Defines callbacks that will occur when products are being validated with the iTunes Store.
protocol iTunesProductStatusReceiver: class {
    func didValidateProducts(_ products: [SKProduct])
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String])
}

/// Defines callbacks that occur during the purchase or restore process
protocol iTunesPurchaseStatusReceiver: class {
    func purchaseStatusDidUpdate(_ status: PurchaseStatus)
    func restoreStatusDidUpdate(_ status: PurchaseStatus)
}

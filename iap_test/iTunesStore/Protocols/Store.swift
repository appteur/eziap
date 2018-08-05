//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

protocol Store {
    var itunes: iTunesStore { get set }
    
    func validateProducts(_ identifiers: [ProductIdentifier])
    func purchaseProduct(_ identifier: ProductIdentifier)
    func restorePurchases()
}

extension Store {
    
    /// Default Implementation
    /// Validates products with the iTunesConnect store for faster purchase processing
    /// when a user decides to purchase a product. This should be called in the conforming class init() function.
    func validateProducts(_ identifiers: [ProductIdentifier]) {
        
        // get all identifier values
        let values = identifiers.map({ $0.value })
        
        // validate all product identifiers with the iTunesConnect store
        itunes.fetchStoreProducts(identifiers: Set.init(values))
    }
    
    /// Purchase a product by specifying the product identifier.
    ///
    /// - Parameter identifier: The product identifier for the product being purchased.
    func purchaseProduct(_ identifier: ProductIdentifier) {
        print("Initiating product purchase: \(identifier)")
        itunes.purchaseProduct(identifier: identifier.value)
    }
    
    /// Initiates restore purchases functionality. Call this function when a user taps a 'Restore Purchase' button
    func restorePurchases() {
        itunes.restorePurchases()
    }
}

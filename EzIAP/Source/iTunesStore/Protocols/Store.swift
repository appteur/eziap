//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/// Defines an interface for an apps Store interface.
public protocol Store {
    
    /// A reference to an instance of the iTunesStore, used for processing purchase requests.
    var itunes: iTunesStore { get set }
    
    /// Call to validate a list of products. This should be called as soon as your store is initialized and the list of products loaded. Call before trying to purchase products.
    ///
    /// - Parameter products: A list of products to validate.
    func validateProducts(_ products: [ItcProduct])
    
    /// Call to start the purchase process for the specified product.
    ///
    /// - Parameter product: The product to purchase.
    func purchaseProduct(_ product: ItcProduct)
    func restorePurchases()
}

public extension Store {
    
    /// Default Implementation
    /// Validates products with the iTunesConnect store for faster purchase processing
    /// when a user decides to purchase a product. This should be called in the conforming class init() function.
    public func validateProducts(_ products: [ItcProduct]) {
        
        // get all identifier values
        let values = products.map({ $0.identifier })
        
        // validate all product identifiers with the iTunesConnect store
        itunes.fetchStoreProducts(identifiers: Set.init(values))
    }
    
    /// Purchase a product by specifying the product identifier.
    ///
    /// - Parameter identifier: The product identifier for the product being purchased.
    public func purchaseProduct(_ product: ItcProduct) {
        print("Initiating product purchase: \(product.identifier)")
        itunes.purchaseProduct(identifier: product.identifier)
    }
    
    /// Initiates restore purchases functionality. Call this function when a user taps a 'Restore Purchase' button
    public func restorePurchases() {
        itunes.restorePurchases()
    }
}

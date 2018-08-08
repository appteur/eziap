//
//  Store.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/**
 This protocol defines an interface for an applications store within the app.
 
 An implementation of this protocol could provide product lists and management and encapsulate all store logic for displaying products to the user and handling/initiating calls to purchase products within the app, or this logic could be broken up further based on responsibilities.
 
 See the 'GeneralStore' class in this framework or the 'DemoStore' class in the accompanying sample application for sample use/implementation cases.
 
 */
public protocol Store {
    
    /// A reference to an instance of the iTunesStore class, used for handling and processing purchase requests.
    var itunes: iTunesStore { get set }
    
    /// Call to validate a list of products. (Default implementation provided in extension).
    /// This should be called as soon as your store is initialized and the list of products loaded.
    /// Call before trying to purchase products as product identifiers are validated against the internal list of valid products before sending the request to iTunesConnect.
    ///
    /// - Parameter products: A list of products to validate.
    func validateProducts(_ products: [ItcProduct])
    
    /// Call to start the purchase process for the specified product.
    /// This call will fail if validateProducts() has not been called first.
    ///
    /// - Parameter product: The product to purchase.
    func purchaseProduct(_ product: ItcProduct)
    
    /// Call to restore purchases made previously.
    func restorePurchases()
}

public extension Store {
    
    /// Default Implementation
    /// Validates products with the iTunesConnect store. If this is not called before 'purchaseProduct()' then attempts to purchase products will fail.
    /// - Parameter products: A list of products to validate with the iTunesConnect store.
    public func validateProducts(_ products: [ItcProduct]) {
        
        // get all identifier values
        let values = products.map({ $0.identifier })
        
        // validate all product identifiers with the iTunesConnect store
        itunes.validateProducts(identifiers: Set.init(values))
    }
    
    /// Default Implementation
    /// Initiates purchase of a product with iTunesConnect if the product identifier is valid and 'validateProducts()' was called before calling this function.
    ///
    /// - Parameter identifier: The product identifier for the product being purchased.
    public func purchaseProduct(_ product: ItcProduct) {
        print("Initiating product purchase: \(product.identifier)")
        itunes.purchaseProduct(identifier: product.identifier)
    }
    
    /// Default Implementation
    /// Initiates restore purchases functionality.
    /// Call this function when a user taps a 'Restore Purchase' button.
    public func restorePurchases() {
        itunes.restorePurchases()
    }
}

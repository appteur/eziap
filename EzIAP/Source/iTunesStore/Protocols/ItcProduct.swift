//
//  Product.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

/**
 This protocol defines an interface for a product for the purpose of initiating purchases in the App Store. (iTunesConnect or AppStoreConnect)
 
 This is designed to work alongside objects conforming to the `Store` protocol to simplify initiating product purchases.
 
 In almost all cases local product models will have an 'identifier' property and this protocol is designed so those models can be used and passed to the purchasing logic in this framework with minimal modification.
 
 If your product models already have an 'identifier' property, all you have to do to get them to work with this framework is to add conformance to this protocol.
 
 Assuming you have a product model that looks something like this:
 
 ```Swift
 
 /// Defines local model for products that will be listed and available for sale in the app.
 protocol Product {
    var identifier: String { get set }
    var name: String { get set }
    var price: Double { get set }
    // other properties here
 }
 
 ```
 
 The only thing you have to do to be able to use your product model with this framework is to make your protocol extend ItcProduct like this:
 
 ```Swift
 
 /// Defines local model for products that will be listed and available for sale in the app.
 protocol Product: ItcProduct {
    var name: String { get set }
    var price: Double { get set }
    // other properties here
 }
 
 ```
 
 */
public protocol ItcProduct {
    
    /// The product identifier for this product. The value for this property should match the product identifier you setup in iTunesConnect or AppStoreConnect for this product.
    var identifier: String { get }
}

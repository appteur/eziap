//
//  Product.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

/// Demo representation of products to be listed/sold in the app...
class MyProduct: Product, Codable {
    
    var identifier: String
    var name: String
    var price: Double = 0.0
//    var skProduct: SKProduct?
    
    init(identifier: String, name: String, price: Double) {
        self.identifier = identifier
        self.name = name
        self.price = price
    }
}

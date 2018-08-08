//
//  Product.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import StoreKit

/// Defines an interface for a product for the purpose of initiating purchases in the App Store. (iTunesConnect or AppStoreConnect)
public protocol ItcProduct {
    
    /// The product identifier for this product. The value for this property should match the product identifier you setup in iTunesConnect or AppStoreConnect for this product.
    var identifier: String { get }
}

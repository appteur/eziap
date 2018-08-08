//
//  Product.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import EzIAP
import StoreKit

/// Defines local model for products that will be listed and available for sale in the app.
protocol Product: ItcProduct {
    var name: String { get set }
    var price: Double { get set }
//    var skProduct: SKProduct? { get set }
    
    // add images, description, meta, etc as desired...
}

extension Product {
    
    /// Convenience function to provide a localized price based on the products price.
    ///
    /// - Returns: A string version of the price localized for users location, otherwise a string representation of the price minus the currency symbol.
    func localizedPrice() -> String {
        let formatter = NumberFormatter.init()
        formatter.locale = NSLocale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.alwaysShowsDecimalSeparator = true
        formatter.numberStyle = .currency
        
        let amount = NSNumber.init(value: price)
        guard let formatted = formatter.string(from: amount) else {
            print("Unable to format currency for product: \(name)")
            return "\(price)"
        }
        
        return formatted
    }
}

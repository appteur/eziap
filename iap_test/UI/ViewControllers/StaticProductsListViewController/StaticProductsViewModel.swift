//
//  StaticProductsViewModel.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import EzIAP

class StaticProductsViewModel {
    
    // setup to handle purchase processing
    var store: Store
    
    // this will contain our products when fetched/loaded
    internal var products: [Product] = []
    
    init(store: Store) {
        
        self.store = store
        
        // setup product list on initialization
        setupProducts()
    }
    
    func setupProducts() {
        // setup products list with static list of products, we already know what all products will be so...
        products = [
            MyProduct(identifier: "com.myapp.static.id1", name: "Static Product 1", price: 1.99),
            MyProduct(identifier: "com.myapp.static.id2", name: "Static Product 2", price: 2.99),
            MyProduct(identifier: "com.myapp.static.id3", name: "Static Product 3", price: 3.99),
            MyProduct(identifier: "com.myapp.static.id4", name: "Static Product 4", price: 4.99),
            MyProduct(identifier: "com.myapp.static.id5", name: "Static Product 5", price: 5.99)
        ]
        
        // validate these product identifiers with the app store...
        store.validateProducts(products)
    }
}

extension StaticProductsViewModel: ProductSelectionDelegate {
    
    // On product selection tell the store to purchase the selected product
    func selected(product: Product) {
        store.purchaseProduct(product)
    }
}

// MARK: Data Access Functions for View Controller
extension StaticProductsViewModel {
    
    func productCount() -> Int {
        return products.count
    }
    
    func item(at index: Int) -> Product {
        return products[index]
    }
}

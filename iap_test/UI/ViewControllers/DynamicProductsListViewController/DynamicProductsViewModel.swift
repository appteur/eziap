//
//  DynamicProductProvider.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import EzIAP

/// This class represents a use case where products are fetched from a remote server,
/// or where the product list may vary independent of builds submitted to the App Store.
class DynamicProductsViewModel {
    
    // setup store to handle purchase processing
    var store: Store
    
    // This is a dummy api for demo purposes
    internal var api = RemoteApi()
    
    // this will contain our products when fetched/loaded
    internal var products = [Product]()
    
    // this handler will run when the product list changes, setter should handle view updates/etc
    var onProductListUpdate: (() -> Void)?
    
    init(store: Store) {
        self.store = store
    }
    
    // fetch list of products from remote server
    func fetchProductList() {
        
        // TODO: connect to remote server...
        api.fetchProducts { [weak self] (products, error) in
            guard let products = products, error == nil else {
                return
            }
            
            // assign or append to products array as needed
            self?.products = products
            
            // this validates the products with the App Store.
            self?.store.validateProducts(products)
            
            // run closure to notify of list update
            self?.onProductListUpdate?()
        }
    }
    
    func tappedCell(indexPath: IndexPath) {
        
        // in this case tapping a cell is a purchase request... so trigger a purchase call
        store.purchaseProduct(products[indexPath.row])
    }
}

extension DynamicProductsViewModel {
    
    func sectionCount() -> Int {
        return 1
    }
    
    func rowCount(section: Int) -> Int {
        return products.count
    }
    
    func item(at indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
}

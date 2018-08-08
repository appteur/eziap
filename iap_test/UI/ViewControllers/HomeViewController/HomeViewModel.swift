//
//  HomeViewModel.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import EzIAP

class HomeViewModel {
    
    // setup store to handle purchase processing
    var store: Store!
    
    init() {
        store = setupStore()
    }
    
    internal func setupStore() -> GeneralStore {
        
        let store = GeneralStore()
        
        store.onTransactionInitiated = { status in
            self.showSpinner(true)
        }
        
        store.onTransactionComplete = { status in
            self.showSpinner(false)
            
            if let productID = status.transaction?.payment.productIdentifier {
                
                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        }
        
        store.onTransactionCancelled = { status in
            self.showSpinner(false)
        }
        
        store.onTransactionFailed = { status in
            self.showSpinner(false)
            if let error = status.error {
                print("Purchase Error: \(error.localizedDescription)")
            }
        }
        
        return store
    }
    
    internal func showSpinner(_ flag: Bool) {
        DispatchQueue.main.async {
            // TODO: show/hide spinner on view controller
        }
    }
    
    // handle restore purchases call
    func restorePurchases() {
        store.restorePurchases()
    }
}

// MARK: View Model Vending
extension HomeViewModel {
    
    // vendor for view models needed by the HomeViewController
    func staticViewModel() -> StaticProductsViewModel {
        return StaticProductsViewModel(store: store)
    }
    
    func dynamicViewModel() -> DynamicProductsViewModel {
        return DynamicProductsViewModel(store: store)
    }
}

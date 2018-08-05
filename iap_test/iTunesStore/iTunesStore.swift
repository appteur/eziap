//
//  IAP.swift
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

class iTunesStore: NSObject, SKProductsRequestDelegate {
    
    weak var delegate: (iTunesProductStatusReceiver & iTunesPurchaseStatusReceiver)?
    
    var transactionObserver: IAPObserver = IAPObserver()
    var availableProducts: [SKProduct] = []
    var invalidProductIDs: [String] = []
    
    deinit {
        SKPaymentQueue.default().remove(self.transactionObserver)
    }
    
    override init() {
        super.init()
        transactionObserver.delegate = self
    }
    
    func fetchStoreProducts(identifiers:Set<String>) {
        print("Sending products request to ITC")
        let request:SKProductsRequest = SKProductsRequest.init(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    func purchaseProduct(identifier:String) {
        guard let product = self.product(identifier: identifier) else {
            print("No products found with identifier: \(identifier)")
            
            // fire purchase status: failed notification
            delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: PurchaseError.productNotFound, transaction: nil, message:"An error occured"))
            return
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            print("Unable to make purchases...")
            delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: PurchaseError.unableToPurchase, transaction: nil, message:"An error occured"))
            return
        }
        
        // Fire purchase began notification
        delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .initiated, error: nil, transaction: nil, message:"Processing Purchase"))
        
        let payment = SKPayment.init(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    
    func restorePurchases() {
        // Fire purchase began notification
        delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .initiated, error: nil, transaction: nil, message:"Restoring Purchases"))
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // returns a product for a given identifier if it exists in our available products array
    func product(identifier:String) -> SKProduct? {
        for product in availableProducts {
            if product.productIdentifier == identifier {
                return product
            }
        }
        
        return nil
    }
    
}

// Receives purchase status notifications and forwards them to this classes delegate
extension iTunesStore: iTunesPurchaseStatusReceiver {
    func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        delegate?.purchaseStatusDidUpdate(status)
    }
    
    func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        delegate?.restoreStatusDidUpdate(status)
    }
}

// MARK: SKProductsRequest Delegate Methods
extension iTunesStore {
    @objc(productsRequest:didReceiveResponse:) func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // set new products
        availableProducts = response.products
        
        // set invalid product id's
        invalidProductIDs = response.invalidProductIdentifiers
        if invalidProductIDs.isEmpty == false {
            // call delegate if we received any invalid identifiers
            delegate?.didReceiveInvalidProductIdentifiers(invalidProductIDs)
        }
        print("iTunes Store: Invalid product IDs: \(response.invalidProductIdentifiers)")
        
        // call delegate with available products.
        delegate?.didValidateProducts(availableProducts)
    }
}

//
//  IAP.swift
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

/// This class provides the main interface for communicating with iTunesConnect/AppStoreConnect.
///
/// It provides functionality to:
///   * Validate products, aka verifying the products are setup and available to purchase in the App Store.
///   * Purchase products.
///   * Restore previously purchased products.
///
/// ### Usage Notes
/// An instance of this class can be used standalone in any of your classes if desired for maximum flexibility.
/// However, it is designed to be used from an object conforming to the `Store` protocol. Using it in this way gives you some default behaviors for free and allows simpler integration with your local product models.
///
/// A default implementation of the Store protocol is included in this framework. (See the `GeneralStore` class).
///
/// A class using an instance of iTunesStore should set itself as the delegate.
/// Doing so will allow you to receive callbacks regarding:
///   * The status of product validation requests.
///   * Notification of any invalid products.
///   * The status of current purchase transactions.
///   * The status of current restore requests.
///
/// For example implementations & use cases look at:
///   * GeneralStore class included in this framework.
///   * DemoStore class included in the accompanying sample application.
open class iTunesStore: NSObject, SKProductsRequestDelegate {
    
    /// This delegate will receive status updates during any purchase/restore actions
    open weak var delegate: (iTunesProductStatusReceiver & iTunesPurchaseStatusReceiver)?
    
    /// Transaction observer for transactions in process
    internal var transactionObserver: IAPObserver = IAPObserver()
    
    /// List of available products. Populated during the product validation phase.
    internal var availableProducts: [SKProduct] = []
    
    /// List of invalid product identifiers. Populated during the product validation phase.
    internal var invalidProductIDs: [String] = []
    
    public override init() {
        super.init()
        transactionObserver.delegate = self
    }
    
    /// Provides product validation functionality by verifying the products requested are setup and configured properly in iTunesConnect.
    /// See extension at bottom of file for request callback implementation.
    ///
    /// - Parameter identifiers: A Set of product identifiers to validate with the App Store.
    func validateProducts(identifiers: Set<String>) {
        print("Validating products: \(identifiers)")
        let request:SKProductsRequest = SKProductsRequest.init(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    /// Call to initiate purchase process for specified product identifier. The product identifier is validated against the products received during product validation when the class is setup.
    ///
    /// - Parameter identifier: The identifier of the product to be purchased.
    public func purchaseProduct(identifier:String) {
        
        // validate that the requested product identifier exists in our 'products' array
        guard let product = self.product(identifier: identifier) else {
            print("No products found with identifier: \(identifier)")
            
            // fire purchase status: failed notification
            delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: PurchaseError.productNotFound, transaction: nil, message:"Unable to find product."))
            return
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            print("Unable to make purchases, canMakePayments returned 'false' ...")
            delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .failed, error: PurchaseError.unableToPurchase, transaction: nil, message:"An error occured"))
            return
        }
        
        // Fire purchase began notification
        delegate?.purchaseStatusDidUpdate(PurchaseStatus.init(state: .initiated, error: nil, transaction: nil, message:"Processing Purchase"))
        
        // kick off purchase request
        let payment = SKPayment.init(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// Call to initiate previous purchase restoration.
    public func restorePurchases() {
        
        // Fire purchase began notification
        delegate?.restoreStatusDidUpdate(PurchaseStatus.init(state: .initiated, error: nil, transaction: nil, message:"Restoring Purchases"))
        
        // start restoration process
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // returns a product for a given identifier if it exists in our available products array
    /// Checks the 'products' array on this class for a product with the specified identifier.
    ///
    /// - Parameter identifier: A product identifier, should correspond with products registered in iTunesConnect
    /// - Returns: The product with the specified identifier if it exists, else nil.
    internal func product(identifier: String) -> SKProduct? {
        
        // check available products for the specified product
        for product in availableProducts {
            
            // does the identifier match??
            if product.productIdentifier == identifier {
                return product
            }
        }
        
        return nil
    }
    
}

// Receives purchase status notifications and forwards them to this classes delegate
extension iTunesStore: iTunesPurchaseStatusReceiver {
    
    /// Delegate callback from the observer regarding purchase transaction status.
    ///
    /// - Parameter status: The current status of the purchase transaction.
    public func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        
        // simply pass this notification on to our delegate
        delegate?.purchaseStatusDidUpdate(status)
    }
    
    /// Delegate callback from the observer regarding restore transaction updates.
    ///
    /// - Parameter status: The current status of the restore operation.
    public func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        
        // simply pass this notification on to our delegate
        delegate?.restoreStatusDidUpdate(status)
    }
}

// MARK: SKProductsRequest Delegate Methods
extension iTunesStore {
    
    @objc(productsRequest:didReceiveResponse:) public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        // set received products as our available products
        availableProducts = response.products
        
        // set invalid product identifiers
        invalidProductIDs = response.invalidProductIdentifiers
        
        // notify delegate if any invalid identifiers were received
        if invalidProductIDs.isEmpty == false {
            
            print("iTunes Store: Invalid product IDs: \(invalidProductIDs)")
            
            // call delegate if we received any invalid identifiers
            delegate?.didReceiveInvalidProductIdentifiers(invalidProductIDs)
        }
        
        // call delegate with available products.
        delegate?.didValidateProducts(availableProducts)
    }
}

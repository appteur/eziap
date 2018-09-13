//
//  PurchaseError.swift
//
//  Created by Seth on 8/19/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import Foundation

/**
 This enum encapsulates errors that might be encountered during the purchasing process.
 */
public enum PurchaseError: Error {
    
    /// The requested product was not found when trying to initiate a purchase or restore purchases.
    case productNotFound
    
    /// A generic purchase error occured during the purchase process
    case unableToPurchase
    
    /// An error code to associate with the error.
    public var code: Int {
        switch self {
        case .productNotFound:
            return 100101
        case .unableToPurchase:
            return 100101
            
        }
    }
    
    /// A user friendly error description.
    public var description: String {
        switch self {
        case .productNotFound:
            return "No products found with the requested product identifier."
        case .unableToPurchase:
            return "Unable to make purchases."
        }
    }
    
    /// A user friendly title for the error.
    public var title: String {
        switch self {
        case .productNotFound:
            return "Product Not Found"
        case .unableToPurchase:
            return "Unable to Purchase"
        }
    }
    
    /// The error domain.
    public var domain: String {
        return "com.aii.purchaseError"
    }
    
    /// A recovery suggestion for the error.
    public var recoverySuggestion: String {
        switch self {
        case .productNotFound:
            return "Please try again later."
        case .unableToPurchase:
            return "Check to make sure you are signed into a valid itunes account and that you are allowed to make purchases."
        }
    }
}

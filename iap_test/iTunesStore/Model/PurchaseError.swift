//
//  PurchaseError.swift
//
//  Created by Seth on 8/19/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import Foundation

public enum PurchaseError: Error {
    case productNotFound
    case unableToPurchase
    
    public var code: Int {
        switch self {
        case .productNotFound:
            return 100101
        case .unableToPurchase:
            return 100101
            
        }
    }
    
    public var description: String {
        switch self {
        case .productNotFound:
            return "No products found for the requested product ID."
        case .unableToPurchase:
            return "Unable to make purchases. Check to make sure you are signed into a valid itunes account and that you are allowed to make purchases."
        }
    }
    
    public var title: String {
        switch self {
        case .productNotFound:
            return "Product Not Found"
        case .unableToPurchase:
            return "Unable to Purchase"
        }
    }
    
    public var domain: String {
        return "com.aii.purchaseError"
    }
    
    public var recoverySuggestion: String {
        switch self {
        case .productNotFound:
            return "Try again later."
        case .unableToPurchase:
            return "Check to make sure you are signed into a valid itunes account and that you are allowed to make purchases."
        }
    }
}

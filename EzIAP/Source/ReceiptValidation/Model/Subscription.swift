//
//  EZIAPLatestReceiptInfo.swift
//  EzIAP
//
//  Created by Seth on 9/10/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class Subscription: Codable {
    public var quantity: String?
    public var productId: String?
    public var transactionId: String?
    public var originalTransactionId: String?
    public var purchaseDate: Date?
    public var purchaseDateMs: String?
    public var purchaseDatePst: Date?
    public var originalPurchaseDate: Date?
    public var originalPurchaseDateMs: String?
    public var originalPurchaseDatePst: Date?
    public var expiresDate: Date?
    public var expiresDateMs: String?
    public var expiresDatePst: Date?
    public var cancellationDate: Date?
    public var cancellationReason: String?
    public var webOrderLineItemId: String?
    public var isTrialPeriod: String?
    public var isInIntroOfferPeriod: String?
    
    public var isActive: Bool {
        guard let purchased = purchaseDate, let expires = expiresDate else {
            return false
        }
        return (purchased...expires).contains(Date())
    }
    
    enum CodingKeys: String, CodingKey {
        case quantity = "quantity"
        case productId = "product_id"
        case transactionId = "transaction_id"
        case originalTransactionId = "original_transaction_id"
        case purchaseDate = "purchase_date"
        case purchaseDateMs = "purchase_date_ms"
        case purchaseDatePst = "purchase_date_pst"
        case originalPurchaseDate = "original_purchase_date"
        case originalPurchaseDateMs = "original_purchase_date_ms"
        case originalPurchaseDatePst = "original_purchase_date_pst"
        case expiresDate = "expires_date"
        case expiresDateMs = "expires_date_ms"
        case expiresDatePst = "expires_date_pst"
        case cancellationDate = "cancellation_date"
        case cancellationReason = "cancellation_reason"
        case webOrderLineItemId = "web_order_line_item_id"
        case isTrialPeriod = "is_trial_period"
        case isInIntroOfferPeriod = "is_in_intro_offer_period"
    }
}

/**
 
 ----------------------------------------
 cancellation_reason possible values:
    “1” - Customer canceled their transaction due to an actual or perceived issue within your app.
 
    “0” - Transaction was canceled for another reason, for example, if the customer made the purchase accidentally.
 
    Use this value along with the cancellation date to identify possible issues in your app that may lead customers to contact Apple customer support.
 
 */

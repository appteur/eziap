//
//  ItcReceipt.swift
//  EzIAP
//
//  Created by Seth on 9/10/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class EZIAPReceiptValidationResponse: Codable {
    var status: Int16?
    var receipt: EZIAPReceipt?
    var latestReceipt: EZIAPLatestReceiptInfo?
    
    enum CodingKeys: String, CodingKey {
        case status
        case receipt
        case latestReceipt = "latest_receipt_info"
    }
}

public class EZIAPLatestReceiptInfo: Codable {
    var quantity: String?
    var productId: String?
    var transactionId: String?
    var originalTransactionId: String?
    var purchaseDate: Date?
    var purchaseDateMs: String?
    var purchaseDatePst: Date?
    var originalPurchaseDate: Date?
    var originalPurchaseDateMs: String?
    var originalPurchaseDatePst: Date?
    var expiresDate: Date?
    var expiresDateMs: String?
    var expiresDatePst: Date?
    var webOrderLineItemId: String?
    var isTrialPeriod: Bool?
    
    enum CodingKeys: String, CodingKey {
        case quantity
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
        case webOrderLineItemId = "web_order_line_item_id"
        case isTrialPeriod = "is_trial_period"
    }
}

public class EZIAPReceipt: Codable {
    var bundleId: String?
    var appVersion: String?
    var inApp: [EZIAPLatestReceiptInfo]?
    var originalAppVersion: String?
    var expirationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case appVersion = "application_version"
        case inApp = "in_app"
        case originalAppVersion = "original_application_version"
        case expirationDate = "expiration_date"
    }
}

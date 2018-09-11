//
//  EZIAPReceipt.swift
//  EzIAP
//
//  Created by Seth on 9/10/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class EZIAPReceipt: Codable {
    var bundleId: String?
    var appVersion: String?
    var inApp: [EZIAPLatestReceiptInfo]?
    
    var originalAppVersion: String?
    var originalPurchaseDate: Date?
    var receiptCreationDate: Date?
    var receiptType: String? // ProductionSandbox...
    var requestDate: String?
    var expirationDate: Date?
    var downloadId: Int?
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case appVersion = "application_version"
        case inApp = "in_app"
        case originalAppVersion = "original_application_version"
        case originalPurchaseDate = "original_purchase_date"
        case receiptCreationDate = "receipt_creation_date"
        case receiptType = "receipt_type"
        case requestDate = "request_date"
        case expirationDate = "expiration_date"
        case downloadId = "download_id"
    }
}

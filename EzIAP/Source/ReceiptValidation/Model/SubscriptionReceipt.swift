//
//  EZIAPReceipt.swift
//  EzIAP
//
//  Created by Seth on 9/10/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class SubscriptionReceipt: Codable {
    
    public var bundleId: String?
    public var appVersion: String?
    public var inApp: [Subscription]?
    
    public var originalAppVersion: String?
    public var originalPurchaseDate: Date?
    public var receiptCreationDate: Date?
    public var receiptType: String? // ProductionSandbox...
    public var requestDate: String?
    public var downloadId: Int?
    
    // returns the most recent subscription
    public var currentSubscription: Subscription? {
        
        guard let subs = inApp else {
            return nil
        }
        
        let active = subs.filter { $0.isActive }
        let sorted = active.sorted {
            guard let one = $0.purchaseDate, let two = $1.purchaseDate else {
                return false
            }
            
            return one > two
        }
        return sorted.first
    }
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case appVersion = "application_version"
        case inApp = "in_app"
        case originalAppVersion = "original_application_version"
        case originalPurchaseDate = "original_purchase_date"
        case receiptCreationDate = "receipt_creation_date"
        case receiptType = "receipt_type"
        case requestDate = "request_date"
        case downloadId = "download_id"
    }
}

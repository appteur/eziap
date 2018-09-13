//
//  ItcReceipt.swift
//  EzIAP
//
//  Created by Seth on 9/10/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class ReceiptValidationResponse: Codable {
    public var status: Int16?
    public var environment: String?
    public var receipt: SubscriptionReceipt?
    public var latestReceipt: String?
    public var latestReceiptInfo: [Subscription]?
    public var pendingRenewalInfo: [PendingRenewalInfo]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case environment = "environment"
        case receipt = "receipt"
        case latestReceipt = "latest_receipt"
        case latestReceiptInfo = "latest_receipt_info"
        case pendingRenewalInfo = "pending_renewal_info"
    }
}

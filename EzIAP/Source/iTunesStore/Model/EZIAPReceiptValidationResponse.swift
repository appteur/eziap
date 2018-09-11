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
    var latestReceipt: String?
    var latestReceiptInfo: [EZIAPLatestReceiptInfo]?
//    var pendingRenewalInfo
    
    enum CodingKeys: String, CodingKey {
        case status
        case receipt
        case latestReceiptInfo = "latest_receipt_info"
    }
}

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

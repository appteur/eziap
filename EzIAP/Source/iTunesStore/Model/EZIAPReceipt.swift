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
    var expirationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case appVersion = "application_version"
        case inApp = "in_app"
        case originalAppVersion = "original_application_version"
        case expirationDate = "expiration_date"
    }
}

//
//  ProductIdentifier.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/// A conforming object will provide the product identifier as the 'value'.
protocol ProductIdentifier {
    var value: String { get }
}

//
//  ProductSelectionDelegate.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

/// Defines an interface for an object providing handling when a product is selected.
protocol ProductSelectionDelegate: class {
    func selected(product: Product)
}

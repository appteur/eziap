//
//  MyProductIdentifiers.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

// An enumeration of all product ids used in the app.
// This approach can be used if you know all the identifiers you'll be using in the
// app at build time. This approach should not be used in instances where you will
// be fetching product id's from a server or loading them dynamically.
enum MyProductIds: ProductIdentifier {
    case one
    case two
    case three
    case all
    
    var value: String {
        switch self {
        case .one: return "com.myprefix.id1"
        case .two: return "com.myprefix.id2"
        case .three: return "com.myprefix.id3"
        case .all: return "com.myprefix.all"
        }
    }
    
    static func allIdentifiers() -> [ProductIdentifier] {
        return [
            MyProductIds.one,
            MyProductIds.two,
            MyProductIds.three,
            MyProductIds.all
        ]
    }
    
    static func from(rawValue: String) -> ProductIdentifier? {
        switch rawValue {
        case one.value: return MyProductIds.one
        case two.value: return MyProductIds.two
        case three.value: return MyProductIds.three
        default: return nil
        }
    }
}

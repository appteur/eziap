//
//  PurchaseStatus.swift
//  sketch2
//
//  Created by Seth on 8/29/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import StoreKit

enum PurchaseState {
    case initiated
    case complete
    case cancelled
    case failed
}


class PurchaseStatus {
    var state:PurchaseState
    var error:Error?
    var transaction:SKPaymentTransaction?
    var message:String
    
    init(state:PurchaseState, error:Error?, transaction:SKPaymentTransaction?, message:String) {
        self.state = state
        self.error = error
        self.transaction = transaction
        self.message = message
    }
}

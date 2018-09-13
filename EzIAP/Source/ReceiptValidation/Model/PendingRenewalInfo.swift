//
//  EZIAPPendingRenewalInfo.swift
//  EzIAP
//
//  Created by Seth on 9/12/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class PendingRenewalInfo: Codable {
    public var expirationIntent: String?
    public var originalTransactionId: String?
    public var isInBillingRetryPeriod: String?
    
    // This key is only present for auto-renewable subscription receipts. The value for this key corresponds to the productIdentifier property of the product that the customer’s subscription renews. You can use this value to present an alternative service level to the customer before the current subscription period ends.
    public var autoRenewProductId: String?
    public var productId: String?
    public var autoRenewStatus: String?
    public var priceConsentStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case expirationIntent = "expiration_intent"
        case originalTransactionId = "original_transaction_id"
        case isInBillingRetryPeriod = "is_in_billing_retry_period"
        case autoRenewProductId = "auto_renew_product_id"
        case productId = "product_id"
        case autoRenewStatus = "auto_renew_status"
        case priceConsentStatus = "price_consent_status"
    }
}

/**
 
 ------------------------------------------
 expirationIntent possible values:
 
    “1” - Customer canceled their subscription.
    “2” - Billing error; for example customer’s payment information was no longer valid.
    “3” - Customer did not agree to a recent price increase.
    “4” - Product was not available for purchase at the time of renewal.
    “5” - Unknown error.
 
    This key is only present for a receipt containing an expired auto-renewable subscription. You can use this value to decide whether to display appropriate messaging in your app for customers to resubscribe.
 
 --------------------------------------------
 autoRenewStatus possible values
 
    “1” - Subscription will renew at the end of the current subscription period.
 
    “0” - Customer has turned off automatic renewal for their subscription.
 
    This key is only present for auto-renewable subscription receipts, for active or expired subscriptions. The value for this key should not be interpreted as the customer’s subscription status. You can use this value to display an alternative subscription product in your app, for example, a lower level subscription plan that the customer can downgrade to from their current plan.
 
---------------------------------------------
price_consent_status possible values
 
    “1” - Customer has agreed to the price increase. Subscription will renew at the higher price.
 
    “0” - Customer has not taken action regarding the increased price. Subscription expires if the customer takes no action before the renewal date.
 
    This key is only present for auto-renewable subscription receipts if the subscription price was increased without keeping the existing price for active subscribers. You can use this value to track customer adoption of the new price and take appropriate action.
 
 */

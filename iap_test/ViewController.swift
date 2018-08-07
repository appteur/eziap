//
//  ViewController.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Product Id's are validated on initialization
    var store = MyAppProductStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func actionBuyOne(_ sender: Any) {
        print("Action buy one tapped")
        store.purchaseProduct(MyProductIds.one)
    }
    
    @IBAction func actionBuyTwo(_ sender: Any) {
        print("Action buy two tapped")
        store.purchaseProduct(MyProductIds.two)
    }
    
    @IBAction func actionBuyThree(_ sender: Any) {
        print("Action buy three tapped")
        store.purchaseProduct(MyProductIds.three)
    }
    
    @IBAction func actionBuyAll(_ sender: Any) {
        print("Action buy all tapped")
        store.purchaseProduct(MyProductIds.all)
    }

    @IBAction func actionRestorePurchases(_ sender: Any) {
        print("Restore purchases tapped...")
        store.restorePurchases()
    }
}

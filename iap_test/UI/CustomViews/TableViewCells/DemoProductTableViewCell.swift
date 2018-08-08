//
//  DemoProductTableViewCell.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

// A demo product display cell. Simply displays a placeholder image and the product name/price.
class DemoProductTableViewCell: UITableViewCell, ProductConfigurableView {

    var product: Product?
    
    // product image view if you want to use it
    @IBOutlet weak var heroImage: UIImageView!
    
    // the main title label for the product, currently used to display product name
    @IBOutlet weak var titleLabel: UILabel!
    
    // the subtitle label for the product, could display product description if configured, currently displays price.
    @IBOutlet weak var subtitleLabel: UILabel!
    
}

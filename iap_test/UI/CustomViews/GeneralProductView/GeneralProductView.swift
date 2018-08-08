//
//  GeneralProductView.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

// A generic view for displaying a product.
class GeneralProductView: UIView, ProductConfigurableView {

    var product: Product?
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: ProductSelectionDelegate?
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let product = product else {
            print("Unable to select product... product is nil...")
            return
        }
        
        delegate?.selected(product: product)
    }
}

//
//  ProductConfigurableView.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

/// Defines an interface for a view that can be configured with a product
protocol ProductConfigurableView: class {
    
    var heroImage: UIImageView! { get }
    var titleLabel: UILabel! { get }
    var subtitleLabel: UILabel! { get }
    var product: Product? { get set }
    
    func configure(with product: Product)
}

extension ProductConfigurableView {
    
    /// Provides default configuration behavior for a view based on a received product.
    ///
    /// - Parameter product: The product to use to configure this cell.
    func configure(with product: Product) {
        
        self.product = product
        
        // set the image... eventually...
        // heroImage.image = product.image or something here
        
        // set the title label with the products name
        titleLabel.text = product.name
        
        // set the subtitle with the products price.
        subtitleLabel.text = "\(product.price)"
    }
}

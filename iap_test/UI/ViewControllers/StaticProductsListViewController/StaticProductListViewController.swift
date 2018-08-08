//
//  StaticProductListViewController.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

// Demo ViewController for displaying a list of static/unchanging products within the app
class StaticProductListViewController: UIViewController {

    var viewModel: StaticProductsViewModel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
    }
    
    internal func loadProducts() {
        
        // empty any views from stackView
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        // setup product views in stackView
        for index in 0..<viewModel.productCount() {
            let product = viewModel.item(at: index)
            
            guard let view = GeneralProductView.fromNib() as? GeneralProductView else {
                continue
            }
            
            // setup view with product
            view.configure(with: product)
            
            // set delegate to handle product selection
            view.delegate = viewModel
            
            // customize buy button title... why not?
            view.actionButton.setTitle("Buy Now - \(product.localizedPrice())", for: .normal)
            
            // add to view
            stackView.addArrangedSubview(view)
        }
    }

}

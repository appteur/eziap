//
//  ViewController.swift
//  iap_test
//
//  Created by Seth on 8/4/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

// This is the main app interface when launching the test/sample app.
class HomeViewController: UIViewController {
    
    // Creates it's own view model instance on initialization
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set nav bar title
        title = "Home"
    }

    // action for restoring purchases when tapped on home screen
    @IBAction func actionRestorePurchases(_ sender: Any) {
        print("Restore purchases tapped...")
        
        // pass off responsibility to view model to handle purchase restore
        viewModel.restorePurchases()
    }
    
    // creates and presents the dynamic product list view. This generates the product list via a dummy remote api that parses the products from a json file.
    @IBAction func showDynamicProductsList(_ sender: Any) {
        print("Showing dynamic products list...")
        
        // load view controller for dynamic product list display
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: AppDelegate.self))
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DynamicProductListVC") as? ProductListTableViewController else {
            print("Unable to instantiate ProductListTableViewController for dynamic product list demo... bailing...")
            return
        }
        
        // set the view model
        vc.viewModel = viewModel.dynamicViewModel()
        
        // push controller on the navigation stack
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showStaticProductList(_ sender: Any) {
        print("Showing static products list...")
        
        // load view controller for static product list display
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: AppDelegate.self))
        guard let vc = storyboard.instantiateViewController(withIdentifier: "StaticProductListVC") as? StaticProductListViewController else {
            print("Unable to instantiate StaticProductsListViewController... bailing")
            return
        }
        
        // set the view model on the controller
        vc.viewModel = viewModel.staticViewModel()
        
        // push controller on the navigation stack
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  ProductListTableViewController.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

// A Demo TableViewController to display a variable list of products available for purchase.
class ProductListTableViewController: UITableViewController {

    // the cell identifier we'll be using for the single cell for this demo
    let cellID = "ProductListCell"
    
    // this will provide the dynamic list of products and handle actions relating to the product list
    var viewModel: DynamicProductsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title to display in nav bar
        title = "Dynamic Product List"
        
        // configure the table view
        setupTableView()
        
        // setup the view model, this will kick off the product list fetch
        setupViewModel()
    }

    internal func setupViewModel() {
        
        // set the handler to be called when the product list changes
        viewModel.onProductListUpdate = {
            
            // update the UI on the main thread
            DispatchQueue.main.async {
                
                // reload the tableView data to use the new items
                self.tableView.reloadData()
            }
        }
        
        // kick off the product fetch
        viewModel.fetchProductList()
    }
    
    /// Provides configuration for the table view
    internal func setupTableView() {
        
        // register the nib/view we'll be using for this demo
        tableView.register(UINib(nibName: "DemoProductTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellID)
        
        // set values so the table view will update cell height dynamically
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50.0
        tableView.estimatedSectionFooterHeight = 50.0
    }
    
    // MARK: - Table view data source

    /// TableView delegate function. Provide the number of sections we'll be using for this list.
    ///
    /// - Parameter tableView: The tableView.
    /// - Returns: The number of sections for this list.
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // fetch and return from the view model
        return viewModel.sectionCount()
    }
    
    /// The number of rows to display for the requested section/indexPath.
    ///
    /// - Parameters:
    ///   - tableView: The tableView.
    ///   - section: The section we're requesting the number of rows for.
    /// - Returns: The total count of cells that will be displayed for the requested section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // fetch and return from the view model
        return viewModel.rowCount(section: section)
    }
    
    /// The cell to display for the requested indexPath.
    ///
    /// - Parameters:
    ///   - tableView: The tableView.
    ///   - indexPath: The index path where the cell will appear.
    /// - Returns: A reusable cell, configured with the product corresponding to this cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get a reusable cell from the tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        // if the cell is the type we expect (conforms to ProductConfigurableView) then configure it with the appropriate product
        if let cell = cell as? ProductConfigurableView {
            
            // pass the product at this index path to the cell for configuration
            cell.configure(with: viewModel.item(at: indexPath))
        }

        return cell
    }
    
    /// Provides an empty view for the footer. Eliminates trailing lines after the last cell in the view.
    ///
    /// - Parameters:
    ///   - tableView: The tableView.
    ///   - section: The section for this footer view.
    /// - Returns: An empty view, as we're not currently needing a footer, we just want to get rid of the trailing cells.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /// Initiates product purchase for the tapped cell. This could be updated to display a product detail page, and the detail page initiate the purchase if desired.
    ///
    /// - Parameters:
    ///   - tableView: The tableView.
    ///   - indexPath: The index path for the tapped cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect the tapped cell for now
        tableView.deselectRow(at: indexPath, animated: true)
        
        // trigger purchase logic... this is all handled in the view model
        viewModel.tappedCell(indexPath: indexPath)
    }
}

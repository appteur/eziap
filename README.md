# EzIAP - An in app purchase framework for iOS

A framework to simplify in app purchase integration for iOS projects. Written in Swift 4.

### Updated for use with cocoapods.

## Overview

This framework simplifies the process of setting up and handling in app purchase in your iOS Swift app and can be used with cocoapods. 

```
	pod 'EzIAP'
```

The project includes a sample application that demonstrates how to use the framework in your app. You can run it via the 'iap_test' scheme in the project.

The project works with static products (products hard coded into your app that you don't plan to change), as well as dynamic products (products loaded from your remote api or json files). There are examples how to use both within the sample application. See the 'Usage' section below for examples.

Note that the test app will validate the product identifiers but the product identifiers are simply placeholders so validation will fail when you run the project. You will need to update or use in your own project before validation and purchase/restore testing succeeds.

There are three ways to test with your own product identifiers.
1. Change the bundle id of the test project to your own bundle id and update the sample with your own product identifiers to use this project as a test bed.
2. Copy the files into your own project and update the product identifiers to test.
3. Setup the framework in your own project via cocoapods.

## Requirements

- iOS 10.0+
- Xcode 9
- Swift 4

## Usage

There are two ways to make use of this framework in your projects. 

### Cocoapods

The first and easiest is with cocoapods. First make sure you have cocoapods installed, then open terminal and cd into your project root directory.

Then run

``` 
	pod init
```

This should generate a Podfile in your project root directory. Open the file and add a dependency for 'EzIAP'. Your podfile should look something like this:

```

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

# Example target
target 'MY_APP_TARGET_NAME_HERE' do
  	use_frameworks!

    pod 'EzIAP'

end

```

Once your podfile is setup run `pod install` in terminal. When it finishes close any open Xcode projects you have and open your project using the newly generated xcworkspace.

### Manual

If you want to use the source files manually you can copy the `iTunesStore` directory out of the 'EzIAP/Source/' directory and place the entire directory in your project.

-- Setup is the same from this point on for both cocoapods or manual. --

Once you have your dependency setup via cocoapods or manually, you'll need to setup an instance of the `GeneralStore` class (or write your own custom version that implements the 'Store' protocol, see the `DemoStore` class as a sample if you want to go this route). 

You can setup your ViewModel to use the store like this (this is part of the HomeViewModel):

```Swift

import EzIAP
    
	// setup store to handle purchase processing
    var store: Store!
    
    init() {
        store = setupStore()
    }

    internal func setupStore() -> GeneralStore {
        
        let store = GeneralStore()
        
        store.onTransactionInitiated = { status in
            self.showSpinner(true)
        }
        
        store.onTransactionComplete = { status in
            self.showSpinner(false)
            
            if let productID = status.transaction?.payment.productIdentifier {
                
                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        }
        
        store.onTransactionCancelled = { status in
            self.showSpinner(false)
        }
        
        store.onTransactionFailed = { status in
            self.showSpinner(false)
            if let error = status.error {
                print("Purchase Error: \(error.localizedDescription)")
            }
        }
        
        return store
    }


```

The simplest implementation of use is in the StaticProductsViewModel class in the sample app. It takes a `Store` object on initialization. The `HomeViewModel` creates the instance of the `GeneralStore` and passes it to all view models that it creates. Since HomeViewModel is the base view model in the app all other viewModels use the same Store.

HomeViewModel vends models for sub-controllers like this:

```Swift

// MARK: View Model Vending
extension HomeViewModel {
    
    func staticViewModel() -> StaticProductsViewModel {
        return StaticProductsViewModel(store: store)
    }
    
    func dynamicViewModel() -> DynamicProductsViewModel {
        return DynamicProductsViewModel(store: store)
    }
}


```

Here's the complete implementation:

```Swift

import Foundation
import EzIAP

class StaticProductsViewModel {
    
    // setup to handle purchase processing
    var store: Store
    
    // this will contain our static list of products
    internal var products: [Product] = []
    
    init(store: Store) {
        
        self.store = store
        
        // setup product list on initialization
        setupProducts()
    }
    
    func setupProducts() {

        // setup products list with static list of products 
        // we already know what all products will be so...
        products = [
            MyProduct(identifier: "com.myapp.static.id1", name: "Static Product 1", price: 1.99),
            MyProduct(identifier: "com.myapp.static.id2", name: "Static Product 2", price: 2.99),
            MyProduct(identifier: "com.myapp.static.id3", name: "Static Product 3", price: 3.99),
            MyProduct(identifier: "com.myapp.static.id4", name: "Static Product 4", price: 4.99),
            MyProduct(identifier: "com.myapp.static.id5", name: "Static Product 5", price: 5.99)
        ]
        
        // validate these product identifiers with the app store...
        store.validateProducts(products)
    }
}

extension StaticProductsViewModel: ProductSelectionDelegate {
    
    // On product selection tell the store to purchase the selected product
    func selected(product: Product) {
        store.purchaseProduct(product)
    }
}

// MARK: Data Access Functions for View Controller
extension StaticProductsViewModel {
    
    func productCount() -> Int {
        return products.count
    }
    
    func item(at index: Int) -> Product {
        return products[index]
    }
}


```

For a more complex example you can look at the `DynamicProductsViewModel` class in the sample project. 

It makes use of a dummy API class to 'fetch' a list of products. For the demo it loads a list of products from a json file and returns the model objects.

Here's the implementation of `DynamicProductsViewModel`:

```Swift

import Foundation
import EzIAP

/// This class represents a use case where products are fetched from a remote server,
/// or where the product list may vary independent of builds submitted to the App Store.
class DynamicProductsViewModel {
    
    // setup store to handle purchase processing
    var store: Store
    
    // This is a dummy api for demo purposes
    internal var api = RemoteApi()
    
    // this will contain our products when fetched/loaded
    internal var products = [Product]()
    
    // this handler will run when the product list changes, setter should handle view updates/etc
    var onProductListUpdate: (() -> Void)?
    
    init(store: Store) {
        self.store = store
    }
    
    // fetch list of products from remote server
    func fetchProductList() {
        
        // TODO: connect to remote server...
        api.fetchProducts { [weak self] (products, error) in
            guard let products = products, error == nil else {
                return
            }
            
            // assign or append to products array as needed
            self?.products = products
            
            // this validates the products with the App Store.
            self?.store.validateProducts(products)
            
            // run closure to notify of list update
            self?.onProductListUpdate?()
        }
    }
    
    func tappedCell(indexPath: IndexPath) {
        
        // in this case tapping a cell is a purchase request... so trigger a purchase call
        store.purchaseProduct(products[indexPath.row])
    }
}

// MARK: data access functions for the view controller
extension DynamicProductsViewModel {
    
    func sectionCount() -> Int {
        return 1
    }
    
    func rowCount(section: Int) -> Int {
        return products.count
    }
    
    func item(at indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
}


```
## EzIAP - an in app purchase framework for iOS

In app purchase handling for iOS projects. Written in Swift 4.

## Overview

This framework simplifies the process of setting up and handling in app purchase flows within iOS applications.

The included sample project demonstrates how to use the framework in your app. You can run it via the 'iap_test' scheme in the project.

The framework can be used with:
  * Static product lists - products hard coded into your app
  * Dynamic product lists - products loaded from remote apis
  
There are examples how to use both within the sample application. See the 'Usage' section below for examples.

Note: the test app calls the product validation logic but the product identifiers are simply placeholders so validation will fail when you run the project. You will need to use the sample code with valid product identifiers in order for validation and purchase/restore testing to succeed.

## Requirements

- iOS 10.0+
- Xcode 9
- Swift 4

## Setup

There are two ways to make use of this framework in your projects. 
1. Cocoapods
2. Manual Installation

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

### Manual Installation

If you want to use the source files manually you can copy the `Source` directory out of the 'EzIAP/' directory and place the entire directory in your project.

## Usage

Once you have your dependencies setup there are a couple ways you can use this framework in your project.

1. You can create an instance of the `iTunesStore` class in any of your own classes and call the validate, purchase or restore functions directly. (Be sure to register a delegate to receive callbacks if you want to use this route.) See Example 1 below.
2. You can setup an instance of the `GeneralStore` class and provide closures to run when transactions trigger status changes. See Example 2 below.
3. You can write your own custom object that implements the 'Store' protocol to handle custom behaviors you might need. (See the `DemoStore` class in the sample application as a basic reference if you want to go this route). See Example 3 below.

The sample project includes different sample implementations and can be referred to for more in depth reference. 

The sample app makes use of the MVVM pattern and view controller implementations make use of custom view models to handle view related business tasks and implement examples found here. 

You can use this same pattern or put your implementations in whichever classes are appropriate for you.

### **Example 1 - iTunesStore standalone implementation**

If you opt to go this route you simply need an instance of the `iTunesStore` class in your view model or view controller. This example is implemented directly in a view controller

```Swift

import EzIAP

class MyStoreViewController {

    var store = iTunesStore()
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // configure the store
        configureStore()
        
        // load product list
        setupProducts(completion: {
        
            // Now that the products are loaded we need to verify them with the store...
            // The product identifiers should match the identifiers you setup in iTunesConnect for validation to pass
        
            // get all identifier values from the products
            let values = self.products.map({ $0.identifier })
        
            // validate products, passing in the product identifiers as a Set
            self.store.validateProducts(identifiers: Set.init(values))
        })
    }
    
    func setupProducts(completion: () -> Void) {
        // fetch products here and call completion when products are loaded...
        completion()
    }
    
    func configureStore() {
    
        // set delegate for callbacks
        store.delegate = self
    }
    
    @IBAction func restorePurchasesTapped(_ sender: Any) {
        store.restorePurchases()
    }
    
    @IBAction func buyProductTapped(_ sender: Any) {
    
        // get product index here based on your implementation
        let index = ...
        
        // get the product
        let product = products[index]
        
        // pass identifier to store to initiate purchase
        store.purchaseProduct(identifier: product.identifier)
    }
}

// Delegate implementations.
// See `DemoStore` or `GeneralStore` classes for possible implementations.
extension MyStoreViewController: iTunesPurchaseStatusReceiver, iTunesProductStatusReceiver {

    public func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // handle product based on received status
    }

    public func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // handle product based on received status
    }

    public func didValidateProducts(_ products: [SKProduct]) {
        // associate SKProduct with local product model if desired, update valid product list
    }

    public func didReceiveInvalidProductIdentifiers(_ identifiers: [String]) {
        // remove invalid products from product list
    }
}


```

### **Example 2 - GeneralStore implementation**

The second example makes use of the the `GeneralStore` class, which is the default implementation of the `Store` protocol included in this framework.

To make use of this you create an instance of `GeneralStore` and set closures with the functionality you want to run during each transaction status change.

This example uses the MVVM pattern by implementing business logic in a view model instead of the view controller. It could also be implemented in a view controller if that fits your design better. 

This sample is included in the sample application and can be found in the `HomeViewModel` class:

```Swift

import EzIAP
    
	// store variable to handle purchase processing
    var store: Store!
    
    init() {
        store = setupStore()
    }

    internal func setupStore() -> GeneralStore {
        
        // create base instance of GeneralStore
        let store = GeneralStore()
        
        // setup logic to run when purchase/restore transactions are initiated
        store.onTransactionInitiated = { status in
            
            // display a spinner or progress indicator
            self.showSpinner(true)
        }
        
        // setup logic to run when purchase/restore transactions complete successfully
        store.onTransactionComplete = { status in
        
            // hide the spinner or progress indicator
            self.showSpinner(false)
            
            // simplest case, just store the product id with a boolean 'true' when a product is unlocked
            if let productID = status.transaction?.payment.productIdentifier {
                
                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        }
        
        // set logic to run when a user cancels during the purchase/restore flow
        store.onTransactionCancelled = { status in
        
            // for now just hide the spinner
            self.showSpinner(false)
        }
        
        // set logic to run when an error occurs during the purchase/restore flow
        store.onTransactionFailed = { status in
        
            // hide spinner
            self.showSpinner(false)
            
            // show alert, print to console, or other custom logic if there's an error set
            if let error = status.error {
                print("Purchase Error: \(error.localizedDescription)")
            }
        }
        
        return store
    }


```

### **Example 3 - Custom `Store`  implementation (`DemoStore` sample)**

If for some reason you need custom logic in your `Store` implementation, you can write your own custom implementation. A demo version is provided in the attached sample application. See the `DemoStore` class.

Here is it's implementation for reference:

```Swift

import EzIAP
import StoreKit

class DemoStore: Store {

    // purchase processor (handles communication with the App Store/iTunesConnect)
    var itunes: iTunesStore = iTunesStore()

    init() {

        // register for purchase status update callbacks
        itunes.delegate = self
    }

    /// This function is called during BOTH the purchase AND restore user flows for each status change in the transaction flow. If the status is complete then access to the product should be granted at this point.
    ///
    /// - Parameter status: The current status of the transaction.
    internal func processPurchaseStatus(_ status: PurchaseStatus) {
        switch status.state {
        case .initiated:
            // ---------------------------------------------------------------------
            // This is called when the purchase process starts... show alert etc here...
            // ---------------------------------------------------------------------
            break
        case .complete:

            // ---------------------------------------------------------------------
            // This is where you unlock functionality based on the purchased product.
            // ---------------------------------------------------------------------
            if let productID = status.transaction?.payment.productIdentifier {

                // Store product id in UserDefaults or some other method of tracking purchases
                UserDefaults.standard.set(true , forKey: productID)
                UserDefaults.standard.synchronize()
            }
        case .cancelled:
            // ---------------------------------------------------------------------
            // Handle any custom logic when a user taps 'cancel' here if desired
            // ---------------------------------------------------------------------
            break
        case .failed:
            // ---------------------------------------------------------------------
            // Show notification here with failure/error reason.
            // ---------------------------------------------------------------------

            if let error = status.error {
                print("Purchase Error: \(error.localizedDescription)")
            }

            break
        }
    }
}

extension DemoStore: iTunesPurchaseStatusReceiver, iTunesProductStatusReceiver {

    /// This is a delegate function that gets called when a purchase status changes.
    ///
    /// - Parameter status: The current status of the purchase action.
    func purchaseStatusDidUpdate(_ status: PurchaseStatus) {
        // process based on received status
        processPurchaseStatus(status)
    }

    /// This is a delegate function that gets called when a restore action status changes.
    ///
    /// - Parameter status: The current status of the restore action.
    func restoreStatusDidUpdate(_ status: PurchaseStatus) {
        // pass this into the same flow as purchasing for unlocking products
        processPurchaseStatus(status)
    }

    /// This is a delegate function that gets called when product validation is complete. Product validation should be performed when the class is instantiated. You can customize this to filter out products that were not validated if you wish or you can associate the validated SKProduct with your own local model of your own products if desired.
    ///
    /// - Parameter products: An array of validated products available for purchase via in app purchase and the iTunesConnect store.
    func didValidateProducts(_ products: [SKProduct]) {
        print("Product identifier validation complete with products: \(products)")
        // TODO: if you have a local representation of your products you could
        // sync them up with the itc version here
    }

    /// This is called during product validation and provides a hook to filter out invalid product identifiers, or identifiers that will error when trying to purchase. This would prevent end users from seeing invalid products, or seeing them but with an 'unavailable' flag if you set it up that way.
    ///
    /// - Parameter identifiers: An array of invalid product identifiers.
    func didReceiveInvalidProductIdentifiers(_ identifiers: [String]) {
        // TODO: filter out invalid products? maybe...
    }
}



```

### **Implementations with static product lists**

The simplest implementation of use is in the `StaticProductsViewModel` class in the sample application. 

The view model takes a `Store` object on initialization. Since these view models are provided by the `HomeViewModel`, it creates the instance of the `GeneralStore` and passes it to all view models that it creates. 

Since HomeViewModel is the base view model in the app all other viewModels use the same instance of `GeneralStore`.

HomeViewModel provides view models for sub-controllers via an extension like this:

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

Following is the complete implementation of the `StaticProductsViewModel`.

Note that it's product list is hard coded and created directly in the view model since all products are known at compile time, and `validateProducts()` is called with the list of products to verify them with the iTunesConnect store before purchasing is attempted.

Another thing to note is that the array of products is passed directly to the `validateProducts()` function. 

This works because the `Product` protocol extends `ItcProduct`, whose sole requirement is that a product must have a `var identifier: String { get set }` property. Also, the default implementation of `validateProducts(_ products: [ItcProduct])` in the `Store` protocol extension grabs the identifiers from the list of products and passes them to the `iTunesStore` instance, which simplifies working with local product models in your app.

Here is the implementation of the `StaticProductsViewModel`:

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

### **Implementations with dynamic product lists**

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

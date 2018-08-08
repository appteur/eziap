//
//  RemoteApi_Dummy.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

class RemoteApi {
    
    func fetchProducts(completion: ([Product]?, Error?) -> Void) {
        // TODO: connect to your remote api here and fetch your product list
        
        // call completion with dummy list for now... nil error
        completion(dummyProductList(), nil)
    }
    
    /// Provides a dummy/stubbed list of products to simulate a remote api.
    ///
    /// - Returns:
    internal func dummyProductList() -> [Product] {
        
        // get the path for our sample product json file
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else {
            print("Unable to find products.json file in the bundle... bailing")
            return []
        }
        
        // convert to url
        let url = URL(fileURLWithPath: path)
        
        do {
            
            // setup decoder for converting json to Swift objects
            let decoder = JSONDecoder()
            
            // load data from file
            let data = try Data.init(contentsOf: url)
            
            // decode json from file
            let json = try decoder.decode([MyProduct].self, from: data)
            
            // all good, return array of products from json
            return json
            
        } catch {
            
            // catch and print errors for now...
            print("JSON serialization error: \(error)")
            
            // return empty array in case of error
            return []
        }
    }
}

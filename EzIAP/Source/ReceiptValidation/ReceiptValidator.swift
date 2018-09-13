//
//  ReceiptValidator.swift
//  EzIAP
//
//  Created by Seth on 9/9/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation


public class ReceiptValidator {
    
    /// the shared secret you setup in AppStoreConnect
    var accountSecret: String
    
    var logResponse: Bool = true
    let liveUrl = "https://buy.itunes.apple.com/verifyReceipt"
    let sandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    public init(secret: String) {
        accountSecret = secret
    }
    
    public func validateReceipt(completion: @escaping (ReceiptValidationResponse?, Error?) -> Void) {
        print("\(self) Validating receipt")
        
        // default to live environment
        var urlPath = liveUrl
        
        #if DEBUG
            // if this is a debug build, use sandbox
            urlPath = sandboxUrl
        #endif
        
        guard let data = loadReceipt() else {
            completion(nil, ReceiptValidationError.receiptLoadError)
            return
        }
        
        let body: [String: Any] = [
            "receipt-data": data.base64EncodedString(),
            "password": accountSecret,
            // If value is true, response includes only the latest renewal transaction for any subscriptions.
            "exclude-old-transactions": true
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []), let url = URL(string: urlPath) else {
            completion(nil, ReceiptValidationError.requestError)
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            guard error == nil, let responseData = responseData else {
                print("\(self) 🚫 Receipt Validation Failed: \n\(String(describing: error))\n")
                completion(nil, error)
                return
            }
            
            self.logData(jsonData: responseData)
            
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                decoder.dateDecodingStrategy = .formatted(formatter)
                let ezResponse = try decoder.decode(ReceiptValidationResponse.self, from: responseData)
                
                if let status = ezResponse.status, let statusError = ReceiptValidationError.init(rawValue: status) {
                    completion(nil, statusError)
                } else {
                    completion(ezResponse, nil)
                }
                
            } catch {
                print("\(self) 🚫 Receipt Validation Failed: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    private func logData(jsonData: Data?) {
        
        guard logResponse == true else {
            return
        }
        
        guard let jsonData = jsonData,
            let obj = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let pretty = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted),
            let prettyStr = String.init(data: pretty, encoding: .utf8) else {
            print("\(self) Unable to parse json response to log... bailing")
            return
        }
        
        print("\(self) - BEGIN --- Receipt Validation Response - BEGIN ---")
        print("\(prettyStr)")
        print("\(self) --- END --- Receipt Validation Response --- END ---")
    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("\(self) Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
}

//
//  ReceiptValidator.swift
//  EzIAP
//
//  Created by Seth on 9/9/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public enum EZIAPReceiptValidationError: Int16, Error {
    case receiptLoadError       = 2000
    case jsonReadFailure        = 21000
    case dataMalformed          = 21002
    case authenticationError    = 21003
    case sharedSecret           = 21004
    case serverUnavailable      = 21005
    case subscriptionExpired    = 21006
    case validateOnSandbox      = 21007
    case validateOnLive         = 21008
    
    var code: Int16 {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .receiptLoadError: return "Unable to locate purchase receipt."
        case .jsonReadFailure: return "App store could not read receipt json."
        case .dataMalformed: return "Receipt data malformed or missing."
        case .authenticationError: return "Receipt could not be authenticated."
        case .sharedSecret: return "Shared secret error."
        case .serverUnavailable: return "Receipt server unavailable."
        case .subscriptionExpired: return "Subscription expired."
        case .validateOnSandbox: return "Receipt is a sandbox receipt but sent to production server. Resubmit receipt verification to sandbox."
        case .validateOnLive: return "Receipt is a production receipt but sent to sandbox server. Resubmit receipt to production server."
        }
    }
}

public func ==(lhs: EZIAPReceiptValidationError, rhs: EZIAPReceiptValidationError) -> Bool {
    switch (lhs,rhs) {
    case (.receiptLoadError, .receiptLoadError),
         (.jsonReadFailure, .jsonReadFailure),
         (.dataMalformed, .dataMalformed),
         (.authenticationError, .authenticationError),
         (.sharedSecret, .sharedSecret),
         (.serverUnavailable, .serverUnavailable),
         (.subscriptionExpired, .subscriptionExpired),
         (.validateOnSandbox, .validateOnSandbox),
         (.validateOnLive, .validateOnLive):
        return true
    default:
        return false
    }
}

public class EZIAPReceiptValidator {
    
    /// the shared secret you setup in AppStoreConnect
    var accountSecret: String
    
    var logResponse: Bool = false
    let liveUrl = "https://buy.itunes.apple.com/verifyReceipt"
    let sandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    public init(secret: String) {
        accountSecret = secret
    }
    
    public func validateReceipt(completion: @escaping (EZIAPReceiptValidationResponse?, Error?) -> Void) {
        print("\(self) Validating receipt")
        
        guard let data = loadReceipt() else {
            completion(nil, EZIAPReceiptValidationError.receiptLoadError)
            return
        }
        
        let body = [
            "receipt-data": data.base64EncodedString(),
            "password": accountSecret
        ]
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        let url = URL(string: sandboxUrl)!
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
                let response = try decoder.decode(EZIAPReceiptValidationResponse.self, from: responseData)
                
                if let status = response.status, let statusError = EZIAPReceiptValidationError.init(rawValue: status) {
                    completion(nil, statusError)
                } else {
                    completion(response, nil)
                }
                
            } catch {
                print("\(self) 🚫 Receipt Validation Failed: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    private func logData(jsonData: Data?) {
        
        guard logResponse else {
            return
        }
        
        guard let jsonData = jsonData, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            print("\(self) Unable to parse json response to log... bailing")
            return
        }
        
        print("\(self) - BEGIN --- Receipt Validation Response - BEGIN ---")
        print(json)
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

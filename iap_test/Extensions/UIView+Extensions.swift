//
//  UIView+Extensions.swift
//  iap_test
//
//  Created by Seth on 8/7/18.
//  Copyright © 2018 Arnott Industries, Inc. All rights reserved.
//

import UIKit

public extension UIView {
    
    // convenience function for initializing views from .xib files
    public static func fromNib() -> UIView? {
        let nibName = String(describing: self)
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView else {
            print("Unable to instantiate nib named: \(nibName) in bundle: \(String(describing: bundle)) -- nib: \(String(describing: nib))")
            return nil
        }
        return view
    }
}

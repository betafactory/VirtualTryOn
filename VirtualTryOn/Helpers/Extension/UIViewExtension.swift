//
//  UIViewExtension.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0), shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addConstraintsWithVisualFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, item) in views.enumerated() {
            let key = "v\(index)"
            item.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = item
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

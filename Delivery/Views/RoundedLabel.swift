//
//  RoundedLabel.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
@IBDesignable

class RoundedLabel: UILabel {
    /**
    * If true, the border corner will be rounded.
    */
    @IBInspectable var rounded:Bool = false {
        didSet {
            if rounded {
                layer.cornerRadius = 10.0
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if rounded {
            layer.cornerRadius = 10.0
        }
    }
}

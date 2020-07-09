//
//  RoundedImageView.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    /**
     * The radius to use when drawing rounded corners for the layer’s background
     */
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            
            layer.cornerRadius = cornerRadius
        }
    }
    
    /**
     * The width of the layer’s border.
     */
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            
            layer.borderWidth = borderWidth
        }
        
    }
    
    /**
     * The color of the layer’s border.
     */
    @IBInspectable var borderColor: UIColor = UIColor.gray {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /**
     * Image color when using UIImage.RenderingMode
     */
    @IBInspectable var imageColor: UIColor = UIColor.gray {
        didSet{
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = imageColor
        }
    }
    
    @IBInspectable var circle: Bool = false {
        didSet{
            layoutSubviews()
        }
    }
    
    override public func layoutSubviews() {
        if circle {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.layer.frame.height/2
        }
    }
}

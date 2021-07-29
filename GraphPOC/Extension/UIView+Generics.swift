
//
//  UIView+Generics.swift
//  skinnyconfidential
//
//  Created by sahil jain on 3/27/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    

    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

    func setCornerForButton(_ radius: CGFloat) {
        return self.layer.cornerRadius = radius
    }
    
    func hideWithAnimation(hidden: Bool) {
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.isHidden = hidden
            })
        }
    

    func addBGImage(image:UIImage){
        UIGraphicsBeginImageContext(self.frame.size)
        image.draw(in: bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }
    
    //Add's top border to the UIView.
    func addTopBorder(){
        let topLayer:CALayer =  CALayer()
        topLayer.backgroundColor =  UIColor.black.cgColor
        topLayer.frame =  CGRect(x:0,y: 0,width: frame.width,height: 1.0)
        self.layer.addSublayer(topLayer)
    }
    
    func addBottomBorder(color:UIColor,size:CGFloat){
        let bottomLayer:CALayer =  CALayer()
        bottomLayer.backgroundColor =  color.cgColor
        bottomLayer.frame =  CGRect(x: 0, y: frame.size.height, width: frame.width, height: size)
        self.layer.addSublayer(bottomLayer)
    }
    
    func addBottomBorder(color:UIColor, width:CGFloat){
        let bottomLayer:CALayer =  CALayer()
        bottomLayer.backgroundColor =  color.cgColor
        bottomLayer.frame =  CGRect(x:0,y: frame.size.height,width: frame.width,height: width)
        self.layer.addSublayer(bottomLayer)
    }
    
    func addBorder(withColor color:UIColor, borderWidth: CGFloat = 1.0){
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func addBorder(withColor color:UIColor, borderHeight:CGFloat){
        layer.borderWidth = borderHeight
        layer.borderColor = color.cgColor
    }
    
    func addCornerRadius(radius:CGFloat, masksToBounds: Bool = true ){
        layoutIfNeeded()
        layer.cornerRadius = radius
        layer.masksToBounds = masksToBounds
    }
    
    func addShadow(color:UIColor){
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
    }
    
    func addShadowWithCGPath(color:UIColor){
        layer.shadowPath =
            UIBezierPath(roundedRect: bounds,
                         cornerRadius: layer.cornerRadius).cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    func addShadowWithCornerRadius(color:UIColor){
         self.layer.shadowColor = color.cgColor
         self.layer.shadowOpacity = 0.5
         self.layer.shadowRadius = 2.0
         self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
         self.layer.cornerRadius = 10
     }
    
    func removeShadow(){
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0
    }
    
    func dropShadow(color: UIColor = UIColor.gray, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 5, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.monteserratSemiBold
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.monteserratSemiBold
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

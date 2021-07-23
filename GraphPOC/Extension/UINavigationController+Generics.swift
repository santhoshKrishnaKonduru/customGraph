//
//  UINavigationController+Generics.swift
//  skinnyconfidential
//
//  Created by sahil jain on 3/25/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    func setNavTitle(title:String, navigationItem:UINavigationItem){
        navigationItem.title = title.capitalized;
    }
    
    func addTitleView(titleView:UIView,navigationItem:UINavigationItem){
        navigationItem.titleView = titleView
    }
    
    func hideIt(){
        isNavigationBarHidden = true
    }
    
    func unhideIt(){
        isNavigationBarHidden = false
    }
    
    func updateAttributes(isTranslucent: Bool = false, tintColor: UIColor? = nil, navBarColor: UIColor? = nil){
        isNavigationBarHidden = false
        navigationBar.isTranslucent = isTranslucent
        let navBarTintColor = navBarColor ?? UIColor.navBarTintColor
        let navTintColor = tintColor ?? UIColor.navTintColor
        let titleAttributes:[NSAttributedString.Key:AnyObject] = [NSAttributedString.Key.font:UIFont.navBarTitleFont,NSAttributedString.Key.foregroundColor: tintColor ?? UIColor.navBarTitleColor]
        
        navigationBar.barTintColor = navBarTintColor
        navigationBar.tintColor = navTintColor
        navigationBar.titleTextAttributes = titleAttributes
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = navBarTintColor
        UINavigationBar.appearance().tintColor = navTintColor
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
    }
    
    func applyBgTransparencyWithExtendedBG(){
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default;
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    
    func applyNavigationBarAttributes(navigationBarTintColor: UIColor, navigationTintColor: UIColor, navigationTitleAttributes: [NSAttributedString.Key:AnyObject]){
         navigationBar.barTintColor = navigationBarTintColor
         navigationBar.tintColor = navigationTintColor
         navigationBar.titleTextAttributes = navigationTitleAttributes
     }
    
    func addLeftBarButtonImage(leftImage:UIImage, navigationItem:UINavigationItem){
           let barButton = UIBarButtonItem(image: leftImage, style: UIBarButtonItem.Style.plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
           navigationItem.leftBarButtonItem = barButton
       }
       
      func addRightBarButtonImage(rightImage:UIImage,navigationItem:UINavigationItem){
           let barButton = UIBarButtonItem(image: rightImage, style: UIBarButtonItem.Style.plain, target: self.topViewController, action: Selector(("didTapOnRightNavigationButton")))
           navigationItem.rightBarButtonItem = barButton
       }
    
    
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
    
}



//App specific
extension UINavigationController{
    func enableSwipeToPop(){
        interactivePopGestureRecognizer?.delegate = nil
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func disableSwipeToPop(){
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func transParentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.clear
    }
}


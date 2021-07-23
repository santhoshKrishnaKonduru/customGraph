//
//  AppSession.swift
//  saveit
//
//  Created by Bitcot Inc on 30/08/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
import SideMenu
//import SlideMenuControllerSwift

class AppSession: NSObject{
    
    static let sharedInstance = AppSession()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
    let window = (UIApplication.shared.delegate as! AppDelegate).window!
    var baseTabBarNavVC:UINavigationController?
    
    func loadSideMenu(){
        if #available(iOS 13.0, *) {
            let vc = mainStoryboard.instantiateViewController(identifier: "MenuViewController")
            let leftMenuNavigationController = SideMenuNavigationController(rootViewController: vc)
            SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    func loadOnboarding(){
        if LoggedInUser.sharedInstance.isLoggedIn{
            loadHomeVC()
        }else{
            let vc = onboardingStoryboard.instantiateViewController(withIdentifier: "OnboardingRootController")
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
    
    func loadHomeVC(){
//        let baseTabBarVC = BaseTabBarViewController()
//        let baseTabBarNavVC = UINavigationController(rootViewController: baseTabBarVC)
//        window.rootViewController = baseTabBarNavVC
    }
    
    func logout(){
        AppSession.sharedInstance.loadOnboarding()
    }
}

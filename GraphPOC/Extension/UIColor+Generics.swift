
//
//  UIColor+Generics.swift
//  skinnyconfidential
//
//  Created by sahil jain on 3/27/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
 
    //navigation bar tint colors
    static let navigationBarTintColor = UIColor.white
    
    static let navigationTitleColor = UIColor.black
    static let navigationTintColor = UIColor.black
 //   @objc static let darkGrayColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    static let sectionHeaderColor =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: CGFloat(0.50))
    static let statusRequestedColor = UIColor(red: 255.0/255.0, green: 163.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let statusCancelledColor = UIColor(red: 85.0/255.0, green: 60.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static let lightAppGrayColor = UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1.0)

    static let learnerRequestedStatusColor = UIColor(red: 255.0/255.0, green: 163.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let learnerCancelledStatusColor = UIColor(red: 85.0/255.0, green: 60.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static let instructorCancelledStatusColor = UIColor(red: 75.0/255.0, green: 78.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    static let instructorPhotoBorderColor = UIColor(red: 20.0/255.0, green: 254.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let errorMsgOrangeColor =   UIColor(red: 255.0/255.0, green: 163.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let feedbackPlaceHolderColor =  UIColor(red: 127.0/255.0, green: 116.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    static let galleryBackGroundColor =  UIColor(red: 65.0/255.0, green: 70.0/255.0, blue: 77.0/255.0, alpha: 1.0)


    //    error colors
    //    96c1c1 rgb(150, 193, 193)
    static let error1 = #colorLiteral(red: 0.5882352941, green: 0.7568627451, blue: 0.7568627451, alpha: 1)

    //      fff4f4 rgb(255, 244, 244)
    static let error2 = #colorLiteral(red: 1, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    //    #961C1C rgb(150, 28, 28)
    static let errorBorderColor = #colorLiteral(red: 0.5882352941, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    
    //#efeeed rgb(239, 238, 237)
    static let base1 = #colorLiteral(red: 0.937254902, green: 0.9333333333, blue: 0.9294117647, alpha: 1)
    //dddcda rgb(221, 220, 218)
    static let base2 = #colorLiteral(red: 0.8666666667, green: 0.862745098, blue: 0.8549019608, alpha: 1)
    //bdbab4 rgb(189, 186, 180)
    static let base3 = #colorLiteral(red: 0.7411764706, green: 0.7294117647, blue: 0.7058823529, alpha: 1)
    //575552 rgb(87, 85, 82)
    static let base4 = #colorLiteral(red: 0.3411764706, green: 0.3333333333, blue: 0.3215686275, alpha: 1)
    
    

    static var TabBarTint:UIColor{
        get{
            return UIColor.red
        }
    }
    
    static var TabBarBackground:UIColor{
        get{
            return UIColor.red
        }
    }
    
    static var TabBarUnSelectedTint:UIColor{
        get{
            return UIColor.red
        }
    }
    
    static var navBarTintColor:UIColor{
        get{
            return UIColor.navigationBarTintColor
        }
    }
    
    static var navTintColor:UIColor{
        get{
            return UIColor.navigationTintColor
        }
    }
    
    static var navBarTitleColor:UIColor{
        get{
            return UIColor.navigationTitleColor
        }
    }
    
    static var vcBackground:UIColor{
        get{
            return UIColor.red
        }
    }
    
    static let viewBorderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    
    
}

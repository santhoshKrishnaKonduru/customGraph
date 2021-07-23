//
//  Constants.swift
// 
//
//  Created by Bitcot Inc on 13/01/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import Foundation

typealias CompletionBlock = (AlamofireAPIResponse) -> Void
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

//MARK:SegueIdentifier
struct SegueIdentifier {
   
    static let LoginViewController = "LoginViewController"
    static let AppViewController = "AppViewController"
    static let SignUpViewController = "SignUpViewController"
    static let VerificationViewController = "VerificationViewController"
    static let HomeViewControllerScene = "HomeViewControllerScene"
    static let LaunchNavVC = "LaunchNavVC"
}

//MARK:NotificationName
extension Notification.Name {
    static let kExampleNotification = Notification.Name("ExampleNotification")
}

//MARK:APIKeys
struct Keys{
   
}

struct UserDefaultKeys{
    static let kLaunchedFirstTime = "kLaunchedFirstTime"
}


//MARK:days


//MARK:SettingsOptions
enum SettingsType:String{
    case option1
}


//MARK:Remote Notifications

enum NotificationOption:String{
    case sample_notification = "s:rq"
    
}


// MARK :General Constants
struct Constants {
    struct PlaceHolderImage {
        
    }
    
    struct Error {
        static let networkMsg = "Please check your internet connection and try again!"
        static let generalMsg = "Error while processing your request, Please try again later"
        static let loginMsg = "Error While Logging in, Please try again"
    }
}

//MARK:Placeholder Images
struct PlaceholderImages{
    static let StylePlaceholderIcon = "style_placeholder_icon"
    static let Profile = "profile_placeholder"
    static let ImagePlaceholder = "image_placeholder"
}

//MARK:Server Response Key
struct ServerResponseKey {
    static let SUCCESS = "success"
    static let ERROR = "error"
}

//MARK: User Details

enum Fields: Int {
    case email, password, firstName, lastName, confirmPassword, createPassword, emailAddress, currentPassword

    var title: String {
        get {
            switch self {
            case .password:
                return "PASSWORD"
            case .firstName:
                return "FIRST NAME"
            case .lastName:
                return "LAST NAME"
            case .email:
                return "EMAIL"
            case .confirmPassword:
                return "CONFIRM PASSWORD"
            case .emailAddress:
                return "E-mail Address"
                case .createPassword:
                return "CREATE PASSWORD"
            case .currentPassword:
                return "Current password"
            }
        }
    }

    var placeholder: String {
        get {
            switch self {
            case .password:
                return "Password*"
            case .firstName:
                return "First name*"
            case .lastName:
                return "Last name*"
            case .email:
                return "Enter E-mail"
            case .confirmPassword:
                return "Confirm password"
            case .createPassword:
                return "Create password"
            case .emailAddress:
                return "E-mail Address*"
            case .currentPassword:
                return "Current password"
            }
        }
    }
    
    var error: String {
        get {
            switch self {
            case .email:
                return "Please enter valid email"
            case .password:
                return "Please enter valid password"
            case .firstName:
                return "Please enter firstname"
            case .lastName:
                return "Please enter lastname"
            case .confirmPassword:
                return "Please confirm password"
            case .createPassword:
                return "Please enter password"
            case .emailAddress:
                return "Please enter valid email"
            case .currentPassword:
                return "Please enter current password"
            }
        }
    }
}

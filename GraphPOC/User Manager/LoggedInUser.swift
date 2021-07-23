    // LoggedInUser.swift
    // Notv
    //
    // Created by on 14/01/16.
    // Copyright © 2016 bitcot. All rights reserved.
    //
    import UIKit
    import ObjectMapper
    
    class LoggedInUser: NSObject, Codable {
        let kAuthTokenKey = "AUTH_TOKEN_KEY"
        let krefreshToken = "REFRESH_TOKEN"
        let kUserkey = "USER_KEY"
        
        static let sharedInstance = LoggedInUser()
        var user: User?
        var authToken:String!
        var refreshToken: String?
        
        override init() {
            super.init()
            self.loadLoggedInDetails()
        }
        
        var isLoggedIn: Bool {
            get {
                if (authToken != nil && authToken!.count > 0) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        func loadLoggedInDetails() {
            print("Loading login details...")
            authToken = getUserDefault(key: kAuthTokenKey) as? String
            refreshToken = getUserDefault(key: krefreshToken) as? String
            
            if let user = getUserDefault(key: kUserkey){
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(User.self, from: user as! Data) {
                    self.user = user
                }
                
            }
        }
        
        func updateToken(token:String, refreshToken:String){
            setUserDefault(key: kAuthTokenKey, value: token as AnyObject)
            setUserDefault(key: krefreshToken, value: refreshToken as AnyObject)
            self.authToken = token
            self.refreshToken = refreshToken
        }
        
        func storeUserDetails(response:[String:AnyObject]){
            if let user = Mapper<User>().map(JSONObject: response["user"]){
                self.user = user
                authToken = response["token"] as? String
                refreshToken = response["refreshToken"] as? String
            }
            self.setUserDetails(user: user, authToken: authToken, refreshToken:refreshToken)
            save()
        }
        
        func setUserDetails(user:User?, authToken:String?, refreshToken:String?){
            
            if let _ = user {
                self.user = user
            }
            if let _ = authToken{
                self.authToken = authToken
            }
            if let _ = refreshToken {
                self.refreshToken = refreshToken
            }
            save()
        }
        
        func save() {
            print("Saving user details...")
            
            if let authToken = authToken {
                setUserDefault(key: kAuthTokenKey, value: authToken as AnyObject)
            }
            if let refreshToken = refreshToken {
                setUserDefault(key: krefreshToken, value: refreshToken as AnyObject)
            }
            if let user = user {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    setUserDefault(key: kUserkey, value: encoded as AnyObject)
                }
            }
            print("Details saved.")
        }
        
        func logout() {
            print("Log out.")
            self.deleteLoggedInDetails()
        }
        
        func deleteLoggedInDetails() {
            print("Deleting logged in details...")
            UserDefaults.standard.removeObject(forKey: kAuthTokenKey)
            UserDefaults.standard.removeObject(forKey: krefreshToken)
            UserDefaults.standard.removeObject(forKey: kUserkey)
            user = nil
            authToken = nil
            refreshToken = nil
        }
    }

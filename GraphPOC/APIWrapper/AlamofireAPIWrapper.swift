//
//  AlamofireAPIWrapper.swift
//  oceanheroes
//
//  Created by Santosh on 15/06/20.
//  Copyright © 2020 Bitcot Technologies. All rights reserved.
//

import Foundation
import Alamofire

//let baseURL = ""
//let versionURL = "api/v1/"
//#if DEBUG
////let baseURL = "https://api.tscbodyapp.com/"
//let baseURL = "https://vs-stage-api.bitcotapps.com/"
//let versionURL = "v1/"
//#else
//let baseURL = "https://vs-stage-api.bitcotapps.com/"
//let versionURL = "v1/"
//#endif

let baseURL = "https://vs-stage-api.bitcotapps.com/"
let versionURL = "v1/"


class AlamofireAPIWrapper: NSObject {
    
    static let sharedInstance = AlamofireAPIWrapper()
    private let loggedInUser = LoggedInUser.sharedInstance
    
    
    var authHeaders:HTTPHeaders{
        get{
            return ["Content-Type":"application/json","Accept":"application/json", "X-Access-Token": "5cf9dfd5-3449-485e-b5ae-70a60e997864"]
        }
    }
    
    var additionalHeaders: HTTPHeaders{
        get{
            return ["Content-Type":"application/json","Accept":"application/json"]
        }
    }
    
    func syncDeviceToken(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "add-device"
        let header = authHeaders
        print("add-device requestDict:", requestDict)
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print("add-device:", jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func removeDevice(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        
        let urlString = "remove-device"
        let header = authHeaders
        print("add-device requestDict:", requestDict)
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print("add-device:", jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    //MARK: - User Login / Signup
    func userSignUp(params:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth/signup"
        let headers = additionalHeaders
        print("baseURL:\(baseURL + versionURL + urlString)")
        AF.request(baseURL + versionURL + urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func userSignIn(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth/login"
       
        let headers = additionalHeaders
        AF.request(baseURL + versionURL + urlString, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func getUserDetails(responseBlock:@escaping CompletionBlock) {
        
        let urlString = "/user"
        let headers = authHeaders
        
        AF.request(baseURL + versionURL + urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func forgotPassword(requestDict:[String:AnyObject], responseBlock:@escaping CompletionBlock) {
        let urlString = "auth/password/forgot"
        
        let headers = additionalHeaders
        AF.request(baseURL + versionURL + urlString, method:.put, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func resetPassword(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth/resetpassword"
        
        let headers = additionalHeaders
        AF.request(baseURL + versionURL + urlString, method:.put, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func changePassword(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth/password/change"
        
        let headers = authHeaders
        AF.request(baseURL + versionURL + urlString, method:.put, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
   
    
    
    
    
    func updateUserProfile(requestDict:[String:AnyObject], responseBlock:@escaping CompletionBlock) {
        let urlString = "user/5ee8744ac610960569900d41"
        let header = authHeaders
        
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method: .put, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func favoritePost(postID: Int, requestDict:[String:AnyObject], responseBlock:@escaping CompletionBlock) {
        let urlString = "post/\(postID)/favourite"
        let header = authHeaders
        
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method: .put, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func uploadImage(uploadURL: URL,
                     image: UIImage,
                     responseBlock: @escaping CompletionBlock) {
        
        let headers = [
            "cache-control": "no-cache",
        ]
        let imageData = image.jpegData(compressionQuality: 1.0)
        let imageSize: Int = imageData!.count
        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
        let request = NSMutableURLRequest(url: uploadURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 2400.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.uploadTask(with: request as URLRequest, from: imageData!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 1, errorMessage: "Couldn't upload", successful: false)
                responseBlock(apiResponse)
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
                print(httpResponse?.statusCode)
                if httpResponse!.statusCode == 200 {
                    let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 0, errorMessage: "", successful: true)
                    responseBlock(apiResponse)
                }else{
                    let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 0, errorMessage: "Couldn't upload", successful: false)
                    responseBlock(apiResponse)
                }
                //                httpResponse.reps
            }
        })
        dataTask.resume()
        
    }
    func getUserData(responseBlock:@escaping CompletionBlock) {
        let urlString = "user"
        let header = authHeaders
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    
    
    func configCall(responseBlock: @escaping CompletionBlock) {
    
        let urlString = "config"
        let header = additionalHeaders
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    
    func checkForAppUpdate(responseBlock: @escaping CompletionBlock) {
        
        let appVersion = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
        let urlString = "config?ios_version=\(appVersion)"
        let header = additionalHeaders
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    
    func getMyProfileDetails(responseBlock:@escaping CompletionBlock) {
        
        let urlString = "my-profile"
        let header = authHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
   
    
    func forgotPassword(request: JSONDictionary,responseBlock:@escaping CompletionBlock) {
        
        let urlString = "auth/forgotpassword"
        let header = additionalHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func setPassword(request: JSONDictionary,responseBlock:@escaping CompletionBlock) {
        
        let urlString = "set-password-email"
        let header = additionalHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func getUserProfile(responseBlock:@escaping CompletionBlock) {
        
        let urlString = "my-profile"
        let header = authHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func verifyUserAccount(userId: String, request: [String: AnyObject], responseBlock:@escaping CompletionBlock) {
        
        let urlString = "auth/verify/\(userId)"
        let header = additionalHeaders
        print(baseURL + versionURL + urlString)
        AF.request(baseURL + versionURL + urlString, method:.put, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func resendVeificationCode(userId: String, responseBlock:@escaping CompletionBlock) {
        
        let urlString = "auth/resend/\(userId)"
        let header = additionalHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.put, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    
    func sendSubscriptionDetails(requestDict: JSONDictionary, responseBlock:@escaping CompletionBlock) {
        let urlString = "subscription/"
        let headers = authHeaders
        
        AF.request(baseURL + versionURL + urlString, method:.post, parameters: requestDict, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func getPreSignURL(responseBlock:@escaping CompletionBlock, query: String) {
        
        let urlString = "configuration/presign_url"
        let header = authHeaders
        print(header)
        print(baseURL + versionURL + urlString + query)
        AF.request(baseURL + versionURL + urlString + query, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    
    func getCovidDetailsWorld(fromDate: String, toDate: String, responseBlock:@escaping CompletionBlock) {
        
        let urlString = "https://api.covid19api.com/world?from=\(fromDate)&to=\(toDate)"
        let header = authHeaders
        
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func getCovidDataStatus(of country: String, fromDate: String, toDate: String, responseBlock:@escaping CompletionBlock) {
        
        let urlString = "https://api.covid19api.com/country/\(country)?from=\(fromDate)&to=\(toDate)"
        let header = authHeaders
        
        print(urlString)
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func getAllCountries(responseBlock:@escaping CompletionBlock) {
        
        let urlString = "https://api.covid19api.com/countries"
        let header = authHeaders
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    
    func getAllCountiesFlags(responseBlock:@escaping CompletionBlock) {
        
        let urlString = "https://restcountries.eu/rest/v2/all"
        let header = additionalHeaders
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })

    }

    
}




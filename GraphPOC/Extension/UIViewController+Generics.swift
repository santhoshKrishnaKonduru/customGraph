//
//  UIViewController+Generics.swift
//  skinnyconfidential
//
//  Created by Santosh on 17/04/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import UIKit
import KRProgressHUD
import NotificationBannerSwift
import NVActivityIndicatorView
import MessageUI
//import Branch
import Social

class CustomBannerColors: BannerColorsProtocol {
    
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger: return UIColor.red    // Your custom .danger color
        default: return UIColor.emLightBlue
        }
    }
    
}

extension UIViewController {
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    func showLocationNotAllowedAlert(){
        var msg:String = ""
        showAlert(target: self, message: msg, title: "No Location Access", buttonTitle: "Got it!", buttonTitle2: "Settings", completionBlock: {
            index in
            if index == 2{
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
        })
    }
    
    
    func showSlideNotification(notificationText: String, notificationShowTime: TimeInterval = 2.5, attribtedMessage: NSAttributedString? = nil) {
        //        let window = AppSession.sharedInstance.getAppWindow()
        //        let frame = CGRect(x: window.frame.minX, y: window.frame.minY, width: window.frame.width, height: 100)
        //        let notificationView = SlideNotificationView.loadView(frame)
        //        notificationView.delegate = self
        //        window.addSubview(notificationView)
        //        notificationView.layoutIfNeeded()
        //        notificationView.showNotificationView(title: notificationText, delayViewTime: 0.1, notificationShowTime: notificationShowTime, attribtedMessage: attribtedMessage)
        
        let banner = GrowingNotificationBanner(title: "", subtitle: notificationText, style: .success, colors: CustomBannerColors())
        banner.show()
        
        
    }
    
    func showNetworkAlert(){
        let message = "Network Error\n\(Constants.Error.networkMsg)"
        showSlideNotification(notificationText: message)
    }
    
//    func flag(from country:String) -> String {
//        let base : UInt32 = 127397
//        var s = ""
//        for v in country.uppercased().unicodeScalars {
//            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
//        }
//        return s
//    }
    
   
    func showErrorAlertWithMsg(msg:String){
        showSliderAlert(message: msg, title: "Oops...", buttonTitle: "OK")
    }
    
    func showErrorAlert(){
        showSliderAlert( message: Constants.Error.generalMsg, title: "Oops...", buttonTitle: "OK")
    }
    
    func showSliderAlert(message: String?, title: String?, buttonTitle: String?) {
        let message = "\(title ?? "")\n\(message ?? "")"
        self.showSlideNotification(notificationText: message)
    }
    
    // MARK: progress bar functionality
    func showProgress(message: String?) {
        DispatchQueue.main.async {
            self.setUp()
            if let msg = message {
                KRProgressHUD.showMessage(msg)
            } else {
                KRProgressHUD.show()
            }
        }
        
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
    }
    
    private func setUp() {
        KRProgressHUD.appearance().activityIndicatorColors = [UIColor.green, UIColor.red]
    }
    
    func loadActivityController(desc:String?,image:UIImage?, popOverFrame:CGRect?, sourceView:UIView?){
        
        var objectsToShare = [AnyObject]()
        if let _ = image{
            objectsToShare.append(image!)
        }
        if let _ = desc{
            objectsToShare.append(desc! as AnyObject)
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            activityVC.popoverPresentationController!.sourceView = sourceView
        }
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    func isSuccessful(responseObject:[String:AnyObject]?) -> Bool{
        if let _ = responseObject?["type"]{
            if let result  = responseObject!["type"] as? String{
                return result == ServerResponseKey.SUCCESS ? true : false
            }else if let result  = responseObject!["type"] as? Bool{
                return result == true ? true : false
            }
            else{
                return false
            }
        }else if  responseObject?["errorCode"] as? Int  != nil || responseObject?["errorCode"] as? String != nil{
            return false
        }else if let statusCode = responseObject?["statusCode"] as? Int {
            return statusCode ==  200
        }else if let dataResponse = responseObject?["data"] as? JSONDictionary {
            if let statusCode = dataResponse["status"] as? Int {
                return statusCode == 200
            }
            return true
        }else if let success = responseObject?["success"] as? Bool {
            return success
        }else  if let _ = responseObject?["subscription"]  {
            return true
        }
        return false
    }
    
    
    func validateServerResponse(response:AlamofireAPIResponse, showErrorAlert:Bool) -> (Bool, JSONDictionary?){
        if response.isSuccessful{
            let responseObject = response.responseObject as? JSONDictionary
            if self.isSuccessful(responseObject: responseObject){
                return (true, responseObject)
            }else if let _ = response.responseObject as? JSONArray {
                return (true, nil)
            }else{
                if let _ = responseObject{
                    if let error = responseObject!["error"] as? JSONDictionary{
                        let errorCode = error["code"] as? Int
                        let errorMsg = error["message"] as? String
                        self.hideProgress()
                        if let _ =  errorCode{
                            if showErrorAlert{
                                if errorMsg != nil {
                                    self.showErrorAlertWithMsg(msg: errorMsg!)
                                }
                            }
                            
                            if errorCode == 401 {
                                AppSession.sharedInstance.logout()
                            }
                        }
                    }else if let error = responseObject!["message"] as? String {
                        self.hideProgress()
                        if showErrorAlert {
                            showSliderAlert(message: error, title: "Oops...", buttonTitle: "OK")
                        }
                        if let dataResponse = responseObject!["data"] as? JSONDictionary, let statusCode = dataResponse["status"] as? Int {
                            if statusCode == 403 {
                                AppSession.sharedInstance.logout()
                            }
                            
                        }else if error == "Unauthorized" {
                            AppSession.sharedInstance.logout()
                        }
                        
                    }else if let dataResponse = responseObject?["data"] as? JSONDictionary, let message = dataResponse["message"] as? String {
                        self.hideProgress()
                        if showErrorAlert {
                            showSliderAlert(message: message, title: "Oops...", buttonTitle: "OK")
                        }
                    }else{
                        self.hideProgress()
                        if showErrorAlert{
                            self.showErrorAlert()
                        }
                    }
                }
                else{
                    self.hideProgress()
                    if showErrorAlert{
                        self.showErrorAlert()
                    }
                }
                return (false, responseObject)
            }
        }
        else{
            self.hideProgress()
            if showErrorAlert{
                self.showErrorAlert()
            }
            return (false,nil)
        }
    }
    
    func loadEmailSupport(sender:String, subject:String ){
        //  let mailController = mailComposeController()
        let mailController  = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject(subject)
        mailController.setToRecipients([sender])
        
        var messageBody = "Find a bug? Have a question or suggestion? Need help?\n\nYour feedback is very important to us\nand can help make this app better for everyone!\n\nThank you for telling us how we can help.\nPlease enter your message below, between the dotted lines:\n----------------------------------------\n\n\n\n\n\n----------------------------------------\nDevice : " + UIDevice.modelName + "\niOS Version: " + UIDevice.current.systemVersion
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String{
            messageBody = messageBody + "\n  App version: " + appVersion
        }
        
        mailController.setMessageBody(messageBody, isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailController, animated: true, completion: nil)
        }
        else{
            showAlertPopController(target: self, message: "Sorry cannot send mail", title: "Error", buttonTitle: "OK")
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func navigateWithSuccessfulMsg(msg:String,title:String, isPresented:Bool){
        let alert = showAlert(message: msg, title: title)
        let action = UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
            if isPresented{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        _ = UIApplication.shared.keyWindow?.rootViewController
        self.present(alert, animated: true, completion: {
            //            if isPresented{
            //                self.dismissViewControllerAnimated(true, completion: nil)
            //            }
            //            else{
            //                self.navigationController?.popViewControllerAnimated(true)
            //            }
        })
    }
    
    func navigateAfterShowingPrompt(msg:String,title:String, isPresented:Bool){
        let alert = showAlert(message: msg, title: title)
        let action = UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
            if isPresented{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let _ = self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
        })
    }
    
    func loadViewControllerWithTabTitle(title:String!,image:UIImage){
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
    
    func addBGImageToView(view:UIView, image:UIImage){
        UIGraphicsBeginImageContext(view.frame.size)
        image.draw(in: view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: image)
    }
    
    
    func currentScreenshot() -> UIImage{
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //Age
    func getAge(birthDate:Date) -> Int {
        let calendar = NSCalendar.current
        //let ageComponents = calendar.components(.Year,fromDate: birthDate,toDate: NSDate(),options: [])
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year!
    }
    
    //    MARK:
    func addProgressLoadingToView(view:UIView){
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    //MARK: MFMailComposeViewControllerDelegate
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    //MARK:end
}



//
//  Utils.swift
//
//
//  Created by on 11/12/15.
//  Copyright © 2015 Bitcot. All rights reserved.
//

import Foundation
import ImageIO
import UIKit
import Kingfisher
import Photos

extension Int {
    func toBool () ->Bool? {
        
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }
}

func isAnyNil(optionals: Optional<Any> ...) -> Bool {
    return optionals.contains { $0 == nil }
}

public func generateStateWithLength (len : Int) -> NSString {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomString : NSMutableString = NSMutableString(capacity: len)
    for _ in 0 ..< len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString
}

//MARK: - User Default Helpers

public func setUserDefault(key: String, value: AnyObject) {
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}


public func setUserDefault(key: String, forBoolValue value: Bool) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(value, forKey: key)
    userDefaults.synchronize()
}


public func getUserDefault(key: String) -> AnyObject? {
    let userDefaults = UserDefaults.standard
    return userDefaults.value(forKey: key) as AnyObject?
}


public func checkForKey(key: String) -> Bool {
    let userDefaults = UserDefaults.standard
    return userDefaults.bool(forKey: key)
}

public func remove(key: String) {
    let userDefaults = UserDefaults.standard
    userDefaults.removeObject(forKey: key)
    userDefaults.synchronize()
}

// MARK: - UIColor helpers

public func colorFromHexString(hexString: String) -> UIColor {
    //var cString:String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    
    if (cString.count != 6) {
        return UIColor.gray
    }
    
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}


// MARK: - UIImage Helpers

public func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
    var returnImage: UIImage?
    
    var scaleFactor: CGFloat = 1.0
    var scaledWidth = size.width
    var scaledHeight = size.height
    var thumbnailPoint = CGPoint(x: 0, y: 0)
    
    if !image.size.equalTo(size) {
        let widthFactor = size.width / image.size.width
        let heightFactor = size.height / image.size.height
        
        if widthFactor > heightFactor {
            scaleFactor = widthFactor
        } else {
            scaleFactor = heightFactor
        }
        
        scaledWidth = image.size.width * scaleFactor
        scaledHeight = image.size.height * scaleFactor
        
        if widthFactor > heightFactor {
            thumbnailPoint.y = (size.height - scaledHeight) * 0.5
        } else if widthFactor < heightFactor {
            thumbnailPoint.x = (size.width - scaledWidth) * 0.5
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    
    var thumbnailRect = CGRect.zero
    thumbnailRect.origin = thumbnailPoint
    thumbnailRect.size.width = scaledWidth
    thumbnailRect.size.height = scaledHeight
    
    image.draw(in: thumbnailRect)
    
    returnImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    
    //    let imageData = UIImagePNGRepresentation(image)
    //
    //    if let imageSource = CGImageSourceCreateWithData(imageData!, nil) {
    //        let options: [NSString: NSObject] = [
    ////            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) / 2.0,
    //            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
    //            kCGImageSourceCreateThumbnailFromImageAlways: true
    //        ]
    //
    //        returnImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap { UIImage(CGImage: $0) }
    //    }
    
    return returnImage
}

//download image using kingfisher

public func loadImage(imageView:UIImageView, photoURL:String){
    //here the king fisher pod is used to sample the image so that it does not again download the image from the server.
    let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
    let url = URL(string: photoURL)
    imageView.kf.setImage(
        with: url,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
    ])
}
public func getURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
    
    if mPhasset.mediaType == .image {
        let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
            return true
        }
        mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
            completionHandler(contentEditingInput!.fullSizeImageURL)
        })
    } else if mPhasset.mediaType == .video {
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
            if let urlAsset = asset as? AVURLAsset {
                let localVideoUrl = urlAsset.url
                completionHandler(localVideoUrl)
            } else {
                completionHandler(nil)
            }
        })
    }
    
}

//MARK:CustomBarButton

public  func customBarButtonDesign(_ iconName:String,title:String) -> UIButton{
    let btn = UIButton(type: .custom)
    btn.setImage(UIImage(named: iconName), for: .normal)
    //btn2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
    btn.setTitle(title, for: .normal)
    btn.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
    return btn
    
}
//Mark:end

//MARK:date & time

func addDaysToDate(date:Date) -> Date{
    let calendar = Calendar.current
    // return calendar.dateByAddingUnit(.Day, value: 7, toDate: NSDate(), options: [])!
    return calendar.date(byAdding: .day, value: 7, to: NSDate() as Date)!
}

func getWeekDatesForDate(date:Date) -> [Date]{
    let calendar = Calendar.current
    var startOfTheWeek = Date()
    var endOfWeek: Date?
    var interval = TimeInterval(0)
    let currentDate = date
    
    // calendar.rangeOfUnit(.WeekOfMonth, startDate: &startOfTheWeek, interval: &interval, forDate: currentDate)
    // func range(of unit: NSCalendar.Unit,start datep: AutoreleasingUnsafeMutablePointer<NSDate?>?,
    // interval tip: UnsafeMutablePointer<TimeInterval>?,
    // for date: Date)
    
    calendar.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for: currentDate)
    endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)
    //let thisWeekDates = fetchDatesBetween(toDate: startOfTheWeek!, fromDate: endOfWeek)
    let thisWeekDates = fetchDatesBetween(toDate: startOfTheWeek, fromDate: endOfWeek!)
    return thisWeekDates
}

func getMonthDatesForDate(date:Date) -> [Date]{
    let calendar = Calendar.current
    var startOfTheWeek = Date()
    var endOfWeek: Date!
    var interval = TimeInterval(0)
    let currentDate = date
    //calendar.rangeOfUnit(.Month, startDate: &startOfTheWeek, interval: &interval, forDate: currentDate)
    calendar.dateInterval(of: .month, start: &startOfTheWeek, interval: &interval, for: currentDate)
    endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)
    let thisWeekDates = fetchDatesBetween(toDate: startOfTheWeek, fromDate: endOfWeek)
    return thisWeekDates
}

func getMonthsStartAndEndDate(date:Date) -> (Date,Date){
    let calendar = Calendar.current
    var startOfTheMonth = Date()
    var endOfMonth: Date!
    var interval = TimeInterval(0)
    let currentDate = date
    // calendar.rangeOfUnit(.Month, startDate: &startOfTheMonth, interval: &interval, forDate: currentDate)
    calendar.dateInterval(of: .month, start: &startOfTheMonth, interval: &interval, for: currentDate)
    endOfMonth = startOfTheMonth.addingTimeInterval(interval - 1)
    return (startOfTheMonth,endOfMonth!)
}

func getDateMilliSecFromString(date:String) -> NSDate{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: date)! as NSDate
}

func getEpoch() -> TimeInterval{
    let epoc = NSDate().timeIntervalSince1970
    return epoc 
}

func getThisWeekDates() -> [Date]{
    let calendar = Calendar.current
    var startOfTheWeek = Date()
    var endOfWeek: Date!
    var interval = TimeInterval(0)
    let currentDate = Date()
    // calendar.rangeOfUnit(.WeekOfMonth, startDate: &startOfTheWeek, interval: &interval, forDate: currentDate)
    calendar.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for:currentDate)
    endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)
    let thisWeekDates = fetchDatesBetween(toDate: startOfTheWeek , fromDate: endOfWeek )
    return thisWeekDates
}

func getNextWeekDates() -> [Date]{
    let calendar = Calendar.current
    var startOfTheWeek = Date()
    var endOfWeek: Date!
    var interval = TimeInterval(0)
    let currentDate = addDaysToDate(date: Date())
    
    //calendar.rangeOfUnit(.WeekOfMonth, startDate: &startOfTheWeek, interval: &interval, forDate: currentDate)
    calendar.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for: currentDate)
    endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)
    let nextWeekDates = fetchDatesBetween(toDate: startOfTheWeek , fromDate: endOfWeek)
    return nextWeekDates as [Date]
}


func fetchDatesBetween(toDate:Date, fromDate:Date) -> [Date]{
    let calendar = Calendar.current
    
    // Formatter for printing the date, adjust it according to your needs:
    let fmt = DateFormatter()
    fmt.dateFormat = "dd/MM/yyyy"
    var dates = [Date]()
    // While date <= endDate ...
    var startDate = toDate
    while startDate.compare(fromDate as Date) != .orderedDescending {
        //        print(fmt.stringFromDate(toDate))
        // Advance by one day:
        dates.append(startDate)
        // startDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: startDate, options: [])!
        startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
    }
    return dates
}


func fetchDayAndDate(date:Date) -> (String,String){
    let fmt = DateFormatter()
    fmt.dateFormat = "EEEE"
    let day = fmt.string(from: date)
    fmt.dateFormat = "MM/dd"
    let date = fmt.string(from: date)
    return (day,date)
}

func fetchShortDayAndDate(date:Date) -> (String,String){
    let fmt = DateFormatter()
    fmt.dateFormat = "EE"
    let day = fmt.string(from: date)
    fmt.dateFormat = "MM/dd"
    let date = fmt.string(from: date)
    return (day,date)
}

func formattedTime(startTime:Date, duration:Int) ->String{
    let timePassed = abs(startTime.timeIntervalSinceNow)
    let durationInSec = duration * 60
    let timeRemaining = durationInSec - Int(timePassed)
    if timeRemaining > 0{
        let hours = timeRemaining/(60*60)
        let minutes = (timeRemaining%(60*60))/60
        let seconds = (timeRemaining%(60*60))%60
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    return "00:00:00"
}

func formattedTime(durationInSec:TimeInterval) ->String{
    let duration = Int(durationInSec)
    if duration > 0{
        let minutes = (duration%(60*60))/60
        let seconds = (duration%(60*60))%60
        return String(format: "%02d:%02d",minutes,seconds)
    }
    return "00:00"
}

func convertDateToTZFormat(date:Date) -> String{  //2013-03-29T15:27:00Z
    let timezone = NSTimeZone(abbreviation: "GMT")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timezone as TimeZone?
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}




func getDateFromFullTZString(date:String) -> Date?{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: date)
}

func getDateFromTZString(date:String) -> Date?{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    // 2021-03-20T00:00:00Z
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.date(from: date)
}


func convertStringToDate(date:String) -> Date{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: date)!
}

func getDateFromTZStringWithoutMS(date:String) -> Date{ //2013-03-29T15:27:00Z to
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.date(from: date)!
}

func getGMTDateFromTZStringWithoutMS(date:String) -> Date{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    let timezone = NSTimeZone(abbreviation: "GMT")
    dateFormatter.timeZone = timezone as TimeZone?
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.date(from: date)!
}

func dateWithoutTime(string:String) -> Date{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: string)!
}

func getTimeFromDate(date:Date) -> String{ //2013-03-29T15:27:00Z to 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm aa"
    return dateFormatter.string(from: date)
}

func fetchDateFromString(string:String) -> Date{ // 2013-03-29 15:27:00
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: string)!
}

func getStringFromDate(date:Date) -> String{ //24 January 2017
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    return dateFormatter.string(from: date)
}

func dateInddmmyy(date:Date) -> String{ 
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    return dateFormatter.string(from: date)
}


func getTimeStringFromDate(date:Date) -> String{ // inputDate: 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "HH:mm aa"
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func getGMTTimeStringFromDate(date:Date) -> String{ // inputDate: 2013-03-29 15:27:00 +0000
    let dateFormatter = DateFormatter()
    let timezone = NSTimeZone(abbreviation: "GMT")
    dateFormatter.timeZone = timezone as TimeZone?
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func getAllWeekDaysOFSelectedDate(date: Date) -> [Date] {
    var dates: [Date] = []
    guard let dateInterval = Calendar.current.dateInterval(of: .weekOfYear,
                                                           for: date) else {
        return dates
    }
    
    Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                    matching: DateComponents(hour:0),
                                    matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else {
                return
            }
            if date <= dateInterval.end {
                dates.append(date)
            } else {
                stop = true
            }
    }
    
    return dates
}

func localTimeZoneName() -> String{
    let timeZone = NSTimeZone.local;
    return timeZone.identifier
}

func fetchDateTimeZoneString(date:Date) -> String{
    let time = getStringFromDate(date: date)
    let timeZone = localTimeZoneName()
    return "\(time) \(timeZone)"
}

//MARK: - Directory Functions

func getDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

//MARK: - Alert Functions

func alertPromptToSettings(target: UIViewController, title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
    }
    alert.addAction(CancelAction)
    
    alert.addAction(okAction)
    
    target.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.black
}

func showAlertPopController(target:UIViewController,message:String?,title:String?,buttonTitle:String?){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) -> Void in
        target.navigationController!.popViewController(animated: true)
    }
    
    alert.addAction(okAction)
    target.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.black
}


func showAlert(target: UIViewController, message: String?, title: String?, buttonTitle: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(okAction)
    target.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.black
}


func showAlert(target: UIViewController, message: String?, title: String?, buttonTitle: String?, completionBlock:@escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
        completionBlock()
    }
    
    alert.addAction(okAction)
    target.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.black
}

func showAlert(target: UIViewController, message: String?, title: String?, buttonTitle: String?, buttonTitle2: String?, completionBlock:@escaping (Int) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action1 = UIAlertAction(title: buttonTitle, style: .default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
        completionBlock(1)
    }
    
    let action2 = UIAlertAction(title: buttonTitle2, style: .default) { (action) -> Void in
        alert.dismiss(animated: true, completion: nil)
        completionBlock(2)
    }
    alert.addAction(action1)    
    alert.addAction(action2)
    target.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.black
}


func showAlert(message: String?, title: String?) -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    return alert
}

func JSONString(object: JSON?) -> String? {
    return object as? String
}

func JSONInt(object: JSON?) -> Int? {
    return object as? Int
}

func JSONObject(object: JSON?) -> JSONDictionary? {
    return object as? JSONDictionary
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func displayTime (hours : Int, minutes: Int, seconds: Int) -> String {
    //    print(hours)
    //    print(minutes)
    //    print(seconds)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func setPlaceHolderText(text:String, color:UIColor, textField:UITextField){
    textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:placeHolderFont()])
}

func addTopBorderToView(view:UIView, height:CGFloat, color:UIColor){
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    bottomLayer.backgroundColor = color.cgColor
    view.layer.addSublayer(bottomLayer)
}

func addBottomBorderToView(view:UIView, height:CGFloat, color:UIColor){
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
    bottomLayer.backgroundColor = color.cgColor
    view.layer.addSublayer(bottomLayer)
}

func addBottomBorderToView(view:UIView){
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(x: 0, y: view.frame.height - 1.0, width: view.frame.width, height: 1.0)
    bottomLayer.backgroundColor = UIColor.darkGray.cgColor
    view.layer.addSublayer(bottomLayer)
}

func addBorder(view:UIView, withColor color:UIColor){
    view.layer.borderWidth = 1.0
    view.layer.borderColor = color.cgColor
}

func addBorder(view:UIView, withColor color:UIColor, borderHeight:CGFloat){
    view.layer.borderWidth = borderHeight
    view.layer.borderColor = color.cgColor
}

func addCornerRadius(view:UIView, radius:CGFloat){
    view.layoutIfNeeded()
    view.layer.cornerRadius = radius
    view.layer.masksToBounds = true
}

func addBottomBorderToView(view:UIView, color:UIColor){
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(x:0, y:view.frame.height - 1.0,width:view.frame.width,height:1.0)
    bottomLayer.backgroundColor = color.cgColor
    view.layer.addSublayer(bottomLayer)
}

//trim leading and trailing spaces/newlines in a string
func trimWhitespaces(text: String?) -> String{
    if let _ = text{
        let trimmedString = text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    return ""
}

//trim all spaces in a string
func containsWhiteSpaces(text: String?) -> Bool {
    if let _ = text{
        let whitespaces = NSCharacterSet.whitespaces
        let parts = text!.components(separatedBy: whitespaces)
        //let filteredArray = parts.filter({$0 != ""})
        if parts.count > 1 {
            return true
        } else {
            return false
        }
        //return filteredArray.joined(separator: "")
    }
    // no text - ""
    return true
}

func refineParamWithValue(val:String?) -> String?{
    var param:String? = nil
    if let _ = val{
        param = val!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    return param
}

func applicationDocumentsDirectory() -> String{
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return documentsPath
}


func enableView(view:UIView){
    view.alpha = 1.0
    view.isUserInteractionEnabled = true
}

func disableView(view:UIView){
    view.alpha = 0.6
    view.isUserInteractionEnabled = false
}

func isAppLaunchFirstTime() -> Bool{
    let flag = getUserDefault(key: UserDefaultKeys.kLaunchedFirstTime)
    if flag == nil{
        setUserDefault(key: UserDefaultKeys.kLaunchedFirstTime, forBoolValue: true)
        return true
    }
    else{
        return false
    }
}

func isExecutingFirstTime(key:String) -> Bool{
    let flag = getUserDefault(key: key)
    if flag == nil{
        return true
    }
    else{
        return false
    }
}

func resetUserDefaultKey(key:String){
    setUserDefault(key:key, forBoolValue: false)
}

func setUserDefaultKey(key:String){
    setUserDefault(key:key, forBoolValue: true)
}

func removeLocationNotification(localNotification:UILocalNotification){
    let app = UIApplication.shared
    app.cancelLocalNotification(localNotification)
}

func removeAllLocationNotification(){
    let app = UIApplication.shared
    app.cancelAllLocalNotifications()
}

func scheduleLocalNotification(date:NSDate,title:String,alertAction:String,userInfo:[String:String]){
    let notification = UILocalNotification()
    notification.fireDate = date as Date
    notification.alertBody = "You are on \(title) activity"
    notification.alertAction = alertAction
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = userInfo
    UIApplication.shared.scheduleLocalNotification(notification)
}

func addBGImage(view:UIView){
    UIGraphicsBeginImageContext(view.frame.size)
    UIImage(named: "background_screen")?.draw(in: view.bounds)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    view.backgroundColor = UIColor(patternImage: image)
}

func addBGImageWithOverlay(view:UIView, image:UIImage){
    let subView = view.viewWithTag(101)
    if let _ = subView{
        subView?.removeFromSuperview()
    }
    
    UIGraphicsBeginImageContext(view.frame.size)
    image.draw(in: view.bounds)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    view.backgroundColor = UIColor(patternImage: image)
    
    let overLayImageView = UIImageView(frame: view.bounds)
    overLayImageView.image = UIImage(named: "bg_overlay")
    overLayImageView.alpha = 0.5
    overLayImageView.tag = 101
    view.insertSubview(overLayImageView, at: 0)
}

func addBGImageWithoutOverlay(view:UIView, image:UIImage){
    let subView = view.viewWithTag(101)
    if let _ = subView{
        subView?.removeFromSuperview()
    }
    
    let subView2 = view.viewWithTag(102)
    if let _ = subView2{
        subView2?.removeFromSuperview()
    }
    UIGraphicsBeginImageContext(view.frame.size)
    image.draw(in: view.bounds)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    view.backgroundColor = UIColor(patternImage: image)
}

func addBGImageWithBlackOverlay(view:UIView, image:UIImage, enablePurpleOverlay:Bool){
    //    if this method is called multiple times then we remove the previous overlay
    let subView = view.viewWithTag(101)
    if let _ = subView{
        subView?.removeFromSuperview()
    }
    
    let subView2 = view.viewWithTag(102)
    if let _ = subView2{
        subView2?.removeFromSuperview()
    }
    
    UIGraphicsBeginImageContext(view.frame.size)
    image.draw(in: view.bounds)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    view.backgroundColor = UIColor(patternImage: image)
    
    //    first overlay
    let overLayImageView = UIView(frame: view.frame)
    overLayImageView.backgroundColor = UIColor.black
    overLayImageView.alpha = 0.7
    overLayImageView.tag = 101
    view.insertSubview(overLayImageView, at: 0)
    
    // second overlay
    if enablePurpleOverlay{
        let overLayImageView = UIView(frame: view.frame)
        overLayImageView.backgroundColor = UIColor.black
        overLayImageView.alpha = 0.4
        overLayImageView.tag = 102
        view.insertSubview(overLayImageView, at: 1)
    }
}

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    //  dispatch_async(DispatchQueue.global(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
    //     if(background != nil){ background!() }
    
    //  let popTime = DispatchTime.now(DispatchTime.now, Int64(delay * Double(NSEC_PER_SEC)))
    //   dispatch_after(popTime, DispatchQueue.main) {
    //     if(completion != nil){ completion!(); }
    //}
    //}
    
    
}

func osVersion() -> String{
    let systemVersion = UIDevice.current.systemVersion;
    return systemVersion
}

func isSubscriptionExpiryDateValid(expiryDate:NSDate) -> Bool{
    if expiryDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending{
        return true
    }
    return false
}

func fetchInitials(firstName:String, lastName:String?) -> String{
    if lastName != nil && !(lastName?.isEmpty)! {
        //let fChar = String(firstName.characters.first!).uppercased
        let fChar = String(firstName.first!).uppercased()
        let lChar = String(lastName!.first!).uppercased()
        return "\(fChar)\(lChar)"
    }
    else{
        let fChar = String(firstName.first!).uppercased()
        return "\(fChar)"
    }
}


func isSuccessful(responseObject:[String:AnyObject]?) -> Bool{
    if let _ = responseObject![ServerResponseKey.SUCCESS]{
        if let result  = responseObject![ServerResponseKey.SUCCESS] as? String{
            return result == "true" ? true : false
        }
        else{
            return false
        }
    }
    return false
}

func animate(duration:Double,delay:Double, options:UIView.AnimationOptions, animationBlock:@escaping () -> Void, completionBlock: @escaping () -> Void){
    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
        animationBlock()
    }, completion: {(finished:Bool) in
        completionBlock()
    })
}

func isSuccessful(responseObject:[String:AnyObject]) -> Bool{
    if let _ = responseObject[ServerResponseKey.SUCCESS]{
        if let result  = responseObject[ServerResponseKey.SUCCESS] as? String{
            return result.toBool()!
        }
        else{
            let result  = responseObject[ServerResponseKey.SUCCESS] as! Int
            return result.toBool()!
        }
    }
    return false
}

func validateServerResponse(response:AlamofireAPIResponse) -> (Bool, JSONDictionary?){
    if response.isSuccessful{
        let responseObject = response.responseObject as? JSONDictionary
        if responseObject != nil && isSuccessful(responseObject: responseObject){
            return (true, responseObject)
        }
        else{
            if let _ = responseObject{
                if let error = responseObject!["error"] as? JSONDictionary{
                    let errorCode = error["code"] as? Int
                    let errorMsg = error["message"] as? String
                    if let _ =  errorCode{
                        return (false, ["msg":errorMsg! as AnyObject])
                    }
                }
                else{
                    return (false, ["msg":Constants.Error.generalMsg as AnyObject])
                }
            }
            else{
                return (false, ["msg":Constants.Error.generalMsg as AnyObject])
            }
            return (false, responseObject)
        }
    }
    else{
        return (false,["msg":Constants.Error.generalMsg as AnyObject])
    }
}

func convertNumberToFomrmatedNumerString(unformattedValue: Double) -> String {
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal // or .decimal if desired
    formatter.maximumFractionDigits = 2; //change as desired
    formatter.locale = .current
    let displayValue : String = formatter.string(from: NSNumber(value: unformattedValue))! // displayValue: "$3,534,235" ```
    return displayValue
}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}


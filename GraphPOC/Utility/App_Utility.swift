//
//  App_Utility.swift
//  stompsessions
//
//  Created by Bitcot Inc on 12/19/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


public func fetchName(firstName:String, lastName:String?) -> String{
    if lastName != nil && !(lastName?.isEmpty)! {
        return firstName + " " + lastName!
    }
    else{
        return "\(firstName)"
    }
}

func getTimeString(dateTimeString: String) -> String{
    // create dateFormatter with UTC time format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: dateTimeString)
    
    // change to a readable time format and change to local time zone
    dateFormatter.dateFormat = "HH:mm aa"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date!)
    
    return timeStamp
}

func getDateFromTZString(string:String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: string)
    
    return date!
}


func convertSeconds(totalSeconds: Int) -> (min:Int, sec:Int){
    let seconds = totalSeconds % 60
    let minutes = (totalSeconds / 60)
    return (minutes, seconds)
}

func timeToString(min:Int, sec:Int) -> (min:String, sec:String) {
    let minString = String(format: "%03d", min)
    let secString = String(format: "%02d", sec)
    return (minString, secString)
}

func generateThumbImage(url : URL) -> UIImage{
    let asset : AVAsset = AVAsset.init(url: url)
    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    let time        : CMTime = CMTimeMake(value: 1, timescale: 30)
    var img:CGImage!
    do{
        img =  try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }catch{
        
    }
    let frameImg    : UIImage = UIImage(cgImage: img)
    return frameImg
}


func fetchLastComponentFrom(url:String) -> String{
    let arr = url.components(separatedBy: "/")
    return arr.last!
}

func downloadedFrom(url: URL, completionBlock:@escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
        DispatchQueue.main.async() { () -> Void in
            completionBlock(image)
        }
        }.resume()
}

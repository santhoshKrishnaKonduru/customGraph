//
//  User.swift
//  CommonLib
//
//  Created by Prakash Mali on 11/3/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import Foundation
import ObjectMapper

class User: NSObject, Mappable, Codable {
    
    var userID: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var role: String?
    var photoPath:String?
    var photoURL: PhotoURL?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        role <- map["role"]
        photoPath <- map["photoPath"]
        photoURL <- map["photo_url"]
    }
}

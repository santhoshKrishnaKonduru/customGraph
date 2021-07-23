//
//  PhotoUrl.swift
//  CommonLib
//
//  Created by Prakash Mali on 11/3/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import Foundation
import ObjectMapper

class PhotoURL: NSObject, Mappable, Codable {
    var original: URL?
    var medium: URL?
    var small: URL?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        original <- (map["original"], URLTransform())
        medium <- (map["medium"], URLTransform())
        small <- (map["small"], URLTransform())
    }
}

//
//  Country.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 19/03/21.
//

import Foundation
import ObjectMapper

class Country: NSObject, Mappable {
    
    var name: String?
    var slug: String?
    var ISO2: String?
    var countryFlag: UIImage?
 
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["Country"]
        slug <- map["Slug"]
        ISO2 <- map["ISO2"]
    }
}

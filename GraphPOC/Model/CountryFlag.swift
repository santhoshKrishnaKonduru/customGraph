//
//  CountryFlag.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 21/03/21.
//

import Foundation
import ObjectMapper

class CountryFlag: Mappable {
  
    var name: String?
    var alpha2Code: String?
    var alpha3Code: String?
    var capital: String?
    var flag: URL?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        alpha2Code <- map["name"]
        alpha3Code <- map["alpha3Code"]
        capital <- map["capital"]
        if let urlString = map["flag"].currentValue as? String {
            flag = URL(string: urlString)
        }
    }
    
    
}

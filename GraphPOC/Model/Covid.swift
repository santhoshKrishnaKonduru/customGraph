//
//  Covid.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 19/03/21.
//

import Foundation
import ObjectMapper

class Covid: NSObject,Mappable {
    
    var countryName: String?
    var CountryCode: String?
    var Lat: String?
    var Lon: String?
    var Confirmed: Double?
    var Deaths: Double?
    var Recovered: Double?
    var Active: Double?
    var Date: Date?
    var LocationID: String?
    var NewConfirmed: Double?
    var NewDeaths: Double?
    var NewRecovered: Double?
    var ID: String?
    var Province: String?
    var CityCode: String?
    var City: String?
    var currentConfirmed: Double?
    var currentRecovered: Double?
    var currentDeaths: Double?
    var dateString: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        countryName <- map["Country"]
        CountryCode <- map["CountryCode"]
        Lat <- map["Lat"]
        Lon <- map["Lon"]
        Confirmed <- map["Confirmed"]
        Deaths <- map["Deaths"]
        Recovered <- map["Recovered"]
        Active <- map["Active"]
        if let dateString = map["Date"].currentValue as? String {
            Date = getDateFromTZString(date: dateString)
            
            if Date == nil {
                Date = getDateFromFullTZString(date: dateString)
            }
            
            if Date == nil {
                print("date is nill")
            }else {
                self.dateString = Date?.startDateOfTheDay().nextClassDateFormat()
            }
        }
        LocationID <- map["LocationID"]
        ID <- map["ID"]
        Province <- map["Province"]
        CityCode <- map["CountryCode"]
        City <- map["City"]
    }
}

class FullData: NSObject, NSCopying {
    
    var country: Country?
    var TotalConfirmed: Double?
    var countryName: String?
    var covidData: [Covid]?
    var TotalDeaths: Double?
    var TotalRecover: Double?
    var graphColor: UIColor?
    var lineLayers: [CAShapeLayer]?
    var roundedViews: [UIView]?
    var barViews: [UIView]?
    var defaultBarViews: [UIView]?
    var flagViews: [UIImageView]?
    var lat: String?
    var long: String?
    var recoverdRoundViews: [UIView]?
    var recoverdLineLayers: [CAShapeLayer]?
    
    var deathsRoundViews: [UIView]?
    var deathsLineLayers: [CAShapeLayer]?
    
    override init(){
        
    }
    
    init(country: Country?, TotalConfirmed: Double?, covidData: [Covid]?, graphColor: UIColor?, countryName:String?, TotalRecover:Double?, TotalDeaths:Double?, lat: String?, long: String?) {
        self.country = country
        self.TotalConfirmed = TotalConfirmed
        self.covidData = covidData
        self.graphColor = graphColor
        self.countryName = countryName
        self.TotalRecover = TotalRecover
        self.TotalDeaths = TotalDeaths
        self.lat = lat
        self.long = long
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy =  FullData(country: country, TotalConfirmed: TotalConfirmed, covidData: covidData, graphColor: graphColor, countryName: countryName, TotalRecover: TotalRecover, TotalDeaths: TotalDeaths, lat: lat, long: long)
       return copy
    }
}

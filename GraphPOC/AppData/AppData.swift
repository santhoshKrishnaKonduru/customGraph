//
//  AppData.swift
//  aboutairportparking
//
//  Created by Bitcot Inc on 6/7/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
import ObjectMapper

class AppData: NSObject {
    
    //static let sharedInstance = AppData()
    
    private static var privateShared : AppData?
    
    
    static var sharedInstance: AppData {
        if privateShared == nil { privateShared = AppData() }
        return privateShared!
    }
    
    var countries: [Country]?
    
    var filterdCountries: [Country]?
    
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    
    var totalCovidData = [FullData]()
    var currentIndex = 0
    var countryFlags = [CountryFlag]()
    var covidDataCompletionBlock: (() -> Void)!
    var graphColors = [#colorLiteral(red: 0.09019607843, green: 0.5333333333, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.3529411765, blue: 0.137254902, alpha: 1), #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)]
    
    func logout(){
//        AppData.privateShared = nil
    }
    
    
    
}

extension AppData {
    
    func refreshCovidData(completion: (() -> ())? = nil) {
        totalCovidData.removeAll() // resetting data
        self.getWorldCovidData(completion: completion)
    }
    
    func getWorldCovidData(completion: (() -> ())? = nil) {
        if covidDataCompletionBlock == nil {
            covidDataCompletionBlock = completion
        }
        if let country = self.filterdCountries?[safe: currentIndex] {
            currentIndex = currentIndex + 1
            getCovidData(by: country) { data in
                if let totalData = data {
                    self.totalCovidData.append(totalData)
                }
                self.getWorldCovidData()
            }
        }else {
            currentIndex = 0
            print("fetched covid data for counties", totalCovidData.count)
//            if !(MainClass.appdelegate?.refreshData ?? Bool()){
                covidDataCompletionBlock?()
//            }
           
        }
    }
    
    func getCovidData(by country: Country, completion: ((_ totalData: FullData?) -> ())? = nil) {
        let monthDates = Date().getAllDays()
        let startDate = monthDates.first!.startDateOfTheDay().convertDateToTZFormat()
        let endDate = monthDates.last!.startDateOfTheDay().convertDateToTZFormat()
      //  print("getting covid data for", country.name, "and in range of", "\(monthDates.first!.startDateOfTheDay().convertToDate()) - \(monthDates.last!.startDateOfTheDay().convertToDate())")
        guard let slug = country.slug else {
            completion?(nil)
            return
        }
        apiWrapper.getCovidDataStatus(of: slug, fromDate: startDate, toDate: endDate) { (response) in
            if let jsonArray = response.responseObject as? JSONArray, jsonArray.count > 0 {
                self.loadCovidDataResponse(response: jsonArray, country: country, completion: completion)
            }else {
                completion?(nil)
            }
        }

    }
    
    func loadCovidDataResponse(response: JSONArray, country: Country, completion: ((_ totalData: FullData?) -> ())? = nil) {
        var covidData = Mapper<Covid>().mapArray(JSONObject: response)
        if covidData?.count == 0 {
            completion?(nil)
            return
        }
        let totaldata = FullData()
        totaldata.country = country
        
        covidData = covidData?.filterDuplicates(includeElement: { (session1, session2) -> Bool in
            return session1.Date?.startDateOfTheDay() == session2.Date?.startDateOfTheDay()
        })
        
        covidData = covidData?.sorted(by: { (session1, session2) -> Bool in
            return session1.Date?.compare(session2.Date ?? Date()) == .orderedAscending
        })
        
     
        if let previousData = covidData?.first {
            covidData?[0].currentConfirmed = (previousData.Confirmed ?? 0)
            covidData?[0].currentRecovered = (previousData.Recovered ?? 0)
            covidData?[0].currentDeaths = (previousData.Deaths ?? 0)
        }
        
        for (index, currentDate) in (covidData ?? []).enumerated() {
            if let nextDate = covidData?[safe: index + 1] {
                
                if nextDate.Confirmed ?? 0 > 0 {
//                    print("some data")
                }
                
                nextDate.currentConfirmed = (nextDate.Confirmed ?? 0) - (currentDate.Confirmed ?? 0)
                nextDate.currentRecovered = (nextDate.Recovered ?? 0) - (currentDate.Recovered ?? 0)
                nextDate.currentDeaths = (nextDate.Deaths ?? 0) - (currentDate.Deaths ?? 0)
                nextDate.countryName = currentDate.countryName
                nextDate.Lat = currentDate.Lat
                nextDate.Lon = currentDate.Lon
            }
        }
        totaldata.covidData = covidData
        totaldata.TotalConfirmed = (covidData?.last?.Confirmed ?? 0) - (covidData?.first?.Confirmed ?? 0)
        
        totaldata.graphColor = graphColors.shuffled().first!
        let imageURL = URL(string: "https://flagcdn.com/w20/\(country.ISO2?.lowercased() ?? "").png")
        
        if let url = imageURL {
            getData(from: url) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print("no image found")
                        completion?(totaldata)
                        return
                    }
                    print("image downloaded successfully")
                    totaldata.country?.countryFlag = UIImage(data: data)
                    completion?(totaldata)
                }
            }
        }else {
            print("no image found")
            completion?(totaldata)
        }
        
    }
    
    
    func getCovidDataFromSelectedDateRange(date: Date, dateType: SleepTrrendState) -> [FullData] {
        
        var tempCovidData = [FullData]()
        for data in totalCovidData {
            let covidData = data.covidData!
            let tempData = data.copy() as! FullData

            
            var filterdData = [Covid]()
            
            var totalDates = [Date]()
            
            if dateType == .week {
                totalDates = getAllWeekDaysOFSelectedDate(date: date)
            }else {
                totalDates = date.getAllDays()
            }
            let startDate = totalDates.first!.startDateOfTheDay()
            let endDate = totalDates.last!.startDateOfTheDay()

            filterdData = covidData.filter({ (covid) -> Bool in
                guard let date = covid.Date?.startDateOfTheDay() else {
                    return false
                }
    
                let range = startDate...endDate
                return range.contains(date.startDateOfTheDay())
            })
            tempData.TotalConfirmed = (filterdData.last?.Confirmed ?? 0) - (covidData.first?.Confirmed ?? 0)
            tempData.TotalDeaths = (filterdData.last?.Deaths ?? 0 - (covidData.first?.Deaths)! )
            tempData.TotalRecover = (filterdData.last?.Recovered ?? 0 - (covidData.first?.Recovered)! )
            tempData.countryName = filterdData.last?.countryName
            tempData.lat = filterdData.last?.Lat
            tempData.long = filterdData.last?.Lon
            tempData.covidData = filterdData
            tempCovidData.append(tempData)
        }
        
        return tempCovidData
        
    }
    
}

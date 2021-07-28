//
//  DataBaseHelper.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 27/07/21.
//

import Foundation
import CoreData
import UIKit


class DataBaseHelper {
    static let sharedInstance = DataBaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveData(_ data: FullData, handler: (String) -> Void){
        let selectedCovidData = NSEntityDescription.insertNewObject(forEntityName: "CovidData", into: context!) as! CovidData
        selectedCovidData.countryName = data.countryName
        selectedCovidData.iso = data.country?.ISO2
        selectedCovidData.confirmedCase = data.TotalConfirmed!
        selectedCovidData.death = data.TotalDeaths!
        selectedCovidData.recover = data.TotalRecover!
        do{
            try context!.save()
            handler("Save")
        }catch{
            handler("Not Save")
        }
    }
    
    func fetchCovidData() -> [CovidData]{
        var CovidData = [CovidData]()
        let fatchRequest = NSFetchRequest<NSManagedObject>(entityName: "CovidData")
        do{
            CovidData =  try context?.fetch(fatchRequest) as? [CovidData] ?? []
            
        }catch{
            print("can not get data")
        }
         return CovidData
    }
}

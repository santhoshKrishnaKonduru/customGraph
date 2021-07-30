//
//  CustomMarkerView.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 26/07/21.
//

import UIKit
import Foundation
import CoreLocation

class CustomMarkerView: UIView {
//MARK: Outlets
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblTotalCase: UILabel!
    @IBOutlet weak var lblTotalDeath: UILabel!
    @IBOutlet weak var lblTotalRecover: UILabel!
    @IBOutlet weak var btnAddIntoList: UIButton!
    
    func setCustomMarkerViewdata(_ placeMark: [Covid]){
        self.lblCountryName.text = placeMark.last?.countryName
        self.lblTotalCase.text = "Total Cases:  \(placeMark.last?.Confirmed ?? 0.0)"
        self.lblFlag.text = self.flag(from: placeMark.last?.CountryCode ?? "🏳️")
        self.lblTotalDeath.text = "Deaths:   \(placeMark.last?.Deaths ?? 0.0)"
        self.lblTotalRecover.text = "Recovers   \(placeMark.last?.Recovered ?? 0.0)"
        self.btnAddIntoList.setCornerForButton(8)
        self.setCornerForButton(8)
//        self.btnAddIntoList.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
       // self.addShadow(color: .white)
       // self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}

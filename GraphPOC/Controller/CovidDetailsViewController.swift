//
//  CovidDetailsViewController.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 21/03/21.
//

import UIKit

class CovidDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var totalCasesLabel: UILabel!
    
    var selectedCovidData: FullData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setData() {
        imageView.image = selectedCovidData.country?.countryFlag
        countryLabel.text = "Country: \(selectedCovidData.country?.name ?? "")"
        totalCasesLabel.text = "Totel cases: \(selectedCovidData.TotalConfirmed ?? 0)"
    }
    
    
}

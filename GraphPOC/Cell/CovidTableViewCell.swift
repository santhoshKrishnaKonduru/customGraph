//
//  CellCovidTableViewCell.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 27/07/21.
//

import UIKit

class CovidTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblTotalconfirmed: UILabel!
    @IBOutlet weak var lblTotalDeath: UILabel!
    @IBOutlet weak var lblTotalRecover: UILabel!
    
    
    //MARK: variables
    var VC =  SelectedCovidDataVC()
    var coviData: CovidData?{
        didSet{
            self.lblCountryName.text = self.coviData?.countryName
            self.lblFlag.text = self.VC.flag(from: self.coviData?.iso ?? "")
            self.lblTotalconfirmed.text = "Total Case:    \(self.coviData?.confirmedCase ?? 0.0)"
            self.lblTotalDeath.text = "Total death:    \(self.coviData?.death ?? 0.0)"
            self.lblTotalRecover.text = "Total Recover:    \(self.coviData?.recover ?? 0.0)"
        }
    }
    
    //MARK: Default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

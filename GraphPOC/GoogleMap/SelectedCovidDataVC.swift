//
//  SelectedCovidDataVC.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 27/07/21.
//

import UIKit

class SelectedCovidDataVC: BaseViewController {
    
    //MARK: Variables
    @IBOutlet weak var tblCovid: UITableView!
    
    var arrCovidData = [CovidData](){
        didSet{
            DispatchQueue.main.async {
                self.tblCovid.reloadData()
            }
        }
    }

    //MARK: default function
    override func viewDidLoad() {
        super.viewDidLoad()

        self.arrCovidData = DataBaseHelper.sharedInstance.fetchCovidData()
        // Do any additional setup after loading the view.
    }


}

extension SelectedCovidDataVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCovidData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCovid.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

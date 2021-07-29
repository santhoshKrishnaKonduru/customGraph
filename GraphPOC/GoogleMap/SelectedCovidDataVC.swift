//
//  SelectedCovidDataVC.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 27/07/21.
//

import UIKit

class SelectedCovidDataVC: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var tblCovid: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: Variables
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
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
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        self.tblCovid.tableFooterView = UIView()
        self.arrCovidData = DataBaseHelper.sharedInstance.fetchCovidData()
        if self.arrCovidData.count == 0{
            self.lblNoData.text = "No data found"
            self.lblNoData.isHidden = false
        }else{
            self.lblNoData.text = ""
            self.lblNoData.isHidden = true
        }
    }

    @IBAction func btnBackAction(_ sender: UIButton){
        self.dismiss(animated: true)
    }
   
    

}
//MARK: UITableViewDelegate, UITableViewDataSource
extension SelectedCovidDataVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCovidData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCovid.dequeueReusableCell(withIdentifier: "CovidTableViewCell", for: indexPath) as! CovidTableViewCell
        cell.VC = self
        cell.coviData = self.arrCovidData[indexPath.row]
        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

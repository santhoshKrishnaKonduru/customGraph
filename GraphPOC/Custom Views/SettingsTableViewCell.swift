//
//  SettingsTableViewCell.swift
//  CommonLib
//
//  Created by BITCOT on 22/10/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsImageView: UIImageView!    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func addBottomBorderr(color:UIColor,size:CGFloat) -> CALayer{
//        let bottomLayer:CALayer =  CALayer()
//        bottomLayer.backgroundColor =  color.cgColor
//        bottomLayer.frame =  CGRect(x: 0, y: frame.size.height, width: frame.width, height: size)
//        self.layer.addSublayer(bottomLayer)
//        return bottomLayer
//    }
    
}

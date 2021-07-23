//
//  UserDetailsView.swift
//  CommonLib
//
//  Created by Prakash Mali on 10/22/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import UIKit

class UserDetailsView: UIView {
    
    let kContext_Xib_Name = "UserDetailsView"
        
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textFieldView: UITextField!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(kContext_Xib_Name, owner: self, options: nil)
    }

}

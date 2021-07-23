//
//  CustomGalleryCell.swift
//  CommonLib
//
//  Created by BITCOT on 09/11/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import UIKit

class CustomGalleryCell: UICollectionViewCell {
    static let identifier = String(describing: CustomGalleryCell.self)
    @IBOutlet weak var checkMarkButtonOutlet: UIButton!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkMarkButtonPressed(_ sender: UIButton) {
    }
}

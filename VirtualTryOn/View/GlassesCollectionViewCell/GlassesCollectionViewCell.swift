//
//  GlassesCollectionViewCell.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

class GlassesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var glassImageView: UIImageView!
    @IBOutlet weak var glassName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func likeButtonAction(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
    }
}

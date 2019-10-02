//
//  VirtualTryOnCollectionViewCell.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 08/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

class VirtualTryOnCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var glassName: UILabel!
    @IBOutlet weak var glassImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func likeAction(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
    }
}

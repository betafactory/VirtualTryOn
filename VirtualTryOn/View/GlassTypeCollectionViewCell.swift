//
//  GlassTypeCollectionViewCell.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

protocol GlassTypeCellDelegate: class {
    func glassClicked(glassName: String)
}

class GlassTypeCollectionViewCell: UICollectionViewCell {
    
    var delegate: GlassTypeCellDelegate?
    
    var selectedIndex: Int = 0
    lazy var glassCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "glassesCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(glassCollectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: glassCollectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: glassCollectionView)
        glassCollectionView.register(GlassesCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        glassCollectionView.register(UINib(nibName: "GlassesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GlassTypeCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return Constants.Images.EyeGlassesImages.count

        } else {
            return Constants.Images.SunGlassesImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GlassesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GlassesCollectionViewCell
        
        cell.glassImageView.image = UIImage(named: selectedIndex == 0 ? Constants.Images.EyeGlassesImages[indexPath.item] : Constants.Images.SunGlassesImages[indexPath.item])
        cell.glassName.text = selectedIndex == 0 ? Constants.Images.EyeGlassesImages[indexPath.item] : Constants.Images.SunGlassesImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
             delegate.glassClicked(glassName: selectedIndex == 0 ? Constants.Images.EyeGlassesImages[indexPath.item] : Constants.Images.SunGlassesImages[indexPath.item])
        }
    }
}

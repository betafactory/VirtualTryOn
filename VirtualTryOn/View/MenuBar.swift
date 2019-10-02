//
//  MenuBar.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import Foundation
import UIKit

class MenuBar: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "menuCell")
        cv.dataSource = self
        cv.delegate = self
        var nibName = UINib(nibName: "MenuCollectionViewCell", bundle:nil)
        cv.register(nibName, forCellWithReuseIdentifier: "menuCell")
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var shopGlassesViewController: ShopGlassesViewController?
    let horizontalBarView = UIView()
    let titles = ["Eyeglasses","Sunglasses"]
    
    var horizontalBarViewLeftAnchorConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCollectionView()
        self.setupHorizontalBar()
        self.horizontalBarViewLeftAnchorConstraint?.constant = self.frame.width / 2 - 120
    }
    
    func setupHorizontalBar() {
        horizontalBarView.backgroundColor = .black
        addSubview(horizontalBarView)
         horizontalBarViewLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width/2 + 10 )
        horizontalBarViewLeftAnchorConstraint?.isActive = true
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3.6).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func setupCollectionView() {
        addSubview(menuCollectionView)

        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: menuCollectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: menuCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        cell.cellTitle.text = titles[indexPath.row]
        if(indexPath.row == 0) {
            cell.cellTitle.textAlignment = .right
            cell.backgroundColor = .red
            cell.cellTitle.backgroundColor = .clear
           
        } else {
            cell.cellTitle.textAlignment = .left
            cell.backgroundColor = .blue
            cell.cellTitle.backgroundColor = .clear
           
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 20) / 2, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if(indexPath.row == 0) {
//            self.horizontalBarViewLeftAnchorConstraint?.constant = self.frame.width / 2 - 120
//        } else {
//            self.horizontalBarViewLeftAnchorConstraint?.constant = self.frame.width / 2  + 10
//        }
//
//        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        shopGlassesViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
}

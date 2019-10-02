//
//  ShopGlassesViewController.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

class ShopGlassesViewController: UIViewController {
    
    @IBOutlet weak var glassesCollectionView: UICollectionView!
    @IBOutlet weak var menuBar: MenuBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.hidesBarsOnSwipe = true
        glassesCollectionView.register(GlassTypeCollectionViewCell.self, forCellWithReuseIdentifier: "glassTypeCell")
        glassesCollectionView.register(UINib(nibName: "GlassTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "glassesCell")
        let layout = UICollectionViewFlowLayout()
        glassesCollectionView.collectionViewLayout = layout
        glassesCollectionView.isPagingEnabled = true
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        menuBar.shopGlassesViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.handleBackButtonAndNavigationBar()
    }
    
    fileprivate func handleBackButtonAndNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let backImage = UIImage(named: "left-arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopGlassesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GlassTypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "glassTypeCell", for: indexPath) as! GlassTypeCollectionViewCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 120)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index: Int = 0
        if(scrollView.contentOffset.x < 160) {
            menuBar.horizontalBarViewLeftAnchorConstraint?.constant = view.frame.width / 2 - 120
            index = 0
        } else {
            menuBar.horizontalBarViewLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2 + 10
            index = 1
        }
        self.updateData(index)
    }
    
    func updateData(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell: GlassTypeCollectionViewCell = glassesCollectionView.cellForItem(at: indexPath) as! GlassTypeCollectionViewCell
        cell.selectedIndex = index
        cell.glassCollectionView.reloadData()
    }
}

extension ShopGlassesViewController {
    public func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        glassesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ShopGlassesViewController: GlassTypeCellDelegate {
    func glassClicked(glassName: String) {
        self.performSegue(withIdentifier: "chooseGlassSegue", sender: glassName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseGlassSegue" {
        
            let selectedGlassViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectedGlassViewController") as! SelectedGlassViewController
            
           let vc = segue.destination as! VirtualTryOnViewController
            vc.selectedGlassViewController = selectedGlassViewController
            vc.choosenGlassName = sender as? String
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.navigationBar.isHidden = true
        }
    }
}

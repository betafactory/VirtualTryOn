//
//  SelectedGlassViewController.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 08/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

protocol GlassesBottomSheetDelegate: class {
    func glassSelected(glassName: String)
    func closeBottomSheet()
}

class SelectedGlassViewController: UIViewController, UIScrollViewDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var selectedGlassesView: UIView!
    @IBOutlet weak var glassCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var glassesCollectionView: UICollectionView!
    
    
    var choosenGlassName: String!
    var sheet: PullableSheet!
    var state: State = .open
    var delegate: GlassesBottomSheetDelegate!
    var images = ["eye_glasses_1", "eye_glasses_2", "eye_glasses_3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var virtualTryOnVC: VirtualTryOnViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glassesCollectionView.isHidden = true
        glassesCollectionView.showsHorizontalScrollIndicator = false
        virtualTryOnVC.bottomSheetScrollDelegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        glassesCollectionView.isPagingEnabled = true
        glassesCollectionView.register(VirtualTryOnCollectionViewCell.self, forCellWithReuseIdentifier: "glassCell")
        glassesCollectionView.register(UINib(nibName: "VirtualTryOnCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "glassCell")
        glassesCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        pageControl.numberOfPages = images.count
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = .lightGray
        for i in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(image: UIImage(named: i == 0 ? choosenGlassName : images[i]))
            imageView.frame = CGRect(x: CGFloat(i) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(images.count) * scrollView.frame.width, height: 180)
    }
    
    //MARK: - Actions
    
    @IBAction func closeBottomSheetAction(_ sender: Any) {
        delegate.closeBottomSheet()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = -1
        if state == .open {
            pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = pageNumber
        } else if state == .partialOpen {
            pageNumber = Int(scrollView.contentOffset.x / glassesCollectionView.frame.size.width)
            delegate.glassSelected(glassName: Constants.Images.EyeGlassesImages[pageNumber])
        }
       
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension SelectedGlassViewController: BottomSheetScrollDelegate {
    func bottomSheetScrollingEnded(state: State) {
        self.state = state
        if state == .partialOpen {
            selectedGlassesView.isHidden = true
            glassesCollectionView.isHidden = false
            glassCollectionViewHeightConstraint.constant = 250
        } else {
            selectedGlassesView.isHidden = false
            glassesCollectionView.isHidden = true
        }
    }
}

extension SelectedGlassViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.Images.EyeGlassesImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VirtualTryOnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "glassCell", for: indexPath) as! VirtualTryOnCollectionViewCell
        cell.glassImageView.image = UIImage(named: Constants.Images.EyeGlassesImages[indexPath.item])
        cell.glassName.text = Constants.Images.EyeGlassesImages[indexPath.item]
        return cell
    }
    
    
}

extension SelectedGlassViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: view.frame.size.width - 20, height: 250)
    }
}

extension SelectedGlassViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = glassesCollectionView.frame.size.width - 20
        
        let numberOfCells = floor(glassesCollectionView.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
}

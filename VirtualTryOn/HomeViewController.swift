//
//  HomeViewController.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 07/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func shopGlassesButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "shopGlassesSegue", sender: nil)
    }
    
    override func viewWillLayoutSubviews() {
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


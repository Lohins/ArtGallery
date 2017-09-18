//
//  AGWelcomeViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-22.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu



class AGWelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    var timer : Timer!
    
    @IBOutlet weak var activityindicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize user role
        UserDefaults.standard.set("Initial", forKey: "AGRole")
    
        activityindicatorView.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(start), userInfo: nil, repeats: false)
        
        //testBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.textLabel.text = String.localizedString( "AGWelcomeViewController-Description")
        
    }
    
    func start(){

        let homeVC = AGHomeViewController()
        activityindicatorView.stopAnimating()
        self.navigationController?.pushViewController(homeVC, animated: true)

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AGWelcomeViewController: SlideNavigationControllerDelegate{
    
}

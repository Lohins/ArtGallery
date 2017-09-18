//
//  AGVisitorActionRequiredViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-10-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGVisitorActionRequiredViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backHomeAction(_ sender: UIButton) {
        //_ sender: UIButton

        let loginVC = getLoginVC()
        self.dismiss(animated: true, completion: nil)
        SlideNavigationController.sharedInstance().popToViewController(loginVC!, animated: true)
        
        
    }
    
    // 获取 之前的登陆 视图控制器， 然后 pop到那个视图控制器上面。
    func getLoginVC() -> UIViewController?{
        let vcs = SlideNavigationController.sharedInstance().viewControllers 
        
        for vc in vcs{
            if vc.isKind(of: AGVisitorLoginViewController.classForCoder()) || vc.isKind(of: AGArtistLoginViewController.classForCoder()){
                print("Got it")
                return vc
            }
        }
        return nil

    }
}



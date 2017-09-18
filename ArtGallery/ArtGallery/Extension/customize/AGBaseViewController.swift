//
//  AGBaseViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-29.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AGBaseViewController: SlideNavigationControllerDelegate{
    
}

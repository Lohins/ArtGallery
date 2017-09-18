//
//  AGArtistActionRequiredVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistActionRequiredVC: UIViewController {
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LanguageStandardization()
    }
    
    // 更新语言
    func LanguageStandardization(){
        
        let ClassName = String.init(describing: type(of : self))
        
        self.actionLabel.text = String.localizedString(ClassName + "-Action")
        self.descriptionLabel.text = String.localizedString(ClassName + "-Description")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

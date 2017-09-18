//
//  AGHomeViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-22.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGHomeViewController: UIViewController {
    
    @IBOutlet weak var seearoundLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        let frame_width = GlobalValue.SCREENBOUND.width
        let frame_height = GlobalValue.SCREENBOUND.height
        // logo
        let iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: frame_height * 0.12, width: frame_width * 0.54, height: frame_width * 0.54 * 0.32))
        iconImageView.image = UIImage.init(named: "welcome_logo")
        iconImageView.center = CGPoint.init(x: frame_width / 2, y: iconImageView.center.y)
        self.view.addSubview(iconImageView)
        
        // text
        let label = UILabel.init(frame: CGRect.init(x: 25, y: iconImageView.bottom + 0.045 * frame_height, width: frame_width - 50, height: 50))
        label.text = String.localizedString("AGHomeViewController-Description")
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.init(name: "OpenSans", size: CGFloat(17))
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.view.addSubview(label)
        
        // artist login
        let btn_rate = CGFloat( 0.4 )
        let btn_width = frame_width * btn_rate
        let artistBtn = UIButton.init(frame: CGRect.init(x: 0, y: label.bottom + 17, width: btn_width, height: btn_width))
        artistBtn.setImage(UIImage.init(named: "main_artist_icon"), for: UIControlState.normal)
        artistBtn.center = CGPoint.init(x: frame_width / 2, y: artistBtn.center.y)
        artistBtn.addTarget(self, action: #selector(artistRegisterAction), for: .touchUpInside)
        self.view.addSubview(artistBtn)

        
        // visitor login
        let visitorBtn = UIButton.init(frame: CGRect.init(x: 0, y: artistBtn.bottom + 17, width: btn_width, height: btn_width))
        visitorBtn.setImage(UIImage.init(named: "main_user_icon"), for: UIControlState.normal)
        visitorBtn.center = CGPoint.init(x: frame_width / 2, y: visitorBtn.center.y)
        visitorBtn.addTarget(self, action: #selector(normalRegisterAction), for: .touchUpInside)
        self.view.addSubview(visitorBtn)
        
        // see around
        self.seearoundLabel.text = String.localizedString("Home-SeeAround")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    
    func artistRegisterAction(){
        let artistRegisterVC = AGArtistLoginViewController()
        self.navigationController?.pushViewController(artistRegisterVC, animated: true)
    }
    
    func normalRegisterAction(){
        let artistRegisterVC = AGVisitorLoginViewController()
        self.navigationController?.pushViewController(artistRegisterVC, animated: true)

    }
    
    @IBAction func seearoundAction(_ sender: AnyObject) {
        AGLeftMenuViewController.sharedInstance.resetUI(type: .SeeAround)

        let seeAroundVC = AGSeeAroundMainPageViewController()
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: seeAroundVC, withCompletion: nil)
        
    }


}

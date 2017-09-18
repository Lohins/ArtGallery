//
//  AGLeftMenuUserItemView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-29.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu
import SDWebImage

class AGLeftMenuUserItemView: UIView {

    var view: UIView!
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib()-> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AGLeftMenuUserItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // --------
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var logoutLabel: UILabel!
    
    convenience init( width: CGFloat,name: String , iconName: String){
        self.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 130))
        let photo = ArtGalleryAppCenter.sharedInstance.user!.photourl
        let url = URL.init(string: photo)
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2
        self.iconImageView.clipsToBounds = true
        self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "main_user_icon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        self.nameLabel.text = ArtGalleryAppCenter.sharedInstance.user!.userName
        self.logoutLabel.text = String.localizedString("AGLeftMenuViewController-logout")
    }
    @IBAction func logout(_ sender: AnyObject) {
        
        ArtGalleryAppCenter.sharedInstance.logout()
        
        let loginVC = AGHomeViewController()
        //self.getCurrentViewController()?.navigationController?.present(loginVC, animated:true, completion: nil)
        SlideNavigationController.sharedInstance().popAllAndSwitch(to: loginVC, withCompletion: nil)
//        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: loginVC, withSlideOutAnimation: true, andCompletion: nil)
        
    }
}

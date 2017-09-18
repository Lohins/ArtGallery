//
//  AGProfileHeaderView.swift
//  ArtGallery
//
//  Created by S.t on 2016/12/9.
//  Copyright © 2016年 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGProfileHeaderView: UIView {

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
        let nib = UINib(nibName: "AGProfileHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // -------------
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    convenience init(frame: CGRect, name: String, type:String) {
        self.init(frame : frame)
        
        self.nameLabel.text = name
        self.typeLabel.text = type
        
        guard let artist = ArtGalleryAppCenter.sharedInstance.user! as? ArtGalleryArtistUser else{
            return
        }
        
        self.nameLabel.text = artist.userName
        self.typeLabel.text = artist.artworkCategory
        
        self.iconImageView.layer.cornerRadius = (frame.height - 73) / 2
        self.iconImageView.clipsToBounds = true
        
        if let urlString = ArtGalleryAppCenter.sharedInstance.user?.photourl, let url = URL.init(string: urlString){
            self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "main_artist_icon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        }
    }
    
    func adjustImageViewClips(){
        
    }

}

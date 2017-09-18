//
//  AGWorksCollectionViewCell.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-05.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGWorksCollectionViewCell: UICollectionViewCell {
    
    var youtubeImgView: UIImageView!
    
    var cellType: WorksType!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.youtubeImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 29, height: 20))
        self.youtubeImgView.image = UIImage.init(named: "youtube_logo")
        self.youtubeImgView.center = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addSubview(self.youtubeImgView)
        
    }
    
    @IBOutlet weak var picView: UIImageView!
    
    func updateData(type: WorksType){
        self.cellType = type
        if type == .Video{
            self.youtubeImgView.isHidden = false
        }
        else{
            self.youtubeImgView.isHidden = true
        }
    }
    
    func updateData(artwork:AGArtwork){
        
        guard let str = artwork.imagePath, let url = URL.init(string: str) else{
            return
        }
        self.picView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "explore_testicon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        self.youtubeImgView.center = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    func updateData(url:String){
        let Url = URL.init(string: url)
        self.picView.sd_setImage(with: Url, placeholderImage: UIImage.init(named: "explore_testicon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
    }

}

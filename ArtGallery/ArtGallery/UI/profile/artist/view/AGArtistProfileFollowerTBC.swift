//
//  AGArtistProfileFollowerTBC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-10.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage


class AGArtistProfileFollowerTBC: UITableViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(data: Dictionary<String, AnyObject>){
        if let name = data["nickname"] as? String{
            self.nameLabel.text = name
        }
        
        if let status = data["isartist"] as? Int{
            if status == 1{
                self.locationLabel.text = "Artist user"
            }
            else{
                self.locationLabel.text = "Visitor user"
            }
        }
        
        if let link = data["photourl"] as? String, let url = URL.init(string: link){
            self.iconImgView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "main_artist_icon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        }
        
        if let datejoined = data["datejoined"] as? String{
            let dateSep = datejoined.components(separatedBy: "T")
            if dateSep.count >= 1{
                self.timeLabel.text = "Since : \(dateSep[0])"
            }
        }
    }
    
    
    
}

extension AGArtistProfileFollowerTBC{
    class ProfileView: UIView{
        override init(frame: CGRect){
            super.init(frame: frame)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI(){
            let linearScrollView = AGLinearScrollView.init(frame: self.frame)
            
            self.addSubview(linearScrollView)
            
            
        }
    }
}

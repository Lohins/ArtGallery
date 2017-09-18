//
//  AGArtistUserItemCell.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-04.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGArtistUserItemCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView! //头像
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var followInfoLabel: UILabel!
    @IBOutlet weak var followIcon: UIImageView!
    var block: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateData(user: AGUser){
//        self.occupationLabel.text = occupation
        // 被关注了 显示 被关注 图标， 没关注 显示 添加关注图标
        if user.isFollowed == 1{
            self.followIcon.image = UIImage.init(named:"bookmark_unfollow_icon")
        }
        else{
            self.followIcon.image = UIImage.init(named:"bookmark_follow_icon")
        }
        
        self.followInfoLabel.text = "\(user.followernum) Followers"
        self.occupationLabel.text = user.category
        self.userNameLabel.text = user.firstName!
        if let url = user.photoUrl{
            if let link = URL.init(string: url){
                self.iconImageView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "mainpage_myworks_see"), options: SDWebImageOptions.allowInvalidSSLCertificates)
            }
        }
    }
    
    func updateData(followingartist: AGUser){
        var follower:Int = 0
        follower = followingartist.followernum
        self.occupationLabel.text = followingartist.artisttitle!
        self.userNameLabel.text = followingartist.firstName!
        self.followInfoLabel.text = "\(follower) Followers"
        if let url = followingartist.photoUrl{
            if let link = URL.init(string: url){
                self.iconImageView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "mainpage_myworks_see"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                
            }
        }
        
    }

    
    func updateData(artist: AGArtist){
//        self.occupationLabel.text
        self.userNameLabel.text = artist.firstName! 

    }
    
    
    @IBAction func followAction(_ sender: AnyObject) {
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self.getCurrentViewController()!, block: { [weak self] ()-> Void in
            if let weakSelf = self{
                if let blk = weakSelf.block{
                    blk()
                }
            }
        })

        
    }
    
}

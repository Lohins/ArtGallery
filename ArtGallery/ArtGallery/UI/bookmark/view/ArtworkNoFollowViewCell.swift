//
//  ArtworkNoFollowViewCell.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-30.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class ArtworkNoFollowViewCell: UITableViewCell {
    
    @IBOutlet weak var likeAndCommentLabel: UILabel!

    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var picView: UIImageView!
    
    @IBOutlet weak var collectionButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var collectBlock:(() -> Void)?
    var likeBlock:(() -> Void)?
    var commentBlock:(() -> Void)?
    var followBlock:(() -> Void)?
    
    var isLike:Bool = false {
        didSet{
            if isLike == false{
                self.likeButton.setImage(UIImage.init(named: "bookmark_dislike_icon"), for: .normal)
            }
            else{
                self.likeButton.setImage(UIImage.init(named: "bookmark_like_icon"), for: .normal)
            }
        }
    }
    
    var isCollected:Bool = false {
        didSet{
            if isCollected == false{
                self.collectionButton.setImage(UIImage.init(named: "bookmark_unmark_icon"), for: .normal)
            }
            else{
                self.collectionButton.setImage(UIImage.init(named: "bookmark_mark_icon"), for: .normal)
            }
        }
    }
    
    var videoImageView: UIImageView!
    
    var cellType = WorksType.Photo{
        didSet{
            if self.cellType == WorksType.Photo{
                //如果是 图片类型的cell，
                self.videoImageView.isHidden = true
            }
            else{
                // 如果是 视频类型的 cell， 需要显示youtube 的 视频logo
                self.videoImageView.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.videoImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        self.videoImageView.image = UIImage.init(named: "youtube_logo")
        self.videoImageView.contentMode = .scaleToFill
        self.videoImageView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 240 / 2)
        self.addSubview(self.videoImageView)
        self.videoImageView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func updateData(title: String , type:WorksType){
        // 在updatedata 的时候需要先 reset 每一个button的图标
        self.titleLabel.text = title
        self.cellType = type
    }
    
    func updateData(artwork: AGArtwork){
        
        self.nameLabel.text = artwork.createDate
        self.subjectLabel.text = artwork.subjectName
        self.likeAndCommentLabel.text = "\(artwork.likeNum) Likes | \(artwork.commentNum) Comments "
        self.titleLabel.text = artwork.caption
        self.cellType = artwork.worksType
        if artwork.isLiked == 0{
            self.isLike = false
        }
        else{
            self.isLike = true
        }
        
        if artwork.isCollected == 0{
            self.isCollected = false
        }
        else{
            self.isCollected = true
        }
        
        if let urlStr = artwork.imagePath{
            if let url = URL.init(string: urlStr){
                self.picView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
            }
        }
    }
    
    // ----- ACTION ------

    @IBAction func collectAction(_ sender: UIButton) {
        if let blk = self.collectBlock{
            blk()
        }
    }
    
    
    @IBAction func likeAction(_ sender: UIButton) {
        if let blk = self.likeBlock{
            blk()
        }
    }
    
}

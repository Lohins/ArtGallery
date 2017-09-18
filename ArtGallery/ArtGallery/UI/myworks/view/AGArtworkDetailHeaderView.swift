//
//  AGArtworkDetailHeaderView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage

// 这个类 是用来显示 explore 页面和 follow 页面 进入的 作品详情页面 ， 的 顶部视图。

class AGArtworkDetailHeaderView: UIView {
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
        let nib = UINib(nibName: "AGArtworkDetailHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // ----------------
    
    
    @IBOutlet var displayButton: UIButton!
    
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var likeAndCommentLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var picView: UIImageView!
    
    var commentBlock: ( () -> Void)?
    
    var playerViewController: AVPlayerViewController = AVPlayerViewController.init()

    
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
                self.collectButton.setImage(UIImage.init(named: "bookmark_unmark_icon"), for: .normal)
            }
            else{
                self.collectButton.setImage(UIImage.init(named: "bookmark_mark_icon"), for: .normal)
            }
        }
    }
    
    var isFollowed:Bool = false {
        didSet{
            if isFollowed == false{
                self.followButton.setImage(UIImage.init(named: "bookmark_follow_white_icon"), for: .normal)
            }
            else{
                self.followButton.setImage(UIImage.init(named: "bookmark_unfollow_white_icon"), for: .normal)
            }
        }
    }
    
    let service = AGInteractService()

    var artwork: AGArtwork!
    
    deinit {
        print("Deinit From AGArtworkDetailHeaderView")
    }
    
    convenience init(frame: CGRect, artwork: AGArtwork){
        self.init(frame: frame)
        
        self.artwork = artwork
    }
    
    func updateUI(artwork: AGArtwork){
        if let url = artwork.imagePath{
            if let link = URL.init(string: url){
                self.picView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
            }
        }
        self.artwork = artwork
        self.artistLabel.text = artwork.artistName
        self.titleLabel.text = artwork.caption
        self.subjectLabel.text = artwork.subjectName
        self.likeAndCommentLabel.text = "\(artwork.likeNum) Likes | \(artwork.commentNum) Comments "
        self.followLabel.text = "\(artwork.followerNum) Followers"
        
        if artwork.worksType == WorksType.Video{
            self.videoButton.isHidden = false
            self.videoButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            // 视频展示 不显示display button
            self.displayButton.isHidden = true

        }
        else{
            self.videoButton.isHidden = true
            // 图片展示 显示display button
            self.displayButton.isHidden = false
        }
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
        
        if artwork.isFollowed == 0{
            self.isFollowed = false
        }
        else{
            self.isFollowed = true
        }
    }
    
    
    @IBAction func displayAction(_ sender: Any) {
        if let url = artwork.imagePath{
            let vc = AGImageFullScreenDisplayVC.init(url: url)
            self.getCurrentViewController()?.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func videoPlayAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func followAction(_ sender: AnyObject) {
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self.getCurrentViewController()!, block: { [weak self] () -> Void in
            if let weakSelf = self{
                weakSelf.service.UpdateFollowStatus((1 - weakSelf.artwork.isFollowed), targetUserId: weakSelf.artwork.userID) { (success, error) in
                    if error != nil{
                        return
                    }
                    if !success{
                        return
                    }
                    
                    weakSelf.artwork.isFollowed = (1 - weakSelf.artwork.isFollowed)
                    if weakSelf.artwork.isFollowed == 0{
                        weakSelf.artwork.followerNum -= 1
                        weakSelf.isFollowed = false
                    }
                    else{
                        weakSelf.artwork.followerNum += 1
                        weakSelf.isFollowed = true
                    }
                    
                    // 更新 关注的人数
                    weakSelf.followLabel.text = "\(weakSelf.artwork.followerNum) Followers"
                }
            }

        })
        
    }
    
    @IBAction func collectAction(_ sender: AnyObject) {
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self.getCurrentViewController()!, block: { [weak self] () -> Void in
            if let weakSelf = self{
                weakSelf.service.UpdateCollectStatus((1 - weakSelf.artwork.isCollected), targetWorkId: weakSelf.artwork.id) { (success, error) in
                    if error != nil{
                        return
                    }
                    
                    if !success{
                        return
                    }
                    
                    weakSelf.artwork.isCollected = (1 - weakSelf.artwork.isCollected)
                    if weakSelf.artwork.isCollected == 0{
                        weakSelf.isCollected = false
                    }
                    else{
                        weakSelf.isCollected = true
                    }
                }
            }

        })
        
    }
    
    @IBAction func likeAction(_ sender: AnyObject) {
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self.getCurrentViewController()!, block: { [weak self] () -> Void in
            if let weakSelf = self{
                weakSelf.service.UpdateLikeStatus((1 - weakSelf.artwork.isLiked), targetWorkId: weakSelf.artwork.id) { (success, error) in
                    if error != nil{
                        return
                    }
                    
                    if !success{
                        return
                    }
                    
                    weakSelf.artwork.isLiked = (1 - weakSelf.artwork.isLiked)
                    if weakSelf.artwork.isLiked == 0{
                        weakSelf.isLike = false
                        weakSelf.artwork.likeNum -= 1
                    }
                    else{
                        weakSelf.isLike = true
                        weakSelf.artwork.likeNum += 1
                    }
                    
                    weakSelf.likeAndCommentLabel.text = "\(weakSelf.artwork.likeNum) Likes | \(weakSelf.artwork.commentNum) Comments"
                }
            }

        })
    }
    
    @IBAction func commentAction(_ sender: AnyObject) {
        if let blk = self.commentBlock{
            blk()
        }
    }
    
    
    // 播放视频
    func playVideo(){
        var urlstring = "defalut video"
        urlstring = self.artwork.videoLink
        print (urlstring)
        // 创建视频 播放器
        guard let url = URL.init(string: urlstring) else{
            return
        }
        
        let playerItem = AVPlayerItem.init(url: url)
        
        let player = AVPlayer.init(playerItem: playerItem)
        let playerVC = AVPlayerViewController.init()
        playerVC.player = player
        
        self.getCurrentViewController()!.present(playerVC, animated: true, completion: {
                playerVC.player!.play()
        })
        
        
        
        
    }
    
    
    
}

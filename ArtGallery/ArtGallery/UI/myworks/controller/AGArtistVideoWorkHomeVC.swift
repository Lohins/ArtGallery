//
//  AGArtistVideoWorkHomeVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage

class AGArtistVideoWorkHomeVC: UIViewController {
    var mainScrollView: AGLinearScrollView!
    
    var infoEditView: AGArtistWorkInfoEditView!
    
    var workImageView: UIImageView!
    
    var playBtn:UIButton!
    
    var commentLabel: UILabel!
    
    var artworkId: Int
    
    var artwork: AGArtwork?
    
    var editable: Bool = false
    
    var editButton: UIButton!
    
    var commentHeader: AGCommentHeaderView!
    
    var commentTextbox: AGCommentTextBox!
    
    var commentList = [AGComment]()
    
    let service = AGArtworkService()

    
    init(id: Int , editable: Bool) {
        
        self.artworkId = id
        self.editable = editable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavBar()
        
        setupUI()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateData()

    }
    
    deinit {
        print("---- Deinit From AGArtistVideoWorkHomeVC")
    }
    
    func updateData(){
        service.getArtworkInfo(id: self.artworkId) { [weak self] (artwork, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                weakSelf.editButton.isUserInteractionEnabled = true
                weakSelf.artwork = artwork
                weakSelf.updateUI(artwork: artwork!)
                
                // 去获取评论信息
                weakSelf.service.getCommentListbyArtworkID(id: weakSelf.artworkId, finish: { (list, error) in
                    if error != nil{
                        return
                    }
                    weakSelf.commentList.removeAll()
                    weakSelf.commentList = list!
                    weakSelf.setupComments()
                })
            }

        }
    }
    
    func updateUI(artwork: AGArtwork){
        if let url = URL.init(string: artwork.imagePath){
            workImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        }
        self.infoEditView.updateData(artwork: artwork)
    }
    
    func setupNavBar(){
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        // 设置 bar 的背景色
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        // 设置 title view
        let titleImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 32))
        titleImgView.image = UIImage.init(named: "welcome_logo")
        titleImgView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImgView
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        backButton.setBackgroundImage(UIImage.init(named: "back_arrow_white"), for: UIControlState.normal)
        backButton.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.navigationController!.popViewController(animated: true)
            }
            })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        editButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        if self.editable == true{
            editButton.setImage(UIImage.init(named: "myworks_edit_icon"), for: .normal)
            editButton.isUserInteractionEnabled = false
            editButton.bk_(whenTapped:  { [weak self] ()-> Void in
                if let weakSelf = self{
                    let vc = AGEditVideoWorkVC.init(id: weakSelf.artwork!.id)
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                }

                })
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        }
        
    }
    
    func setupUI(){
        
        let marginGap = CGFloat(18)
        
        self.view.backgroundColor = UIColor.white
        
        // 初始化linear scroll view
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.STATUSBAR_HEIGHT - GlobalValue.NVBAR_HEIGHT))
        self.view.addSubview(self.mainScrollView)
        
        // Row 1 -- 作品图片
        let picRatio = Float(0.624)
        workImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( picRatio)))
        workImageView.image = UIImage.init(named: "work-pic")
        workImageView.contentMode = .scaleAspectFill
        workImageView.clipsToBounds = true
        self.mainScrollView.linear_addSubview(workImageView, paddingTop: 0, paddingBottom: 0)
        
        // 添加 视频播放的 icon
        let videoIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        videoIcon.image = UIImage.init(named: "youtube_logo")
        videoIcon.center = workImageView.center
        self.mainScrollView.addSubview(videoIcon)

        
        // 播放视频的button
        self.playBtn = UIButton.init(frame: workImageView.frame)
        self.playBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        self.mainScrollView.addSubview(self.playBtn)
        
        //Row 2 -- 作品信息
        self.infoEditView = AGArtistWorkInfoEditView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: CGFloat(237)))
        self.infoEditView.editable = false
        self.mainScrollView.linear_addSubview(infoEditView, paddingTop: 0, paddingBottom: 0)
        
        //Row 3 -- comment label
        self.commentLabel = UILabel.init(frame: CGRect.init(x: marginGap, y: 0, width: GlobalValue.SCREENBOUND.width - marginGap * 2, height:  20))
        self.commentLabel.font = UIFont.init(name: "Montserrat-Bold", size: 13)
        self.commentLabel.textColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1)
        self.commentLabel.textAlignment = .center
        self.commentLabel.text = "Comments(2)"
        
        self.commentTextbox = AGCommentTextBox.init(frame: CGRect.init(x: marginGap, y: 0, width: GlobalValue.SCREENBOUND.width - marginGap * 2, height: 55))
        self.commentTextbox.InputFinishBlock = {[weak self] (text) -> Void in
            if let weakSelf = self{
                // 添加评论
                weakSelf.postComment(content: text)
                weakSelf.commentAction(after: weakSelf.commentHeader)
            }
        }
        //Row 3 -- comment header
        self.commentHeader = AGCommentHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 20))
        self.commentHeader.tapBlock = { [weak self] ()-> Void in
            if let weakSelf = self{
                // 回复 模式
                weakSelf.commentTextbox.setCommentMode()
                weakSelf.commentAction(after: weakSelf.commentHeader)
            }
        }
        self.mainScrollView.linear_addSubview(self.commentHeader, paddingTop: 0, paddingBottom: 10)
        
    }
    
    // 发布 当前的评论 到服务器
    func postComment(content: String){
        service.postComment(userid: ArtGalleryAppCenter.sharedInstance.user!.userId, artworkid: self.artworkId, comment: content) { [weak self] (comment, error) in
            if let weakSelf = self{
                if error != nil{
                    let alertVC = UIAlertController.init(title: "Error", message: "Fail to post comment.", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                    alertVC.addAction(action)
                    weakSelf.present(alertVC, animated: true, completion: nil)
                }
                
                if let comment = comment{
                    weakSelf.commentList.insert(comment, at: 0)
                    let commentView = AGArtistCommentItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 0), commentObj: comment)
                    weakSelf.mainScrollView.linear_insertView(before: weakSelf.commentHeader, for: commentView, paddingTop: 0, paddingBottom: 0)
                }
            }
        }
    }
    
    // 显示 从服务器获取的评论列表
    func setupComments(){
        for comment in self.commentList{
            let commentView = AGArtistCommentItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 0), commentObj: comment)
            commentView.replyBlock = { [weak self, weak commentView] () -> Void in
                if let weakSelf = self, let weakcv = commentView{
                    // 回复 模式
                    weakSelf.commentTextbox.setReplyMode(target: comment.postUserName)
                    weakSelf.commentAction(after: weakcv)
                }

            }
            self.mainScrollView.linear_addSubview(commentView, paddingTop: 0, paddingBottom: 0)
        }
    }
    
    // 这个方法调用： 用户点击评论图标时候， 在评论列表最上方插入一个文本输入框。
    func commentAction(after targetView: UIView?){
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self, block: {[weak self] ()-> Void in
            if let weakSelf = self{
                if weakSelf.commentTextbox.isDisplayed{
                    weakSelf.mainScrollView.linear_removeView(weakSelf.commentTextbox)
                    weakSelf.commentTextbox.isDisplayed = !weakSelf.commentTextbox.isDisplayed
                }
                else{
                    if let view = targetView{
                        weakSelf.mainScrollView.linear_insertView(before: view, for: weakSelf.commentTextbox, paddingTop: 0, paddingBottom: 10)
                        weakSelf.commentTextbox.isDisplayed = !weakSelf.commentTextbox.isDisplayed
                    }
                }
            }
        })
        
    }
    
    
    // 播放视频
    func playVideo(){
        let urlstring = self.artwork!.videoLink
            //self.linkEditView.getLink()

        
        // 创建视频 播放器
        guard let url = URL.init(string: urlstring!) else{
            return
        }
        
        let playerItem = AVPlayerItem.init(url: url)
        
        let player = AVPlayer.init(playerItem: playerItem)
        
        let playerVC = AVPlayerViewController.init()

        playerVC.player = player
        
        self.present(playerVC, animated: true, completion: {
            playerVC.player!.play()
        })
    }
}

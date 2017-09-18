//
//  AGArtworkDetailViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AGArtworkDetailViewController: UIViewController {
    
    var mainScrollView: AGLinearScrollView!

    var headerView: AGArtworkDetailHeaderView!
    
    var infoEditView: AGArtistWorkInfoEditView!
    
    // 为了保证数据的同步显示，当该页面消失的时候 去reload cell 的内容。
    var dismissBlock: (()-> Void)?
    
    // video 就显示， 不是就 不显示。
    
    var linkEditView: AGArtistWorkLinkEditView!

    var commentHeader: AGCommentHeaderView!
    
    var commentTextbox: AGCommentTextBox!
    
    var commentList = [AGComment]()
    
    var artwork: AGArtwork?
    
    let service = AGArtworkService()

    
    var playerViewController: AVPlayerViewController = AVPlayerViewController.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        
        self.setupUI()
        
        self.updateData()
    }
    
    init(artwork: AGArtwork){
        self.artwork = artwork
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("---- Deinit From AGArtworkDetailViewController")
    }
    
    
    func updateData(){
        service.getArtworkInfo(id: self.artwork!.id) { [weak self] (work, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                guard let work = work else{
                    return
                }
                weakSelf.artwork!.update(append: work)
                weakSelf.updateUI(artwork: weakSelf.artwork!)
                
                
                // 去获取评论信息
                let tmpService = AGArtworkService()
                tmpService.getCommentListbyArtworkID(id: weakSelf.artwork!.id, finish: { (list, error) in
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
        self.headerView.updateUI(artwork: artwork)
        self.infoEditView.updateData(artwork: artwork)
        if self.artwork!.worksType == WorksType.Video{
            self.linkEditView.updateData(artwork: artwork)
        }
    }
    
    func setupUI(){
        let marginGap = CGFloat(18)
        
        self.view.backgroundColor = UIColor.white
        
        // 初始化linear scroll view
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.STATUSBAR_HEIGHT - GlobalValue.NVBAR_HEIGHT))
        self.view.addSubview(self.mainScrollView)
        
        
        // row 1
        let rate = 0.624
        self.headerView = AGArtworkDetailHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( rate)), artwork: self.artwork!)
        self.headerView.commentBlock = { [weak self , weak commentHeader] ()-> Void in
            if let weakSelf = self, let weakcommentHeader = commentHeader{
                // 回复 模式
                weakSelf.commentTextbox.setCommentMode()
                weakSelf.commentAction(after: weakcommentHeader)
            }
        }
        self.mainScrollView.linear_addSubview(self.headerView, paddingTop: 0, paddingBottom: 0)
        
        // Row 2 -- 视频链接  如果是就显示。
        if self.artwork!.worksType == WorksType.Video{
            self.linkEditView = AGArtistWorkLinkEditView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: CGFloat(25)))
            self.linkEditView.editable = false
            self.mainScrollView.linear_addSubview(self.linkEditView, paddingTop: 5, paddingBottom: 0)
        }
        
        //Row 3 -- 作品信息
        self.infoEditView = AGArtistWorkInfoEditView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: CGFloat(237)))
        self.infoEditView.editable = false
        self.mainScrollView.linear_addSubview(infoEditView, paddingTop: 0, paddingBottom: 0)
        
        self.commentTextbox = AGCommentTextBox.init(frame: CGRect.init(x: marginGap, y: 0, width: GlobalValue.SCREENBOUND.width - marginGap * 2, height: 55))
        self.commentTextbox.InputFinishBlock = {[weak self] (text) -> Void in
            if let weakSelf = self{
                // 添加评论
                weakSelf.postComment(content: text)
                weakSelf.commentAction(after: weakSelf.commentHeader)
            }
        }
        //Row 4 -- comment header
        self.commentHeader = AGCommentHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 20))
        self.commentHeader.tapBlock = { [weak self, weak commentHeader] ()-> Void in
            if let weakSelf = self, let weakch = commentHeader{
                // 回复 模式
                weakSelf.commentTextbox.setCommentMode()
                weakSelf.commentAction(after: weakch)
            }

        }
        self.mainScrollView.linear_addSubview(self.commentHeader, paddingTop: 0, paddingBottom: 10)
        
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
    
    func setupComments(){
        for comment in self.commentList{
            let commentView = AGArtistCommentItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 0), commentObj: comment)
            commentView.replyBlock = {[weak self, weak commentView] () -> Void in
                // 回复 模式
                if let weakSelf = self, let weakcommentView = commentView{
                    weakSelf.commentTextbox.setReplyMode(target: comment.postUserName)
                    weakSelf.commentAction(after: weakcommentView)
                }
            }
            self.mainScrollView.linear_addSubview(commentView, paddingTop: 0, paddingBottom: 0)
        }
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
                // 页面消失的时候去 更新cell 的显示内容
                if let blk = weakSelf.dismissBlock{
                    blk()
                }
            }

        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        // ----
        let fillButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: fillButton)
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    // 发布 当前的评论 到服务器
    func postComment(content: String){
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self, block: { [weak self] () -> Void in
            if let weakSelf = self{
                weakSelf.service.postComment(userid: ArtGalleryAppCenter.sharedInstance.user!.userId, artworkid: weakSelf.artwork!.id, comment: content) { (comment, error) in
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
                        
                        // 添加了了一条评论 那么artwork 的numofcomment 就加一
                        weakSelf.artwork!.commentNum = weakSelf.artwork!.commentNum + 1
                        weakSelf.updateUI(artwork: weakSelf.artwork!)
                    }
                    
                }
            }
        })
        
    }
}

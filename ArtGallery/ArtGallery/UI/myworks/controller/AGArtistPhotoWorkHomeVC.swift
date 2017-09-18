//
//  AGArtistPhotoWorkHomeVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-30.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGArtistPhotoWorkHomeVC: UIViewController {
    
    var mainScrollView: AGLinearScrollView!
    
    var infoEditView: AGArtistWorkInfoEditView!
    
    var workImageView: UIImageView!
    
    
    var commentHeader: AGCommentHeaderView!
    
    var commentTextbox: AGCommentTextBox!
    
    var artworkId: Int
    
    var artwork: AGArtwork?
    
    var editable: Bool = false
    
    var editButton: UIButton!
    
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
    
    deinit {
        print("---- Deinit From AGArtistPhotoWorkHomeVC")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData(){
        service.getArtworkInfo(id: self.artworkId) { [weak self] (artwork, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                if let button = weakSelf.editButton{
                    button.isUserInteractionEnabled = true
                }
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
    
    func updateUI(artwork: AGArtwork){
        let url = URL.init(string: artwork.imagePath)
        if let url =  url{
            self.workImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
            
            // 展示图片的button
            let picRatio = Float(0.624)
            let btn_width = GlobalValue.SCREENBOUND.width * CGFloat( picRatio) - 80
            let displayBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btn_width, height: btn_width))
            displayBtn.bk_(whenTapped: { [weak self] ()-> Void in
                if let weakSelf = self{
                    let vc = AGImageFullScreenDisplayVC.init(url: artwork.imagePath)
                    weakSelf.navigationController?.present(vc, animated: true, completion: nil)
                }
            })
            displayBtn.center = workImageView.center
            self.mainScrollView.addSubview(displayBtn)
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
        
        
        if self.editable == true{
            editButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
            editButton.setImage(UIImage.init(named: "myworks_edit_icon"), for: .normal)
            editButton.isUserInteractionEnabled = false
            editButton.bk_(whenTapped:  { [weak self] ()-> Void in
                if let weakSelf = self{
                    let vc = AGEditPhotoWorkVC.init(id: weakSelf.artwork!.id)
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                }
                })
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        }
    }
    
    func setupUI(){
        
        self.view.backgroundColor = UIColor.white
        
        let marginGap = CGFloat(18)
        
        // 初始化linear scroll view
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.STATUSBAR_HEIGHT - GlobalValue.NVBAR_HEIGHT))
        self.view.addSubview(self.mainScrollView)
        
        // Row 1 -- 作品图片
        let picRatio = Float(0.624)
        self.workImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( picRatio)))
        workImageView.contentMode = .scaleAspectFill
        workImageView.clipsToBounds = true
        workImageView.image = UIImage.init(named: "work-pic")
        self.mainScrollView.linear_addSubview(workImageView, paddingTop: 0, paddingBottom: 0)
        

        
        //Row 2 -- 作品信息
        self.infoEditView = AGArtistWorkInfoEditView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: CGFloat(237)))
        self.infoEditView.editable = false
        self.mainScrollView.linear_addSubview(infoEditView, paddingTop: 0, paddingBottom: 0)
        
        //Row 3 -- comment label
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
    func setupComments(){
        for comment in self.commentList{
            let commentView = AGArtistCommentItemView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 0), commentObj: comment)
            commentView.replyBlock = { [weak self, weak commentView] () -> Void in
                if let weakSelf = self, let weakcv = commentView{
                    weakSelf.commentTextbox.setReplyMode(target: comment.postUserName)
                    weakSelf.commentAction(after: weakcv)
                }

            }
            self.mainScrollView.linear_addSubview(commentView, paddingTop: 0, paddingBottom: 0)
        }
    }
    
    // 这个方法调用： 用户点击评论图标时候， 在评论列表最上方插入一个文本输入框。
    func commentAction(after targetView: UIView?){
        if self.commentTextbox.isDisplayed{
            self.mainScrollView.linear_removeView(self.commentTextbox)
            self.commentTextbox.isDisplayed = !self.commentTextbox.isDisplayed
        }
        else{
            if let view = targetView{
                self.mainScrollView.linear_insertView(before: view, for: self.commentTextbox, paddingTop: 0, paddingBottom: 10)
                self.commentTextbox.isDisplayed = !self.commentTextbox.isDisplayed
            }

        }
    }
    

}



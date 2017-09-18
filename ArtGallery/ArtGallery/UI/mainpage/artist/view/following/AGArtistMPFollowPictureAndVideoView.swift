//
//  AGArtistMPFollowPictureAndVideoView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-05.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistMPFollowPictureAndVideoView: UIView {
    
    class SwitchView: UIView{
        
        class func Factory() -> SwitchView{
            return SwitchView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        }
        
        var switchBlock: ((_ flag: Bool)-> Void)?
        
        // 标志 当前选择的是图片true 还是 视频false
        var switchFlag: Bool = true
        
        var buttonView: UIImageView!
        
        override init(frame: CGRect){
            super.init(frame: frame)
            
            setupUI(frame: frame)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI(frame: CGRect){
            let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
            bgImageView.image = UIImage.init(named: "phonevideo_switch_bg")
            bgImageView.contentMode = .scaleToFill
            self.addSubview(bgImageView)
            
            let icon_width = CGFloat(30)
            let icon_height = CGFloat(22)

            
            let photoImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: icon_width, height: icon_height))
            photoImageView.image = UIImage.init(named: "phonevideo_switch_photo")
            photoImageView.contentMode = .scaleToFill
            photoImageView.center = CGPoint.init(x: frame.width / 2, y: frame.height / 2)
            photoImageView.left = CGFloat(10)
            self.addSubview(photoImageView)
            
            let videoImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: icon_width, height: icon_height))
            videoImageView.image = UIImage.init(named: "phonevideo_switch_video")
            videoImageView.contentMode = .scaleToFill
            videoImageView.center = CGPoint.init(x: frame.width / 2, y: frame.height / 2)
            videoImageView.right =  frame.width - CGFloat(10)
            self.addSubview(videoImageView)
            
            self.buttonView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 30))
            self.buttonView.image = UIImage.init(named: "phonevideo_switch_handle")?.imageScale(size: CGSize.init(width: 44, height: 30))
            self.buttonView.contentMode = .scaleAspectFill
            self.buttonView.center = CGPoint.init(x: frame.width / 2, y: frame.height / 2 + 2)
            self.buttonView.left = CGFloat(4)
            self.addSubview(self.buttonView)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        }
        
        func tapAction(){
            if self.switchFlag == true{
                self.switchFlag = !self.switchFlag
                UIView.animate(withDuration: 0.5, animations: {  () -> Void in
                    self.buttonView.right = self.frame.width - CGFloat(4)
                })
                if let blk = self.switchBlock{
                    blk(self.switchFlag)
                }
            }
            else{
                self.switchFlag = !self.switchFlag
                UIView.animate(withDuration: 0.5, animations: {  () -> Void in
                    self.buttonView.left = CGFloat(4)
                })
                
                if let blk = self.switchBlock{
                    blk(self.switchFlag)
                }
            }
        }
    }
    
    var scrollView: UIScrollView!
    
    var photoTableView: AGBaseTableView!
    
    var videoTableView: AGBaseTableView!
    
    let cell_identifier = "AGBookMarkItemCell"
    
    var photoList = [AGArtwork]()
    var videoList = [AGArtwork]()
    
    var service = AGFollowService()
    
    var userID: Int!

    let interactService: AGInteractService = AGInteractService()

    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI(frame: frame)
        

    }
    
    convenience init(frame: CGRect , UserId: Int){
        self.init(frame: frame)
        self.userID = UserId
        
        updateData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(frame: CGRect){
        let bottomview_height = CGFloat(45)

        // 显示 图片的table view
        let photoTBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }

        self.photoTableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height), headerRefreshBlk: photoTBHeaderBlk)
        self.photoTableView.separatorStyle = .none
        self.photoTableView.delegate = self
        self.photoTableView.dataSource = self
        self.photoTableView.tableFooterView = UIView()
        self.photoTableView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        
        // 显示视频的table view
        let videoTBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }
//        let videoTBFooterBlk = {()-> Void in
//            //TODO: 需要 添加 上啦加载的 内容
//        }
        self.videoTableView = AGBaseTableView.init(frame: CGRect.init(x: self.photoTableView.right, y: 0, width: frame.width, height: frame.height - bottomview_height), headerRefreshBlk: videoTBHeaderBlk      )
        
        self.videoTableView.separatorStyle = .none
        self.videoTableView.delegate = self
        self.videoTableView.dataSource = self
        self.videoTableView.tableFooterView = UIView()
        self.videoTableView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height))
        self.scrollView.contentSize = CGSize.init(width: frame.width * 2, height: frame.height - bottomview_height)
        
        self.addSubview(scrollView)
        scrollView.isScrollEnabled = false
        scrollView.addSubview(self.photoTableView)
        scrollView.addSubview(self.videoTableView)

        
        
        // bottom view
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: bottomview_height))
        bottomView.backgroundColor = UIColor.white
        let switchView = SwitchView.Factory()
        switchView.center = CGPoint.init(x: bottomView.width / 2, y: bottomView.height / 2)
        switchView.switchBlock = {[weak self](flag: Bool)-> Void in
            if let weakSelf = self{
                // 标志 当前选择的是图片true 还是 视频false
                if flag == false{
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(x: frame.width, y: 0, width: frame.width, height: frame.height - bottomview_height), animated: false)
                }
                else{
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height), animated: false)
                }
            }
        }
        
        bottomView.addSubview(switchView)
        bottomView.bottom = frame.height
        
        self.addSubview(bottomView)
    
    }
    
    func updateData(){
        self.service.getFollowWorks(by: self.userID) { [weak self] (list, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                
                // 返回的 list 是图片和 视频混着的， 需要筛选
                weakSelf.photoList.removeAll()
                weakSelf.videoList.removeAll()
                for element in list!{
                    if element.worksType == WorksType.Photo{
                        weakSelf.photoList.append(element)
                    }
                    else{
                        weakSelf.videoList.append(element)
                    }
                }
                
                weakSelf.videoTableView.reloadData()
                weakSelf.photoTableView.reloadData()
            }

        }
    }
}

extension AGArtistMPFollowPictureAndVideoView: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.photoTableView{
            return self.photoList.count
        }
        else{
            return self.videoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.photoTableView{ // 显示图片
            if self.photoList.count == 0{
                return CGFloat(50)
            }
            return CGFloat(0)
        }
        else{  // 显示视频
            if self.videoList.count == 0{
                return CGFloat(50)
            }
            return CGFloat(0)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.photoTableView && self.photoList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No picture for displaying.")
            return footer
        }
        else if tableView == self.videoTableView && self.videoList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No video for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(241)

    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! AGBookMarkItemCell
        var artwork: AGArtwork?

        if tableView == self.photoTableView{
            artwork = self.photoList[indexPath.row]
            cell.updateData(artwork: artwork!)        }
        else{
            artwork = self.videoList[indexPath.row]
            cell.updateData(artwork: artwork!)        }
        
        cell.selectionStyle = .none

        
        cell.collectBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                print("select \(indexPath.row) to collect")
                
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.interactService.UpdateCollectStatus( 1 - artwork!.isCollected, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                            return
                        }
                        if result{
                            // 更新artwork的数据
                            artwork!.isCollected = 1 - artwork!.isCollected
                            // 重载当前 cell
                            weakTB.reloadRows(at: [indexPath], with: .automatic)
                        }
                        
                    })
                })
            }
        }
        
        cell.likeBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                print("select \(indexPath.row) to like")
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.interactService.UpdateLikeStatus( 1 - artwork!.isLiked, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                            return
                        }
                        if result{
                            // 更新artwork的数据
                            artwork!.isLiked = 1 - artwork!.isLiked
                            // 更新本地like label
                            if artwork!.isLiked == 0{
                                artwork!.likeNum -= 1
                            }
                            if artwork!.isLiked == 1{
                                artwork!.likeNum += 1
                            }
                            // 重载当前 cell
                            weakTB.reloadRows(at: [indexPath], with: .automatic)
                        }
                        
                    })
                })
            }

        }
        
        cell.commentBlock = { () -> Void in
            print("select \(indexPath.row) to comment")
        }
        
        cell.followBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.interactService.UpdateFollowStatus((1 - artwork!.isFollowed), targetUserId: artwork!.userID, finish: { (success, error) in
                        if error != nil || success == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                            return
                        }
                        
                        if success{
                            // 更新artwork的数据
                            artwork!.isFollowed = 1 - artwork!.isFollowed
                            // 更新本地like label
                            if artwork!.isFollowed == 0{
                                artwork!.followerNum -= 1
                            }
                            if artwork!.isFollowed == 1{
                                artwork!.followerNum += 1
                            }
                            // 重载当前 cell
                            weakTB.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var artwork: AGArtwork?
        
        if tableView == self.photoTableView{
            artwork = self.photoList[indexPath.row]
        }
        else{
            artwork = self.videoList[indexPath.row]
        }
        if let work = artwork{
            let detailVC = AGArtworkDetailViewController.init(artwork: work)
            detailVC.dismissBlock = {[weak tableView] in
                if let weakTB = tableView{
                    weakTB.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            self.getCurrentViewController()?.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}

//
//  AGArtistMPExplorePictureAndVideoView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-05.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistMPExplorePictureAndVideoView: UIView {

    
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
    
    
    // -----------
    
    
    var scrollView: UIScrollView!
    
    var worksTableView: AGBaseTableView!
    var worksCollectionView: AGBaseCollectionView!
    
    var bottomView: UIView!
    
    let cell_identifier = "AGBookMarkItemCell"
    let collection_cell_identifier = "AGWorksCollectionViewCell"
    
    var photoList = [AGArtwork]()
    var videoList = [AGArtwork]()
    
    var collectionButton: UIButton!
    var tableButton: UIButton!
    
    var collectionImgView: UIImageView!
    var tableImgView: UIImageView!
    
    var cellHeight = CGFloat(0)
    
    let service: AGInteractService = AGInteractService()
    
    var searchService: AGSearchService = AGSearchService()

    
    // 图片 则为true， 视频则为false
    var typeFlag = true{
        didSet{
            self.worksTableView.reloadData()
            self.worksCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI(frame: frame)
        
//        updateData()
    
    }
    
    // 当用户使用关键字搜索的时候， 就调用该方法进行 search 的网络请求。
    func updateWithQuery(query: String){
        self.searchService.searchWorkBy(keyword: query, finish: { (list, error) in
            if error != nil{
                return
            }
            
            // 返回的 list 是图片和 视频混着的， 需要筛选
            self.photoList.removeAll()
            self.videoList.removeAll()
            for element in list!{
                if element.worksType == WorksType.Photo{
                    self.photoList.append(element)
                }
                else{
                    self.videoList.append(element)
                }
            }
            
            self.worksTableView.reloadData()
            self.worksCollectionView.reloadData()
        })
    }
    
    func setupUI(frame: CGRect){
        self.backgroundColor = UIColor.init(floatValueRed: 254, green: 251, blue: 251, alpha: 1)
        
        let bottomview_height = CGFloat(45)
        let cell_width = ( GlobalValue.SCREENBOUND.width - CGFloat(23 + 15 + 15 + 23) ) / 3
        self.cellHeight = cell_width
        
        //初始化 table view
        // 显示 图片的table view
        let TBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }

        self.worksTableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height), headerRefreshBlk: TBHeaderBlk)
        self.worksTableView.backgroundColor = UIColor.white
        self.worksTableView.delegate = self
        self.worksTableView.dataSource = self
        self.worksTableView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        
        
        // 初始化 collection view
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: cell_width, height: cell_width)
        layout.minimumInteritemSpacing = CGFloat(15)
        layout.minimumLineSpacing = CGFloat(15)
        layout.footerReferenceSize = CGSize.init(width: GlobalValue.SCREENBOUND.width, height: bottomview_height)
        layout.scrollDirection = .vertical
        
        
        // collection view
        let collectionHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }

        self.worksCollectionView = AGBaseCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height ), layout: layout, headerBlock: collectionHeaderBlk)
        self.worksCollectionView.backgroundColor = UIColor.white
        self.worksCollectionView.delegate = self
        self.worksCollectionView.dataSource = self
        self.worksCollectionView.register(UINib.init(nibName: collection_cell_identifier, bundle: Bundle.main), forCellWithReuseIdentifier: collection_cell_identifier)

        self.worksCollectionView.isHidden = false
        self.worksTableView.isHidden = true
        self.addSubview(self.worksTableView)
        self.addSubview(self.worksCollectionView)

        // bottom view
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: bottomview_height))
        bottomView.backgroundColor = UIColor.init(floatValueRed: 254, green: 251, blue: 251, alpha: 0.57)
        let switchView = SwitchView.Factory()
        switchView.center = CGPoint.init(x: bottomView.width / 2, y: bottomView.height / 2)
        switchView.switchBlock = {[weak self](flag: Bool)-> Void in
            // 标志 当前选择的是图片true 还是 视频false
            if let weakSelf = self{
                weakSelf.typeFlag = flag
            }
        }
        
        // 添加 显示table 和显示 collection 的button
        self.tableImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.tableImgView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width - CGFloat(23) - cell_width / 2, y: bottomView.height / 2)
        self.tableImgView.alpha = 0.5
        self.tableImgView.image = UIImage.init(named: "explore_table_icon")
        
        
        self.collectionImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.collectionImgView.image = UIImage.init(named: "explore_collection_icon")
        self.collectionImgView.center = CGPoint.init(x:  CGFloat(23) + cell_width / 2, y: bottomView.height / 2)

        
        self.tableButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.tableButton.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width - CGFloat(23) - cell_width / 2, y: bottomView.height / 2)
        self.tableButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        
        self.collectionButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.collectionButton.center = CGPoint.init(x: CGFloat(23) + cell_width / 2, y: bottomView.height / 2)
        self.collectionButton.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)

        
        bottomView.addSubview(self.tableImgView)
        bottomView.addSubview(self.tableButton)
        bottomView.addSubview(self.collectionImgView)
        bottomView.addSubview(self.collectionButton)
        bottomView.addSubview(switchView)
        
        bottomView.bottom = frame.height
        
        self.addSubview(bottomView)
        
        
        self.worksTableView.reloadData()
        self.worksCollectionView.reloadData()
    }
    
    func updateData(){
        let service = AGExploreService()
        
        service.getExploreInfo { [weak self](list, error) in
            if let weakSelf = self{
                if error != nil {
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
                
                weakSelf.worksTableView.reloadData()
                
                weakSelf.worksCollectionView.reloadData()
            }

        }
    }
    
    
    func tapAction(sender: UIButton){
        if sender == self.tableButton && self.worksTableView.isHidden == true{
            self.worksTableView.isHidden = false
            self.worksCollectionView.isHidden = true
            self.tableImgView.alpha = 1
            self.collectionImgView.alpha = 0.5
        }
        else if sender == self.collectionButton && self.worksCollectionView.isHidden == true{
            self.worksCollectionView.isHidden = false
            self.worksTableView.isHidden = true
            self.tableImgView.alpha = 0.5
            self.collectionImgView.alpha = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        let bottomview_height = CGFloat(45)

        self.worksTableView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height)
        self.worksCollectionView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottomview_height )
        
        self.bottomView.bottom = self.frame.height
        
        print("There")
        print(self.worksTableView.frame)
        print(self.worksCollectionView.frame)
        print(self.bottomView.bottom)
    }
}


extension AGArtistMPExplorePictureAndVideoView: UITableViewDelegate , UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.typeFlag == true{ // 显示图片
            return self.photoList.count
        }
        else{  // 显示视频
            return self.videoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(241)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.typeFlag == true{ // 显示图片
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
        if self.typeFlag == true && self.photoList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No picture for displaying.")
            return footer
        }
        else if self.typeFlag == false && self.videoList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No video for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell  = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! AGBookMarkItemCell
        
        var artwork: AGArtwork?
        if self.typeFlag == true{ // 显示图片
            
            artwork = self.photoList[indexPath.row]
            cell.updateData(artwork: artwork!)
        }
        else{  // 显示视频
            artwork = self.videoList[indexPath.row]
            cell.updateData(artwork: artwork!)

        }
        
        cell.selectionStyle = .none
        
        // 实现 收藏的 方法
        cell.collectBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.service.UpdateCollectStatus( 1 - artwork!.isCollected, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                            return
                        }
                        // 更新artwork的数据
                        artwork!.isCollected = 1 - artwork!.isCollected
                        // 重载当前 cell
                        weakTB.reloadRows(at: [indexPath], with: .automatic)
                    })
                })
            }
        }
        // 实现 喜欢的 方法
        cell.likeBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.service.UpdateLikeStatus( 1 - artwork!.isLiked, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                            return
                        }
                        // 更新artwork的数据
                        artwork!.isLiked = 1 - artwork!.isLiked
                        if artwork!.isLiked == 0{
                            artwork!.likeNum -= 1
                        }
                        if artwork!.isLiked == 1{
                            artwork!.likeNum += 1
                        }
                        // 重载当前 cell
                        weakTB.reloadRows(at: [indexPath], with: .automatic)
                    })
                })
            }

        }
        
        // 实现 评论的 方法
        cell.commentBlock = { () -> Void in
        }
        // 实现 关注的 方法
        cell.followBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf.getCurrentViewController()!, block: {
                    weakSelf.service.UpdateFollowStatus((1 - artwork!.isFollowed), targetUserId: artwork!.userID, finish: { (success, error) in
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
        if self.typeFlag == true{
            artwork = self.photoList[indexPath.row]
        }
        else{
            artwork = self.videoList[indexPath.row]
        }
        let detailVC = AGArtworkDetailViewController.init(artwork: artwork!)
        // 页面返回的时候去更新 cell
        detailVC.dismissBlock = {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.getCurrentViewController()?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension AGArtistMPExplorePictureAndVideoView: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.typeFlag == true{ // 显示图片
            return self.photoList.count
        }
        else{  // 显示视频
            return self.videoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var artwork: AGArtwork?
        if self.typeFlag == true{
            artwork = self.photoList[indexPath.row]
        }
        else{
            artwork = self.videoList[indexPath.row]
        }
        let detailVC = AGArtworkDetailViewController.init(artwork: artwork!)
        // 页面返回的时候去更新 cell
        detailVC.dismissBlock = {
            collectionView.reloadItems(at: [indexPath])
        }
        self.getCurrentViewController()?.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: collection_cell_identifier , for: indexPath) as! AGWorksCollectionViewCell
        
        var artwork: AGArtwork?
        
        if self.typeFlag == true{ // 显示图片
            artwork = self.photoList[indexPath.row]
            cell.updateData(type: .Photo)
            cell.updateData(artwork: artwork!)
        }
        else{  // 显示视频
            artwork = self.videoList[indexPath.row]
            cell.updateData(type: .Video)
            cell.updateData(artwork: artwork!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: self.cellHeight, height: self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: 23, bottom: 15, right: 23)
    }
}

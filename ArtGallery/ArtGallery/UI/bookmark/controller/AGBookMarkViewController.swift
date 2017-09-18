//
//  AGBookMarkViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-29.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

import iOS_Slide_Menu

class AGBookMarkViewController: UIViewController {
    
    let cell_identifier = "AGBookMarkItemCell"
    
    let interactService: AGInteractService = AGInteractService()
    
    var dataList: [AGArtwork] = []
    
    var workView:AGBaseTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupNavBar()
        
        updateData()

    }
    
    func setupUI(){
        
        
        let width = GlobalValue.SCREENBOUND.width
        let height = GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT


        let TBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }
        
        self.workView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: GlobalValue.NVBAR_HEIGHT+GlobalValue.STATUSBAR_HEIGHT, width: width, height: height), headerRefreshBlk: TBHeaderBlk)
        self.workView.backgroundColor = UIColor.white

        
        self.workView.delegate = self
        self.workView.dataSource = self
        self.workView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        self.view.addSubview(self.workView)
        
    }
    
    func setupNavBar(){

        //  title view
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString("AGLeftMenuViewController-bookmark")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
    }
    
    func updateData(){
        let service = AGArtworkService()
        self.dataList.removeAll()
        service.getCollectedArtworkList{ [weak self] (list, error) in
            if let weakSelf = self{
                if error != nil {
                    return
                }
                
                for artwork in list!{
                    weakSelf.dataList.append(artwork)
                }
                
                weakSelf.workView.reloadData()
            }
        }
    }

}

extension AGBookMarkViewController: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(240)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell 内容加载
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath)
            as! AGBookMarkItemCell
        var artwork: AGArtwork?
        artwork = self.dataList[indexPath.row]
        cell.updateData(artwork: artwork!)
        cell.selectionStyle = .none
        
        // cell的 点赞／评论／ 收藏操作
        cell.collectBlock = { [weak self, weak tableView] () -> Void in
            if let weakSelf = self, let weakTB = tableView{
                print("select \(indexPath.row) to collect")
                
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf, block: {
                    weakSelf.interactService.UpdateCollectStatus( 1 - artwork!.isCollected, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
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
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf, block: {
                    weakSelf.interactService.UpdateLikeStatus( 1 - artwork!.isLiked, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
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
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf, block: {
                    weakSelf.interactService.UpdateFollowStatus((1 - artwork!.isFollowed), targetUserId: artwork!.userID, finish: { (success, error) in
                        if error != nil || success == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
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
        
        artwork = self.dataList[indexPath.row]
        if let work = artwork{
            let detailVC = AGArtworkDetailViewController.init(artwork: work)
            detailVC.dismissBlock = {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}

extension AGBookMarkViewController: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

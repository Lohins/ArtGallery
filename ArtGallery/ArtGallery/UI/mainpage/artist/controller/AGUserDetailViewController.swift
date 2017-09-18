//
//  AGUserDetailViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-05.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu
import SDWebImage

class AGUserDetailViewController: UIViewController {
    
    let service = AGArtistService()
    
    let interactService = AGInteractService()

    
    var user: AGUser!
    
    // 为了保证数据的同步显示，当该页面消失的时候 去reload cell 的内容。
    var dismissBlock: (()-> Void)?

    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var worknumLabel: UILabel!
    
    @IBOutlet weak var joindateLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var followIcon: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followbuttonView: UIImageView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    var worksview: UITableView!
    
    let cell_identifier = "ArtworkNoFollowViewCell"
    
    var worksList = [AGArtwork]()
    
    var isFollowed: Bool = false{
        didSet{
            if user.isFollowed == 1{
                self.followIcon.image = UIImage.init(named:"bookmark_unfollow_icon")
            }
            else{
                self.followIcon.image = UIImage.init(named:"bookmark_follow_icon")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
    }

    func Init(followingartist: AGUser) {
        
        self.user = followingartist
        
        var artistid = 1
        
        if let id = followingartist.artistid{
            artistid = id
        }

        setupUI(artistid: artistid)
        
        self.followerLabel.text = "\(followingartist.followernum) Followers"
        
        if let works = followingartist.worknum{
            self.worknumLabel.text = "\(works) Artworks"
        }

        if let name = followingartist.firstName{
            nameLabel.text = name
        }
        
        if let url = followingartist.photoUrl{
            if let link = URL.init(string: url){
                
                photoView.layer.cornerRadius = 36
                photoView.clipsToBounds = true
                photoView.layer.borderWidth = 1
                photoView.layer.borderColor = UIColor.white.cgColor
                photoView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "bookmark_follow_icon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                
            }
        }
        
        if followingartist.isFollowed == 1{
            self.isFollowed = true
        }
        else{
            self.isFollowed = false
        }
        
        updateData(followingartist: self.user)
        print (followingartist.isFollowed)
    }
    
    
    func setupUI(artistid: Int){
        
        self.navigationController?.isNavigationBarHidden = true

        let height = GlobalValue.SCREENBOUND.height - CGFloat(150 + 44 + 20)
        
        //TODO：根据选择的艺术家显示艺术家主页
        
        
        let TBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData(followingartist: weakSelf.user)
            }
        }
        
        
        worksview = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: height), headerRefreshBlk: TBHeaderBlk)
        worksview.delegate = self
        worksview.dataSource = self
        worksview.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        worksview.top = CGFloat(150)
        self.view.addSubview(worksview)
        
    }
    
    func setupNavBar(){
        self.edgesForExtendedLayout = UIRectEdge()
        
        // 设置 bar 的背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        // 设置 title view
        let titleImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 32))
        titleImgView.image = UIImage.init(named: "welcome_logo")
        titleImgView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImgView
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        backButton.setBackgroundImage(UIImage.init(named: "back_arrow_white"), for: UIControlState.normal)
        backButton.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.navigationController!.popViewController(animated: true)
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

    
    func updateData(followingartist: AGUser){
        let service = AGArtistService()
        let artistid = followingartist.artistid
        service.getWorksListbyArtistid(artistid: artistid!){ [weak self] (list, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                
                weakSelf.worksList = list!
                weakSelf.worksview.reloadData()
            }

        }
    }
    
    @IBAction func followAction(_ sender: AnyObject) {
        ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self, block: { [weak self] () -> Void in
            if let weakSelf = self{
                weakSelf.interactService.UpdateFollowStatus((1 - weakSelf.user.isFollowed), targetUserId: weakSelf.user.userID!, finish: { (flag, error) in
                    if error != nil{
                        return
                    }
                    if flag{
                        weakSelf.user.isFollowed = 1 - weakSelf.user.isFollowed
                        if weakSelf.user.isFollowed == 1{
                            weakSelf.user.followernum += 1
                            weakSelf.isFollowed = true
                        }
                        else{
                            weakSelf.user.followernum -= 1
                            weakSelf.isFollowed = false
                        }
                    }
                    weakSelf.followerLabel.text = "\(weakSelf.user.followernum) Followers"
                })
            }
            
        })
        
    }


}


extension AGUserDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.worksList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(241)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.worksList.count == 0{
            return CGFloat(50)
        }
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.worksList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No data for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! ArtworkNoFollowViewCell
        var artwork:AGArtwork?
        artwork = self.worksList[indexPath.row]
        cell.updateData(artwork: artwork!)
        
        
        // cell的 点赞／评论／ 收藏操作
        cell.collectBlock = { [weak self, weak worksview] () -> Void in
            if let weakSelf = self, let weakTB = worksview{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf, block: {
                    weakSelf.interactService.UpdateCollectStatus( 1 - artwork!.isCollected, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "error", message: "Mark failed.")
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
        
 
        cell.likeBlock = { [weak self, weak worksview] () -> Void in
            if let weakSelf = self, let weakTB = worksview{
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: weakSelf, block: {
                    weakSelf.interactService.UpdateLikeStatus( 1 - artwork!.isLiked, targetWorkId: artwork!.id, finish: { (result, error) in
                        if error != nil || result == false{
                            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "error", message: "Like fail.")
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
            //print("select \(indexPath.row) to comment")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let work = self.worksList[indexPath.row]
        
        let vc = AGArtworkDetailViewController.init(artwork: work)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

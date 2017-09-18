//
//  AGArtistMPFollowView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-04.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

//  Following artist list table view

import UIKit
import HMSegmentedControl


class AGArtistMPFollowView: UIView {
    // 这个 变量表示， 当该页面被第一次创建的时候， 被赋值 为 0，
    // 当 该页面 被初始化界面了之后， 就被赋值为 1，之后就一直是 1
    var onceInitToken: Int = 0
    
    var segmentControl: HMSegmentedControl!
    
    var worksScrollView: AGArtistMPFollowPictureAndVideoView!
    
    var tableView: UITableView
    
    // 显示当前用户 关注的用户列表
    var usersTableView: AGBaseTableView!
    
    var dataList: [String]
    
    var usersList: [AGUser]
    
    var id:Int!
    
    let cell_identifier = "AGBookMarkItemCell"
    let usercell_identifier = "AGArtistUserItemCell"
    
    let service = AGInteractService()
    
    override init(frame: CGRect){
        
        
        self.tableView = UITableView.init()
        self.dataList = [String]()
        self.usersList = [AGUser]()
        super.init(frame: frame)
    }
    
    // 初始化这个页面的时候， 应该传进 id 参数， 然后到服务器去获取 作品 的数据。
    convenience init(frame: CGRect , id: Int){
        self.init(frame : frame)
        
//        setupUI(frame: frame)
//        
//        updateData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func firstTimeInit(){
        if self.onceInitToken == 0{
            setupUI(frame: self.frame)
            updateData()
            self.onceInitToken = 1
        }

    }
    
    
    func updateData(){
        
        service.getFollower(type: 1) { (list, error) in
            if error != nil{
                return
            }
            self.usersList = list!
            self.usersTableView.reloadData()
        }
    }
    
    func setupUI(frame: CGRect){
        //        self.segmentControl = HMSegmentedControl.init(sectionTitles: ["aaa" , "dddd"])
        let imgSize = CGSize.init(width: 35, height: 35)
        let boxImg = UIImage.init(named: "mainpage_myworks_followbox")?.imageScale(size: imgSize )
        let boxOpacityImg = UIImage.init(named: "mainpage_myworks_followbox_opacity")?.imageScale(size: imgSize )
        let lineImg = UIImage.init(named: "mainpage_myworks_followline")?.imageScale(size: imgSize )
        let lineOpacityImg = UIImage.init(named: "mainpage_myworks_followline_opacity")?.imageScale(size: imgSize )
        
        self.segmentControl = HMSegmentedControl.init(sectionImages: [boxOpacityImg! , lineOpacityImg!], sectionSelectedImages: [boxImg!, lineImg!])
        print(self.segmentControl.frame)
        self.segmentControl.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 45)
        self.segmentControl.segmentEdgeInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
        
        self.segmentControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
        self.segmentControl.backgroundColor = UIColor.init(floatValueRed: 176, green: 79, blue: 77, alpha: 1)
        self.segmentControl.selectionIndicatorHeight = 0
        self.segmentControl.isVerticalDividerEnabled = true
        self.segmentControl.verticalDividerWidth = 1
        self.segmentControl.verticalDividerColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.2)
        self.addSubview(self.segmentControl)
        
        // 用一个scroll view 来显示 photo 和 video 的 列表
        self.worksScrollView = AGArtistMPFollowPictureAndVideoView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height), UserId: ArtGalleryAppCenter.sharedInstance.getUserId())
        self.addSubview(self.worksScrollView)
        
        // user table view
        let userTBHeaderBlk = { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }
        self.usersTableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height), headerRefreshBlk: userTBHeaderBlk)

        self.usersTableView.frame = CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height)
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        self.usersTableView.separatorStyle = .none
        self.usersTableView.register(UINib.init(nibName: usercell_identifier, bundle: Bundle.main), forCellReuseIdentifier: usercell_identifier)
        self.addSubview(self.usersTableView)
//        self.usersList = ["Davinci" , "Qi Baishi" , "Jason"]
        self.usersTableView.reloadData()
        
        self.worksScrollView.isHidden = false
        self.usersTableView.isHidden = true

    }
    
    func segmentValueChanged(sender: HMSegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            self.worksScrollView.isHidden = false
            self.usersTableView.isHidden = true
        }
        else{
            self.worksScrollView.isHidden = true
            self.usersTableView.isHidden = false
        }
    }
    
}

extension AGArtistMPFollowView: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.usersList.count == 0{
            return CGFloat(50)
        }
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.usersList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No data for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: usercell_identifier, for: indexPath) as! AGArtistUserItemCell
        cell.updateData(user: self.usersList[indexPath.row])
        cell.selectionStyle = .none
        cell.block = { [weak self] () -> Void in
            if let weakSelf = self{
                let user = weakSelf.usersList[indexPath.row]
                weakSelf.service.UpdateFollowStatus((1 - user.isFollowed), targetUserId: user.userID!, finish: { (flag, error) in
                    if error != nil{
                        return
                    }
                    if flag{
                        user.isFollowed = 1 - user.isFollowed
                        if user.isFollowed == 1{
                            user.followernum += 1
                        }
                        else{
                            user.followernum -= 1
                        }
                        weakSelf.usersTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.usersTableView{
            let userDetailVC = AGUserDetailViewController()
            userDetailVC.Init(followingartist: self.usersList[indexPath.row])
            userDetailVC.dismissBlock = {()-> Void in
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self.getCurrentViewController()?.navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
}

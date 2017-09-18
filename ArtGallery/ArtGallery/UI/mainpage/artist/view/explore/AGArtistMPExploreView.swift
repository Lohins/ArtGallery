//
//  AGArtistMPExploreView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-05.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl

class AGArtistMPExploreView: UIView {
    
    // 这个 变量表示， 当该页面被第一次创建的时候， 被赋值 为 0，
    // 当 该页面 被初始化界面了之后， 就被赋值为 1，之后就一直是 1
    var onceInitToken: Int = 0
    
    var segmentControl: HMSegmentedControl!

    var usersTableView: AGBaseTableView!
    var worksView: AGArtistMPExplorePictureAndVideoView!
    
    var usersList: [AGUser] = [AGUser]()
    let usercell_identifier = "AGArtistUserItemCell"

    var searchService: AGSearchService = AGSearchService()
    
    let interactService = AGInteractService()

    
    override init(frame: CGRect){

        super.init(frame: frame)
        
        // 添加 监听 ， 监听 搜索的关键字
        NotificationCenter.default.addObserver(self, selector: #selector(searchNotification), name: NSNotification.Name(rawValue:"workSearchKeyword"), object: nil)
        // 监听 artist 搜索的 通知
        NotificationCenter.default.addObserver(self, selector: #selector(searchNotification), name: NSNotification.Name(rawValue:"artistSearchKeyword"), object: nil)
    }
    
    func searchNotification(_ notification: Notification){
        guard let dict = notification.object as? Dictionary<String, AnyObject> else{
            return
        }
        
        // 搜索功能  是不需要登录的。
        // 进行 作品的关键词搜索
        if let _ = dict.index(forKey: "workKeyword"){
            let query = dict["workKeyword"] as! String
            
            self.segmentControl.selectedSegmentIndex = 0
            self.segmentValueChanged(sender: self.segmentControl)
            self.worksView.updateWithQuery(query: query)
            
        }
            // 进行艺术家的关键字的搜索
        else{
            let query = dict["artistKeyword"] as! String
            self.segmentControl.selectedSegmentIndex = 1
            self.segmentValueChanged(sender: self.segmentControl)
            self.searchService.searchArtistBy(keyword: query, finish: { (result, error) in
                if error != nil{
                    return
                }
                self.usersList = result!
                self.usersTableView.reloadData()
            })
        }
        
    }
    
    // 初始化这个页面的时候， 应该传进 id 参数， 然后到服务器去获取 作品 的数据。
    convenience init(frame: CGRect , id: Int){
        self.init(frame : frame)
        
        setupUI(frame: frame)
//        updateData()
    }
    
    func firstTimeInit(){
        if self.onceInitToken == 0{
            updateData()
            self.worksView.updateData()
            self.onceInitToken = 1

        }
    }
    
    
    func updateData(){
        let service = AGExploreService()
        service.getExploreArtistInfo{ (list, error) in
            if error != nil{
                return
            }
            
            self.usersList = list!
            self.usersTableView.reloadData()
        
        }
    }
    
    
    func setupUI(frame: CGRect){
        let imgSize = CGSize.init(width: 35, height: 35)
        let worksImg = UIImage.init(named: "explore_works_icon")?.imageScale(size: imgSize )
        let worksOpacityImg = UIImage.init(named: "explore_works_icon_opacity")?.imageScale(size: imgSize )
        let userImg = UIImage.init(named: "explore_users_icon")?.imageScale(size: imgSize )
        let userOpacityImg = UIImage.init(named: "explore_users_icon_opacity")?.imageScale(size: imgSize )
        
        self.segmentControl = HMSegmentedControl.init(sectionImages: [worksOpacityImg! , userOpacityImg!], sectionSelectedImages: [worksImg!, userImg!])
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
        
        
        // 作品展示
        self.worksView = AGArtistMPExplorePictureAndVideoView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height))
        self.addContraint(targetView: self.worksView, toView: self, top: self.segmentControl.bottom, left: 0, bottom: 0, right: 0)
        self.addSubview(self.worksView)
        
        
        // user table view
        let userTBHeaderBlk = { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }
        self.usersTableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height), headerRefreshBlk: userTBHeaderBlk)

        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        self.usersTableView.separatorStyle = .none
        self.usersTableView.register(UINib.init(nibName: usercell_identifier, bundle: Bundle.main), forCellReuseIdentifier: usercell_identifier)
        self.addSubview(self.usersTableView)
        
        
        self.usersTableView.isHidden = true
        
        self.usersTableView.reloadData()
    }
    
    override func layoutSubviews() {
        self.worksView.frame = CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height)
        self.usersTableView.frame = CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height)
        
        print("Here")
        print(self.worksView.frame)
        print(self.usersTableView.frame)
        
    }
    
    func segmentValueChanged(sender: HMSegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            self.worksView.isHidden = false
            self.usersTableView.isHidden = true
        }
        else{
            self.worksView.isHidden = true
            self.usersTableView.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContraint(targetView: UIView , toView: UIView , top:CGFloat , left:CGFloat , bottom: CGFloat , right: CGFloat){
        
        let topC = NSLayoutConstraint.init(item: targetView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: top)
        let leftC = NSLayoutConstraint.init(item: targetView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: left)
        let bottomC = NSLayoutConstraint.init(item: targetView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: bottom)
        let rightC = NSLayoutConstraint.init(item: targetView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: right)
        
        toView.addConstraints([topC , leftC , bottomC, rightC])
    }


}

extension AGArtistMPExploreView: UITableViewDelegate , UITableViewDataSource{
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
        let artist = self.usersList[indexPath.row]
        cell.updateData(user: artist)
        cell.block = { [weak self] () -> Void in
            if let weakSelf = self{
                let user = weakSelf.usersList[indexPath.row]
                weakSelf.interactService.UpdateFollowStatus((1 - user.isFollowed), targetUserId: user.userID!, finish: { (flag, error) in
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
        cell.selectionStyle = .none
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

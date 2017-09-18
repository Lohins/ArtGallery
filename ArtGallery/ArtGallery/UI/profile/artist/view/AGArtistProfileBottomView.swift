//
//  AGArtistProfileBottomView.swift
//  ArtGallery
//
//  Created by S.t on 2016/12/9.
//  Copyright © 2016年 UBIELIFE Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl

class AGArtistProfileBottomView: UIView {
    
    var followersTableView: UITableView!
    
    var Follower_Cell_Identifier = "AGArtistProfileFollowerTBC"
    
    var followersList: [Dictionary<String, AnyObject>] = [Dictionary<String, AnyObject>]()


    var segmentController: HMSegmentedControl!
    var scrollView: UIScrollView!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI()
        
        updateFollowerList()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.white
        let screen_width = GlobalValue.SCREENBOUND.width
        
        // tab 按钮
        segmentController = HMSegmentedControl.init()
        //init(sectionTitles: ["Famous Artworks" , "Followers"])
        self.segmentController.sectionTitles = self.getSegmentSectionTitles()

        segmentController.frame = CGRect.init(x: 0, y: 0, width: screen_width, height: 50)
        self.addSubview(segmentController)
        
        // 设置segment样式
        segmentController.selectionIndicatorHeight = CGFloat(0)
        segmentController.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 0.5) , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(11))!]
        
        segmentController.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1) , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(11))!]
        segmentController.selectedSegmentIndex = 1
        
        // 分割线
        let line_width = screen_width - 30
        let separateLine = UIView.init(frame: CGRect.init(x: 15, y: 0, width: line_width, height: 1))
        separateLine.backgroundColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 0.1)
        separateLine.top = segmentController.bottom
        self.addSubview(separateLine)
        
        // scrollview
        let scrollview_height = self.height - segmentController.height - separateLine.height
        scrollView = UIScrollView.init(frame: CGRect.init(x: 15, y: 0, width: line_width, height: scrollview_height))
        scrollView.contentSize = CGSize.init(width: line_width * 2, height: scrollview_height)
        scrollView.backgroundColor = UIColor.white
        scrollView.top = separateLine.bottom
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: line_width, height: scrollview_height))
        view1.backgroundColor = UIColor.red
        
        let view2 = UIView.init(frame: CGRect.init(x: line_width, y: 0, width: line_width, height: scrollview_height))
        view2.backgroundColor = UIColor.blue
        
        // 艺术家个人信息
        let linearScrollView = getInfoView(frame:  CGRect.init(x: 0, y: 0, width: line_width, height: scrollview_height))
        
        // followers table
        followersTableView = UITableView.init(frame: CGRect.init(x: line_width, y: 0, width: line_width, height: scrollview_height))
        followersTableView.delegate = self
        followersTableView.dataSource = self
        followersTableView.separatorStyle = .none
        followersTableView.register(UINib.init(nibName: Follower_Cell_Identifier, bundle: Bundle.main), forCellReuseIdentifier: Follower_Cell_Identifier)
        
        scrollView.addSubview(linearScrollView)
        scrollView.addSubview(followersTableView)
        
        // 设置 tab 切换的 事件
        segmentController.indexChangeBlock = {[weak self] (index) -> Void in
            if let weakSelf = self{
                weakSelf.segmentController.sectionTitles = weakSelf.getSegmentSectionTitles()
                if index == 0{
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: line_width, height: scrollview_height), animated: true)
                }
                // 显示 follower 列表
                if index == 1{
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(x: line_width, y: 0, width: line_width, height: scrollview_height), animated: true)
                }
            }

        }
    }
    
    func getSegmentSectionTitles() -> [Any]{
        
        let font  = UIFont.init(name: "OpenSans-Bold", size: CGFloat(11))
        let string = "Followers (\(self.followersList.count))"
        let attributesStr = NSMutableAttributedString.init(string: string)
        
        if self.segmentController.selectedSegmentIndex == 0{
            attributesStr.setAttributes([NSForegroundColorAttributeName : UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 0.5),  NSFontAttributeName: font!], range: NSRange.init(location: 0, length: 9))
            attributesStr.setAttributes([NSForegroundColorAttributeName : UIColor.init(floatValueRed: 240, green: 112, blue: 68, alpha: 0.5),  NSFontAttributeName: font!], range: NSRange.init(location: 10, length: string.characters.count - 10))
        }
        else{
            attributesStr.setAttributes([NSForegroundColorAttributeName : UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1),  NSFontAttributeName: font!], range: NSRange.init(location: 0, length: 9))
            attributesStr.setAttributes([NSForegroundColorAttributeName : UIColor.init(floatValueRed: 240, green: 112, blue: 68, alpha: 1),  NSFontAttributeName: font!], range: NSRange.init(location: 10, length: string.characters.count - 10))
        }

        return ["Information" , attributesStr]
    }
    
    func getInfoView(frame: CGRect) -> AGLinearScrollView{
        let linearScrollView = AGLinearScrollView.init(frame: frame)
                
        let artist = ArtGalleryAppCenter.sharedInstance.user! as! ArtGalleryArtistUser
        
        // name item
        let nameItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-Name"), content: artist.userName)
        linearScrollView.linear_addSubview(nameItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // category item
        let categoryItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-Category"), content: artist.info.artworkCategory)
        linearScrollView.linear_addSubview(categoryItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // phone item
        let phoneItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-PhoneNumber"), content: artist.info.phone)
        linearScrollView.linear_addSubview(phoneItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // address item 
        let addressItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-ContactAddress"), content: artist.info.address)
        linearScrollView.linear_addSubview(addressItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // work item
        let workItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-RepresentativeWork"), content: artist.info.representativeWork)
        linearScrollView.linear_addSubview(workItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // email item
        let emailItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-Email"), content: artist.info.email)
        linearScrollView.linear_addSubview(emailItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        // website item
        let websiteItemView = AGArtistProfileInfoItemView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40), title: String.localizedString("AGArtistProfileVC-Website"), content: artist.info.website)
        linearScrollView.linear_addSubview(websiteItemView, paddingTop: CGFloat(10), paddingBottom:  CGFloat(10))
        
        linearScrollView.bounces = false
        
        return linearScrollView
    }
    
    
    func updateFollowerList(){
        let service = AGInteractService()
        service.getFans(type: 0) { [weak self] (list, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                
                weakSelf.followersList = list!
                
                // 更新显示的数据
                weakSelf.segmentController.sectionTitles = weakSelf.getSegmentSectionTitles()
                
                weakSelf.segmentController.setSelectedSegmentIndex(0, animated: true)
                
                weakSelf.followersTableView.reloadData()
            }

        }
    }
    
}


extension AGArtistProfileBottomView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followersList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.followersList.count == 0{
            return CGFloat(50)
        }
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.followersList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No data for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Follower_Cell_Identifier, for: indexPath) as! AGArtistProfileFollowerTBC
        let data = self.followersList[indexPath.row]
        cell.updateData(data: data)
        cell.selectionStyle = .none
        return cell
        
    }
}

//
//  AGArtistProfileVC.swift
//  ArtGallery
//
//  Created by S.t on 2016/12/9.
//  Copyright © 2016年 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGArtistProfileVC: UIViewController {
    
    var headerView: AGProfileHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()


        self.setupNavBar()
        
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar(){
        self.edgesForExtendedLayout = UIRectEdge()
        
        // 设置 bar 的背景色
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString("AGArtistProfileVC-Profile")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
    }
    

    func setupUI(){
        
        // 这个是 profile header 长和宽 比例
        let W_H_Rate = CGFloat(168.0 / 375.0)
        
        let screen_width = GlobalValue.SCREENBOUND.width
        let header_height = screen_width * W_H_Rate
        
        // 顶部的 header， 显示 头像，名字和 类型。
        headerView = AGProfileHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screen_width, height: header_height), name: "Artist Name", type: "Digital Arts")
        
        // tab - famous work 和 followers
        let bottom_view_height = GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT - header_height
        
        let bottomView = AGArtistProfileBottomView.init(frame: CGRect.init(x: 0, y: 0, width: screen_width, height: bottom_view_height))
        bottomView.top = headerView.bottom
        
        self.view.addSubview(headerView)
        self.view.addSubview(bottomView)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.headerView.adjustImageViewClips()
    }


}

extension AGArtistProfileVC: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

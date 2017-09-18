//
//  AGLeftMenuViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-29.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGLeftMenuViewController: UIViewController {
    
    static let sharedInstance:AGLeftMenuViewController = AGLeftMenuViewController()
    
    var bgImageView: UIImageView!
    var linearScrollView: AGLinearScrollView!
    var userItem: AGLeftMenuUserItemView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(floatValueRed: 240, green: 112, blue: 68, alpha: 1)
        
//        setupUIForArtist()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetUI(type: UserType){
        self.cleanUI()
        if type == .Artist {
            setupUIForArtist()
        }else if type == .Visitor{
            setupUIForVisitor()
        }
        else{
            setupUIForSeeAround()
        }
    }
    
    // 由于该 view controller 是单例模式， 所以每一次重新更新界面，都需要把 原先的 ui 清除了。
    func cleanUI(){
        let views = self.view.subviews
        for view in views{
            view.removeFromSuperview()
        }
    }
    
    // 为 artist 创建侧滑栏
    func setupUIForArtist(){
        // 侧滑栏占屏幕的比例

        let fraction = 0.75
        let section_width = GlobalValue.SCREENBOUND.width * CGFloat( fraction)
        self.bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: section_width, height: GlobalValue.SCREENBOUND.height))
        self.bgImageView.image = UIImage.init(named: "leftmenu_bg")
        self.bgImageView.contentMode = .scaleToFill
        self.view.addSubview(self.bgImageView)
        
        let scrollHeight = GlobalValue.SCREENBOUND.height - 140 - 140
        
        self.linearScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 140, width: section_width, height: scrollHeight))
        
        self.view.addSubview(self.linearScrollView)
        
        // main screen
        let mainscreen = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-mainscreen"), iconName: "leftmenu_bookmark")
        mainscreen.actionBlk = { () -> Void in
            let bookmarkVC = AGArtistMainPageViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        // bookmark
        let bookmarkItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-bookmark"), iconName: "leftmenu_bookmark")
        bookmarkItem.actionBlk = { () -> Void in
            let bookmarkVC = AGBookMarkViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        // profile
        let profileItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-profile"), iconName: "leftmenu_profile")
        profileItem.actionBlk = {() -> Void in
            let profileVC = AGArtistProfileVC()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: profileVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        // settings
        let settingsItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-settings"), iconName: "leftmenu_settings")
        settingsItem.actionBlk = { () -> Void in
            let settingsVC = AGSettingViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: settingsVC, withSlideOutAnimation: true, andCompletion: nil)
        }

        
        // upload new artwork
        let uploadItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-upload"), iconName: "leftmenu_upload")
        uploadItem.actionBlk = {
            let vc = AGUploadWorkTypeSelectionVC()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: vc, withSlideOutAnimation: true, andCompletion: nil)

        }
        
        // preference setting
        let preferenceItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-preference"), iconName: "leftmenu_preference")
        preferenceItem.actionBlk = { () -> Void in
            let preferenceVC = AGIArtistFieldSelectViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: preferenceVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        self.linearScrollView.linear_addSubview(mainscreen, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(bookmarkItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(settingsItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(preferenceItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(profileItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(uploadItem, paddingTop: 10, paddingBottom: 0)
        
        // user item 
        userItem = AGLeftMenuUserItemView.init(width: section_width, name: "Artist", iconName: "")
        userItem.bottom = GlobalValue.SCREENBOUND.height
        self.view.addSubview(userItem)
        
    }
    
    // 为 visitor 创建侧滑栏
    func setupUIForVisitor(){
        // 侧滑栏占屏幕的比例
        
        let fraction = 0.75
        let section_width = GlobalValue.SCREENBOUND.width * CGFloat( fraction)
        self.bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: section_width, height: GlobalValue.SCREENBOUND.height))
        self.bgImageView.image = UIImage.init(named: "login_visitor_bg")
        self.bgImageView.contentMode = .scaleToFill
        self.view.addSubview(self.bgImageView)
        
        let scrollHeight = GlobalValue.SCREENBOUND.height - 140 - 140
        
        self.linearScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 140, width: section_width, height: scrollHeight))
        
        self.view.addSubview(self.linearScrollView)
        
        // main screen
        let mainscreen = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-mainscreen"), iconName: "leftmenu_bookmark")
        mainscreen.actionBlk = { () -> Void in
            let bookmarkVC = AGVisitorMainPageViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        // bookmark
        let bookmarkItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-bookmark"), iconName: "leftmenu_bookmark")
        bookmarkItem.actionBlk = { () -> Void in
            let bookmarkVC = AGBookMarkViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        // profile
        //        let profileItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-profile"), iconName: "leftmenu_profile")
        
        
        // settings
        let settingsItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-settings"), iconName: "leftmenu_settings")
        settingsItem.actionBlk = { () -> Void in
            let settingsVC = AGSettingViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: settingsVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        
        // preference setting
        let preferenceItem = AGLeftMenuItemView.init(width: section_width, title: String.localizedString("AGLeftMenuViewController-preference"), iconName: "leftmenu_preference")
        preferenceItem.actionBlk = { () -> Void in
            let preferenceVC = AGIArtistFieldSelectViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: preferenceVC, withSlideOutAnimation: true, andCompletion: nil)
        }
        
        
        self.linearScrollView.linear_addSubview(mainscreen, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(bookmarkItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(settingsItem, paddingTop: 10, paddingBottom: 10)
        self.linearScrollView.linear_addSubview(preferenceItem, paddingTop: 10, paddingBottom: 0)
        // user item
        userItem = AGLeftMenuUserItemView.init(width: section_width, name: "Visitor", iconName: "")
        userItem.bottom = GlobalValue.SCREENBOUND.height
        self.view.addSubview(userItem)
        
    }
    
    // 为see around 创建侧滑栏
    func setupUIForSeeAround(){
        // 侧滑栏占屏幕的比例
        
        let fraction = 0.75
        let section_width = GlobalValue.SCREENBOUND.width * CGFloat( fraction)
        self.bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: section_width, height: GlobalValue.SCREENBOUND.height))
        self.bgImageView.image = UIImage.init(named: "login_visitor_bg")
        self.bgImageView.contentMode = .scaleToFill
        self.view.addSubview(self.bgImageView)
        
        let scrollHeight = GlobalValue.SCREENBOUND.height - 140 - 140
        
        self.linearScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 140, width: section_width, height: scrollHeight))
        
        self.view.addSubview(self.linearScrollView)
        
        // sign up
        let signupItem = AGLeftMenuItemView.init(width: section_width, title: "Sign In", iconName: "leftmenu_bookmark")
        signupItem.actionBlk = { () -> Void in
            let loginVC = AGHomeViewController()
            //self.getCurrentViewController()?.navigationController?.present(loginVC, animated:true, completion: nil)
            SlideNavigationController.sharedInstance().popAllAndSwitch(to: loginVC, withCompletion: nil)
        }
        
        
        self.linearScrollView.linear_addSubview(signupItem, paddingTop: 10, paddingBottom: 10)
    }

}



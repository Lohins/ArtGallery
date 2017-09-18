//
//  AGArtistMainPageViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-04.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl
import iOS_Slide_Menu

class AGArtistMainPageViewController: UIViewController {
    
    var segmentedControl: HMSegmentedControl!
    
    // 整个试图控制器的 主 view
    var mainView: AGLinearScrollView!
    
    var scrollView: UIScrollView!
    
    var followView: AGArtistMPFollowView!
    var exploreView: AGArtistMPExploreView!
    var whatsnewView: AGNewsView!
    var myWorksView: AGArtistMPMyWorksView!
    
    var exploreSearchView: AGExploreSearchView!
    
    var segTitlesArray:[String]{
        var array = [String]()
        array.append(String.localizedString("AGArtistMainPageViewController-myworks"))
        array.append(String.localizedString("AGArtistMainPageViewController-following"))
        array.append(String.localizedString("AGArtistMainPageViewController-explore"))
        array.append(String.localizedString("AGArtistMainPageViewController-whatsnew"))

        return array
    }
    
    // 当前是否是 search 状态
    var searchStatus: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()

        setupUI()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 当 页面出现的时候， 及时更新当前选择的这个 tab view
        switch(self.segmentedControl.selectedSegmentIndex){
        // 我的作品
        // Note ：当再次显示 该界面的时候 进行更新的理由是 ，可能在之前的 作品详细页面， 用户修改了信息，需要及时更新。 由于 我的作品详情的 入口 只有 AGArtistMPMyWorksView， 所以 如果 返回的时候 选择的是 AGArtistMPMyWorksView， 说明 需要 进行更新， 而如果不是， 就不需要更新， 减少消耗。
        case 0:
            ArtGalleryAppCenter.sharedInstance.sendNotification(for: Notification.Name("AGArtistMPMyWorksView-UpdateWhenShow"), data: [:])
        // 我关注的
        case 1:
            break
        // 发现作品
        case 2:
            break
        // news
        case 3:
            break
        default:
            break
        }
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
        
        // 设置nav bar 的左边按钮
        let leftBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        leftBtn.setImage(UIImage.init(named: "navbar_menu"), for: .normal)
        leftBtn.addTarget(SlideNavigationController.sharedInstance(), action: #selector(SlideNavigationController.sharedInstance().toggleLeftMenu), for: .touchUpInside)
        SlideNavigationController.sharedInstance().leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
        SlideNavigationController.sharedInstance().enableSwipeGesture = true
        print(SlideNavigationController.sharedInstance().leftMenu)
        
        // 添加 导航栏 右上角的 搜索按钮
        let searchBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        searchBtn.setImage(UIImage.init(named: "explore_search_icon"), for: .normal)
        searchBtn.addTarget(self, action: #selector(exploreSearchAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: searchBtn)
    }
    
    func exploreSearchAction(){
        if self.searchStatus == true{
            self.searchStatus = false
            self.mainView.linear_removeViewAtIndex(0)
            // 更新 explore view的大小
            self.exploreView.frame = CGRect.init(x: self.exploreView.frame.origin.x, y: self.exploreView.frame.origin.y, width: self.exploreView.frame.size.width, height: self.exploreView.frame.size.height + self.exploreSearchView.height)
            
            self.exploreView.layoutIfNeeded()
            print(self.exploreView.frame)
            print(self.exploreView.usersTableView.frame)
        }
        else{
            self.searchStatus = true
            // 插入搜索框
            self.mainView.linear_insertViewAtIndex(0, view: self.exploreSearchView, paddingTop: 0, paddingBottom: 0)
            // scroll view index 转到 explore 页面 , 第二个页面
            self.scrollView.scrollRectToVisible(CGRect.init(x: GlobalValue.SCREENBOUND.width * CGFloat( 2 ), y: 0, width: GlobalValue.SCREENBOUND.width, height: self.scrollView.height), animated: false)
            self.segmentedControl.selectedSegmentIndex = 2
            
            // 更新 explore view的大小
            self.exploreView.frame = CGRect.init(x: self.exploreView.frame.origin.x, y: self.exploreView.frame.origin.y, width: self.exploreView.frame.size.width, height: self.exploreView.frame.size.height - self.exploreSearchView.height)
            self.exploreView.layoutIfNeeded()
            print(self.exploreView.frame)
            print(self.exploreView.usersTableView.frame)
        }
    }
    
    
    func setupUI(){
        // 初始化 主 scroll view
        self.mainView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT))
        self.view.addSubview(mainView)
        
        // search view
        self.exploreSearchView = AGExploreSearchView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 60))
        
        
        // Step 1. 添加 segment tab bar : 
        // artist 有四个： My Works, Following, Explore , What's New
        let segment_height = CGFloat(55)
        self.segmentedControl = HMSegmentedControl.init(sectionTitles: self.segTitlesArray)
        self.segmentedControl.frame = CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: CGFloat(segment_height))
        self.segmentedControl.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin , UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleBottomMargin ]
        // 设置选择指示器的 样式， 这里选择箭头
        self.segmentedControl.selectionStyle = .arrow
        self.segmentedControl.selectionIndicatorLocation = .down
        self.segmentedControl.addTarget(self, action: #selector(segmentControlValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.segmentedControl.selectionIndicatorHeight = CGFloat(10)
        self.segmentedControl.selectionIndicatorColor = UIColor.init(floatValueRed: 176, green: 79, blue: 77, alpha: 1)
        self.segmentedControl.backgroundColor = UIColor.init(floatValueRed: 240, green: 112, blue: 68, alpha: 1)
        // 设置字体颜色。 white + opacity: 50%
        self.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5) , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(11))!]
        
        self.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(11))!]
        self.segmentedControl.selectedSegmentIndex = 0

        self.mainView.linear_addSubview(self.segmentedControl, paddingTop: 0, paddingBottom: 0)

//        self.view.addSubview(self.segmentedControl)
        
        
        
        // Step 2: Scroll View 
        let scroll_height = GlobalValue.SCREENBOUND.height - segment_height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.segmentedControl.bottom, width: GlobalValue.SCREENBOUND.width, height: scroll_height))
        self.scrollView.isScrollEnabled = false
        self.mainView.linear_addSubview(self.scrollView, paddingTop: 0, paddingBottom: 0)

//        self.view.addSubview(self.scrollView)
        
        // scroll view 中包含了 4个view。
        self.scrollView.contentSize = CGSize.init(width: GlobalValue.SCREENBOUND.width * 4, height: scroll_height)
        
        // view 1  我的作品
        myWorksView = AGArtistMPMyWorksView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: scroll_height), id: 1)
        // 第一个选中的界面是 myworks
        myWorksView.firstTimeInit()
        
        // view 2  我关注的
        followView = AGArtistMPFollowView.init(frame: CGRect.init(x: myWorksView.right, y: 0, width: GlobalValue.SCREENBOUND.width, height: scroll_height), id: 1)
        
        // view 3  搜索
        exploreView = AGArtistMPExploreView.init(frame: CGRect.init(x: followView.right, y: 0, width: GlobalValue.SCREENBOUND.width, height: scroll_height), id: 1)
        
        // view 4  新闻和展览
        whatsnewView = AGNewsView.init(frame: CGRect.init(x: exploreView.right, y: 0, width: GlobalValue.SCREENBOUND.width, height: scroll_height), id: 1)
        
        self.scrollView.addSubview(myWorksView)
        self.scrollView.addSubview(followView)
        self.scrollView.addSubview(exploreView)
        self.scrollView.addSubview(whatsnewView)
        
        
        self.segmentedControl.indexChangeBlock = {[weak self] (index: NSInteger)-> Void in
            if let weakSelf = self{
                
                switch index {
                case 0:
                    weakSelf.myWorksView.firstTimeInit()
                case 1:
                    weakSelf.followView.firstTimeInit()
                case 2:
                    weakSelf.exploreView.firstTimeInit()
                case 3:
                    weakSelf.whatsnewView.firstTimeInit()
                default:
                    break
                }
                if index != 2{
                    // 如果当前是搜索状态，先消除搜索栏
                    if weakSelf.searchStatus == true{
                        weakSelf.mainView.linear_removeViewAtIndex(0)
                        weakSelf.searchStatus = false
                        // 更新 explore view的大小
                        weakSelf.exploreView.frame = CGRect.init(
                            x: weakSelf.exploreView.frame.origin.x,
                            y: weakSelf.exploreView.frame.origin.y,
                            width: weakSelf.exploreView.frame.size.width,
                            height: weakSelf.exploreView.frame.size.height + weakSelf.exploreSearchView.height)
                    }
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(
                        x: GlobalValue.SCREENBOUND.width * CGFloat( index ),
                        y: 0,
                        width: GlobalValue.SCREENBOUND.width,
                        height: scroll_height),
                        animated: false)
                }
                else{
                    //                self.searchStatus = true
                    weakSelf.scrollView.scrollRectToVisible(CGRect.init(
                        x: GlobalValue.SCREENBOUND.width * CGFloat( index ),
                        y: 0,
                        width: GlobalValue.SCREENBOUND.width,
                        height: scroll_height),
                        animated: false)
                }
            }

        }
        
    }
    
    func segmentControlValueChanged(sender: HMSegmentedControl){
    }
    

    

}

extension AGArtistMainPageViewController: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
}

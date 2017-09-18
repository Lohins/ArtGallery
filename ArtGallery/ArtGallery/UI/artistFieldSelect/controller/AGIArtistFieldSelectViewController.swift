//
//  AGIArtistFieldSelectViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-28.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGIArtistFieldSelectViewController: UIViewController {


    var subjectsView: AGArtistSubjectView!
    var categoryViews: [AGArtistCategoryView] = [AGArtistCategoryView]()
    
    let service = AGPreferenceService()
    
    
    @IBOutlet weak var scrollView: AGLinearScrollView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        UserDefaults.standard.synchronize()
        setupNavBar()
        setupUI()
        
        updateData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar(){
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.isNavigationBarHidden = false

        // 设置 bar 的背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        // 设置 title view
        let titleImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 32))
        titleImgView.image = UIImage.init(named: "welcome_logo")
        titleImgView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImgView
        
        // 隐藏 navigation 自带的返回按钮
        self.navigationItem.hidesBackButton = true
        
        // ---
        let fillButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: fillButton)

        self.navigationItem.hidesBackButton = true
    }
    
    func setupUI(){
        self.scrollView.frame = CGRect.init(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - 110 - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT)
    }
    
    func updateUI(subList: [AGSubject] , TagDict: Dictionary<String , [AGTag]>){
        self.scrollView.linear_removeAllSubviews()
        
        self.subjectsView = AGArtistSubjectView.init(frame: GlobalValue.SCREENBOUND, list: subList)
        self.scrollView.linear_addSubview(self.subjectsView, paddingTop: 0, paddingBottom: 0)
        
        // category title label
        let categoryLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 20))
        categoryLabel.text = String.localizedString("AGArtistFieldSelctVC-category")
        categoryLabel.textColor = UIColor.white
        categoryLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        categoryLabel.textAlignment = .center
        self.scrollView.linear_addSubview(categoryLabel, paddingTop: 10, paddingBottom: 0)
        
        // category
        for key in TagDict.keys{
            let categoryView = AGArtistCategoryView.init(frame: GlobalValue.SCREENBOUND, list: TagDict[key]!, title: key)
            self.scrollView.linear_addSubview(categoryView, paddingTop: 0, paddingBottom: 0)
            self.categoryViews.append(categoryView)
        }
        
    }
    
    func localization(){
        
        print(String.localizedString("AGArtistFieldSelctVC-random"))
        print(String.localizedString("AGArtistFieldSelctVC-continue"))
        
        skipButton.setTitle(String.localizedString("AGArtistFieldSelctVC-random"), for: .normal)
        continueButton.setTitle(String.localizedString("AGArtistFieldSelctVC-continue"), for: .normal)

    }
    
    func updateData(){
        // 获取网络数据
        
        service.getPreferenceInfo { (subList, TagDict, cateDict, error) in
            if error != nil{
                self.updateUI(subList: [], TagDict: [:])
                return
            }
            
            if let subList = subList , let TagDict = TagDict{
                
                // 获取 subject 列表和 tag 列表
                self.updateUI(subList: subList, TagDict: TagDict)
                
                // 接着去获取 用户 已经选择的 列表
                ArtGalleryAppCenter.sharedInstance.runAfterLogin(sourceVC: self, block: { 
                    self.service.getUserPreferenceSetting(userid: ArtGalleryAppCenter.sharedInstance.user!.userId, finish: { (subList, tagList, error) in
                        if error != nil{
                            return
                        }
                        self.subjectsView.setSelectedList(list: subList!)
                        for view in self.categoryViews{
                            view.setSelectedList(list: tagList!)
                        }
                    })
                })
                
            }
        }
    }
    

    
    // 不是skip， 是随机产生 选择
    @IBAction func skipAction(_ sender: AnyObject) {
        self.subjectsView.randomDistribution()
        
        for view in self.categoryViews{
            view.randomDistribution()
        }
    }

    @IBAction func continueAction(_ sender: AnyObject) {
        
        //print(self.subjectsView.summary())
            
        // 更新 用户的tags
        var tagIdList = [Int]()
        for view in self.categoryViews{
            tagIdList.append(contentsOf: view.getSelectedList())
            print(view.summary())
        }
        
        self.service.updateUserTagPreference(list: tagIdList) { (success) in
            if success{
                print("Update user tag preference succeed.")
            }
            else{
                print("Update user tag preference fail.")
            }
        }
        
        // 更新用户的 subject 
        let subIdList = self.subjectsView.getSelectedList()
        
        self.service.updateUserSubjectPreference(list: subIdList) { (success) in
            if success{
                print("Update user subject preference succeed.")
            }
            else{
                print("Update user subject preference fail.")
            }
        }
        
        if ArtGalleryAppCenter.sharedInstance.user!.userType == .Visitor{
            let mainPage = AGVisitorMainPageViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: mainPage, withCompletion: nil)
        }
        
        else if ArtGalleryAppCenter.sharedInstance.user!.userType == .Artist{
            let mainPage = AGArtistMainPageViewController()
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: mainPage, withCompletion: nil)
        }
    }
}

extension AGIArtistFieldSelectViewController: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}



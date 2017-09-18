//
//  AGVisitorCreateViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-10-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGVisitorCreateViewController: UIViewController {
    
    var mainScrollView: AGLinearScrollView!
    var emailBox: AGHasIconTextbox!
    var passwordBox: AGHasIconTextbox!
    var nickNameBox: AGHasIconTextbox!
    var RegionBox: AGDropListBox!
    var signupBtn: UIButton!
    var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupNavBar()
    
        self.setupUI()
        
        self.updateData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
    
    // 获取 region id 的数据
    func updateData(){
        let regionService = AGGetRegion()
        
        regionService.getRegionList { [weak self] (list, error) in
            if let weakSelf = self{
                if error != nil || list?.count == 0{
                    let alertVC = UIAlertController.init(title: "Network Error", message: "Can't get region info.", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(action)
                    weakSelf.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                weakSelf.RegionBox.updateData(list: list!)
                
            }
        }
    }
    
    func createUser(){
        guard let email = self.emailBox.getInfo() , email != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Error", message: "Email is missing.")
            return
        }
        
        // 是否是合适的邮箱的格式
        if !email.isValidEmail(){
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("InvalidEmail"))
            return
        }
        
        guard let pwd = self.passwordBox.getInfo() , pwd != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Error", message: "Password is missing.")
            return
        }
        
        guard let nickName = self.nickNameBox.getInfo(), nickName != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Error", message: "Display Name is missing.")
            return
        }
        
        guard let regionId = self.RegionBox.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Error", message: "Region is missing.")
            return
        }
        
        
        let signupService = AGSignupService()
        
        signupService.VisitorSignup(pass: pwd, nick: nickName, photourl: "", email: email, regionid: regionId) { [weak self] (status, error) -> Void in
            if let weakSelf = self{
                if error != nil || status == 0{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("NetworkError"))
                    return
                }
                if status == 2{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("AGArtistCreateViewController-ExistEmail"))
                    return
                }
                
                UserDefaults.standard.set(email, forKey: "visitor_email")
                UserDefaults.standard.synchronize()
                
                let requireVC = AGVisitorActionRequiredViewController()
                weakSelf.navigationController?.present(requireVC, animated: true, completion: nil)
            }
        }
    }
    
    func setupNavBar(){
        
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
            }
            })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        // ----
        let fillButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: fillButton)
        
        self.navigationItem.hidesBackButton = true
    }
    
    func setupUI(){
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT))
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.bounces = false
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.bgImageView = UIImageView.init()
        self.mainScrollView.addSubview(self.bgImageView)
        
        let boxWidth = GlobalValue.SCREENBOUND.width - 25 * 2
        let boxHeight = CGFloat(55)

        
        // label -- "CREATE ARTIST ACCOUNT"
        let label1 = AGTitleLabel.init(title: "CREATE VISITOR ACCOUNT")
        self.mainScrollView.linear_addSubview(label1, paddingTop: 16, paddingBottom: 0)
        
        // choose Email
        self.emailBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_email_icon", text: "Email Address", isSecureText: false)
        self.emailBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.emailBox, paddingTop: 14, paddingBottom: 0)
        
        // choose password
        self.passwordBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_pwd_icon", text: "Choose Password", isSecureText: false)
        self.passwordBox.textField.isSecureTextEntry = true
        self.passwordBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.passwordBox, paddingTop: 14, paddingBottom: 0)
        
        // nick name box
        self.nickNameBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_username_icon", text: "Display Name (Required)",isSecureText: false)
        self.nickNameBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.nickNameBox, paddingTop: 14, paddingBottom: 0)
        
        // Region
        self.RegionBox = AGDropListBox.init(frame: CGRect.init(x: 0, y: 25, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: "Region")
        self.RegionBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.RegionBox, paddingTop: 14, paddingBottom: 0)
        
        // sign up button
        self.signupBtn = UIButton.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: boxHeight))
        self.signupBtn.setBackgroundImage(UIImage.init(named: "btn_orange_bg"), for: UIControlState.normal)
        self.signupBtn.setTitle("Sign Up", for: UIControlState.normal)
        self.signupBtn.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        self.mainScrollView.linear_addSubview(self.signupBtn, paddingTop: 26, paddingBottom: 0)
        
        // label -- Terms and COnditions
        let label4 = UILabel.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: 20))
        label4.text = "Terms and Conditions"
        label4.textColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5)
        label4.font = UIFont.init(name: "OpenSans", size: 12)
        label4.textAlignment = .center
        self.mainScrollView.linear_addSubview(label4, paddingTop: 6, paddingBottom: 20)
        
        print(self.mainScrollView.contentSize)
        self.bgImageView.frame = CGRect.init(x: 0, y: 0, width: self.mainScrollView.contentSize.width, height: self.mainScrollView.contentSize.height)
        //  self.bgImageView.image = UIImage.init(named: "login_visitor_bg")
        self.bgImageView.contentMode = .scaleAspectFill
    }
}

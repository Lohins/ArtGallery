//
//  AGVisitorLoginViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-10-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import iOS_Slide_Menu

class AGVisitorLoginViewController: UIViewController {
    
    var linearScrollView: AGLinearScrollView!
    
    var emailBox: AGHasIconTextbox!
    
    var pwdBox: AGHasIconTextbox!
    
    var progress: UIActivityIndicatorView!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavBar()
        
        setupUI()

    }
    
    func setupUI(){
        let frame_width = GlobalValue.SCREENBOUND.width
        let frame_height = GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT
        
        self.linearScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: frame_width, height: frame_height))
        self.view.addSubview(self.linearScrollView)
        // logo
        let iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: frame_height * 0.12, width: frame_width * 0.54, height: frame_width * 0.54 * 0.32))
        iconImageView.image = UIImage.init(named: "welcome_logo")
        iconImageView.center = CGPoint.init(x: frame_width / 2, y: iconImageView.center.y)
        self.linearScrollView.linear_addSubview(iconImageView, paddingTop: frame_height * 0.045, paddingBottom: 0)
        
        // artist logo
        let icon_rate = CGFloat( 0.4 )
        let icon_width = frame_width * icon_rate
        let artistLogo = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: icon_width, height: icon_width))
        artistLogo.image = UIImage.init(named: "main_user_icon")
        artistLogo.center = CGPoint.init(x: frame_width / 2, y: 0)
        self.linearScrollView.linear_addSubview(artistLogo, paddingTop: 17, paddingBottom: 0)
        
        let boxWidth = GlobalValue.SCREENBOUND.width - 25 * 2
        let boxHeight = CGFloat(55)
        // email input

        self.emailBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_email_icon", text: String.localizedString("AGVisitorLoginViewController-EmailAddress"), isSecureText: false)
        self.emailBox.center = CGPoint.init(x: frame_width / 2, y: 0)
        self.linearScrollView.linear_addSubview(emailBox, paddingTop: 20, paddingBottom: 0)
        
        // set default signin account
        if let defaultemail = UserDefaults.standard.string(forKey: "visitor_email"){
            self.emailBox.textField.text = defaultemail
        }
        
        // pwd input
        self.pwdBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_pwd_icon", text: String.localizedString("AGVisitorLoginViewController-Password"), isSecureText: true)
        self.pwdBox.center = CGPoint.init(x: frame_width / 2, y: 0)
        self.linearScrollView.linear_addSubview(pwdBox, paddingTop: 15, paddingBottom: 0)
        
        
        // Get Started button
        let buttonView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight))
        buttonView.center = CGPoint.init(x: frame_width / 2, y: 0)
        
        let bgImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight))
        bgImgView.image = UIImage.init(named: "btn_orange_bg")
        bgImgView.contentMode = .scaleToFill
        buttonView.addSubview(bgImgView)
        
        let startButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight))
        startButton.setTitle(String.localizedString("AGVisitorLoginViewController-GetStarted"), for: .normal)
        startButton.titleLabel?.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        startButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        buttonView.addSubview(startButton)
        self.linearScrollView.linear_addSubview(buttonView, paddingTop: 15, paddingBottom: 0)
        
        
        // forget pwd and create account
        let botView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: 30))
        botView.center = CGPoint.init(x: frame_width / 2, y: 0)
        
        // create account
        let createAccountLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth / 2, height: 30))
        createAccountLabel.font = UIFont.init(name: "OpenSans", size: 12)
        createAccountLabel.textColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5)
        createAccountLabel.text = String.localizedString("AGVisitorLoginViewController-CreateAccount")
        createAccountLabel.textAlignment = .left
        let createAccountBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth / 2, height: 30))
        createAccountBtn.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        // forget pwd
        let forgetPwdLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth / 2, height: 30))
        forgetPwdLabel.font = UIFont.init(name: "OpenSans", size: 12)
        forgetPwdLabel.textColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5)
        forgetPwdLabel.text = String.localizedString("AGVisitorLoginViewController-ForgetPassword")
        forgetPwdLabel.textAlignment = .right
        forgetPwdLabel.right = botView.width
        let forgetPwdBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth / 2, height: 30))
        forgetPwdBtn.right = botView.width
        forgetPwdBtn.addTarget(self, action: #selector(retrieveAction), for: .touchUpInside)
        
        botView.addSubview(createAccountLabel)
        botView.addSubview(createAccountBtn)
        botView.addSubview(forgetPwdLabel)
        botView.addSubview(forgetPwdBtn)
        
        self.linearScrollView.linear_addSubview(botView, paddingTop: 20, paddingBottom: 0)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        LanguageStandardization()
        self.navigationController?.isNavigationBarHidden = false
        
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
        
        // 设置 title view
        // 由于 语言版本的原因， title label 的设置在 func LanguageStandardization 中设置
        self.navigationItem.hidesBackButton = true
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        backButton.setBackgroundImage(UIImage.init(named: "back_arrow_white"), for: UIControlState.normal)
        backButton.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.navigationController!.popViewController(animated: true)
            }
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
    }

    // 更新语言
    func LanguageStandardization(){
        
        let ClassName = String.init(describing: type(of : self))
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString(ClassName + "-NavTitle")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        
    }
    
    
    @IBAction func loginAction(_ sender: AnyObject){
        //验证通过后更新身份
        
        guard let email = self.emailBox.getInfo() , email != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("AGArtistLoginViewController-EmailMissing"))
            return
        }
        
        guard let pwd = self.pwdBox.getInfo() , pwd != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("AGArtistLoginViewController-PWDMissing"))
            return
        }
        
        // 是否是合适的邮箱的格式
        if !email.isValidEmail(){
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("InvalidEmail"))
            return
        }
        
        self.progress = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.progress.frame = self.linearScrollView.frame
        self.progress.center = self.linearScrollView.center
        self.view.addSubview(self.progress)
        self.progress.startAnimating()
        
        let loginService = AGLoginService()
        
        loginService.UserLogin(email: email, pass: pwd) { [weak self] (flag, error) in
            if let weakSelf = self{
                if flag == false {
                    let err = error as NSError
                    weakSelf.progress.stopAnimating()
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: err.domain)
                    return
                }
                
                // 检查 当前用户 是否有 偏好设置
                let visitor = ArtGalleryAppCenter.sharedInstance.user! as! ArtGalleryVisitorUser
                
                // 没有偏好设置的 去设置
                if visitor.info.tagList == [] && visitor.info.subjectList == []{
                    print ("no preference setting record.")
                    let vc = AGInterestSelectViewController()
                    AGLeftMenuViewController.sharedInstance.resetUI(type: .Visitor)
                    weakSelf.progress.stopAnimating()
                    SlideNavigationController.sharedInstance().popToRootAndSwitch(to: vc, withSlideOutAnimation: true, andCompletion: nil)
                }
                    // 设置过的 去普通用户主页
                else{
                    let mainPage = AGVisitorMainPageViewController()
                    AGLeftMenuViewController.sharedInstance.resetUI(type: .Visitor)
                    weakSelf.progress.stopAnimating()
                    SlideNavigationController.sharedInstance().popToRootAndSwitch(to: mainPage, withCompletion: nil)
                }
            }
        }
    }

    func createAccountAction(_ sender: AnyObject) {
        let createVC = AGVisitorCreateViewController()
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    
    func retrieveAction(_ sender: AnyObject) {
        let retrieveVC = AGVisitorForgetPWDViewController()
        self.navigationController?.pushViewController(retrieveVC, animated: true)
    }
    
}

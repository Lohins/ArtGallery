//
//  AGArtistCreateViewController.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class AGArtistCreateViewController: UIViewController {

    
    var mainScrollView: AGLinearScrollView!
    
    var usernameBox: AGHasIconTextbox!
    var passwordBox: AGHasIconTextbox!
    
    var nickNameBox: AGNoIconTextbox!
    var ageBox : AGNoIconTextbox!
    var genderBox: AGDropListBox!
    var categoryBox: AGDropListBox!
    
    
    var representativeBox: AGNoIconTextbox!
    var websiteBox: AGNoIconTextbox!
    
    
    var emailBox: AGHasIconTextbox!
    var phoneBox: AGNoIconTextbox!
    var addressBox: AGNoIconTextbox!
    var RegionBox: AGDropListBox!
    
    
    var signupBtn: UIButton!
    var bgImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        
        self.setupUI()
        
        self.updateData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func updateData(){
        // 获取 region数据
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
        
        // 获取 Category数据
        let categoryService = AGPreferenceService()
        var categoryList : [AGRegion] = [AGRegion]()
        categoryService.getPreferenceInfo { [weak self](subList, TagDict, cateDict, error) in
            if let weakSelf = self{
                if error != nil{
                    let alertVC = UIAlertController.init(title: "Network Error", message: "Can't get category info.", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(action)
                    weakSelf.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                if let Dict = cateDict{
                    for element in Dict{
                        let tmp:AGRegion = AGRegion.init(key:element.key, value:element.value)
                        categoryList.append(tmp)
                    }
                }
                weakSelf.categoryBox.updateData(list: categoryList)
            }
        }
        
        // 用AGRegion的格式 设定 性别数据
        var GenderList:[AGRegion] = [AGRegion]()
        let male:AGRegion = AGRegion.init(key:"Male",value:1)
        let female:AGRegion = AGRegion.init(key:"Female",value:0)
        GenderList.append(male)
        GenderList.append(female)
        self.genderBox.updateData(list: GenderList)
        
        

    }
    
    func setupUI(){
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        let ClassName = String.init(describing: type(of : self))
        
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT))
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.bounces = false
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.showsHorizontalScrollIndicator = false
        
        self.bgImageView = UIImageView.init()
        self.mainScrollView.addSubview(self.bgImageView)
        
        
        let boxWidth = GlobalValue.SCREENBOUND.width - 25 * 2
        let boxHeight = CGFloat(55)
        
        // ----------------  Part 1 (用户名 和 密码) ---------------------
        
        // label -- "CREATE ARTIST ACCOUNT"
        let label1 = AGTitleLabel.init(title: String.localizedString(ClassName + "-Section1Title"))
        self.mainScrollView.linear_addSubview(label1, paddingTop: 16, paddingBottom: 0)
        
        // choose username
        self.emailBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_email_icon", text: String.localizedString(ClassName + "-EmailAddress"),isSecureText: false)
        self.emailBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.emailBox, paddingTop: 14, paddingBottom: 0)
        
        // choose password
        self.passwordBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_pwd_icon", text: String.localizedString(ClassName + "-ChoosePWD"), isSecureText: false)
        self.passwordBox.textField.isSecureTextEntry = true
        self.passwordBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.passwordBox, paddingTop: 14, paddingBottom: 0)
        
        // ----------------  Part 2 (个人信息) ---------------------

        
        // label -- Personal Information
        let label2 = AGTitleLabel.init(title: String.localizedString(ClassName + "-Section2Title"))
        self.mainScrollView.linear_addSubview(label2, paddingTop: 32, paddingBottom: 0)
        
        // nick name box
        self.nickNameBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString(ClassName + "-CompleteName"), isSecure: false)
        self.nickNameBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.nickNameBox, paddingTop: 14, paddingBottom: 0)
        

        
        // age
        let dropBoxWidth = (GlobalValue.SCREENBOUND.width - 25 * 3) / 2
        
        self.ageBox = AGNoIconTextbox.init(frame: CGRect.init(x: 25, y: 0, width: dropBoxWidth, height: 55),bgImgName: "short_textbox_bg_clear" , text: String.localizedString(ClassName + "-Age"), isSecure: false)

        // gender
        self.genderBox = AGDropListBox.init(frame: CGRect.init(x: self.ageBox.right + 25, y: 0, width: dropBoxWidth, height: 55),bgImgName: "short_textbox_bg_clear" , text: String.localizedString(ClassName + "-Gender"))
        let rowView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 55))
        rowView.addSubview(self.ageBox)
        rowView.addSubview(self.genderBox)
        self.mainScrollView.linear_addSubview(rowView, paddingTop: 14, paddingBottom: 0)
        
        // category
        self.categoryBox = AGDropListBox.init(frame: CGRect.init(x: 0, y: 25, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString(ClassName + "-Category"))
        self.categoryBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.categoryBox, paddingTop: 14, paddingBottom: 0)
        
        // Representative work box
        self.representativeBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight),bgImgName: "login_textbox_bg_clear" , text: String.localizedString(ClassName + "-RepresentativeWork"), isSecure: false)
        self.representativeBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.representativeBox, paddingTop: 14, paddingBottom: 0)
        
        // website box
        self.websiteBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString(ClassName + "-Website"),isSecure: false)
        self.websiteBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.websiteBox, paddingTop: 14, paddingBottom: 0)
        
        // ----------------  Part 3 (联系方式) --------------------
        
        // label -- Contact Informations
        let label3 = AGTitleLabel.init(title: String.localizedString(ClassName + "-Section3Title"))
        self.mainScrollView.linear_addSubview(label3, paddingTop: 32, paddingBottom: 0)
        
        // phone number
        self.phoneBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight),bgImgName: "login_textbox_bg_clear" , text: String.localizedString(ClassName + "-PhoneNum"), isSecure: false)
        self.phoneBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.phoneBox, paddingTop: 14, paddingBottom: 0)
        
        // address box
        self.addressBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString(ClassName + "-CompleteAddress"), isSecure: false)
        self.addressBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.addressBox, paddingTop: 14, paddingBottom: 0)
        
        // region droplist
        self.RegionBox = AGDropListBox.init(frame: CGRect.init(x: 0, y: 25, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString(ClassName + "-Region"))
        self.RegionBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.mainScrollView.linear_addSubview(self.RegionBox, paddingTop: 14, paddingBottom: 0)
        
        // sign up button
        self.signupBtn = UIButton.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: boxHeight))
        self.signupBtn.setBackgroundImage(UIImage.init(named: "btn_orange_bg"), for: UIControlState.normal)
        self.signupBtn.setTitle(String.localizedString(ClassName + "-Signup"), for: UIControlState.normal)
        self.signupBtn.addTarget(self, action: #selector(createArtist), for: .touchUpInside)
        self.mainScrollView.linear_addSubview(self.signupBtn, paddingTop: 26, paddingBottom: 0)
        
        // label -- Terms and COnditions
        let label4 = UILabel.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: 20))
        label4.text = String.localizedString(ClassName + "-Terms")
        label4.textColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5)
        label4.font = UIFont.init(name: "OpenSans", size: 12)
        label4.textAlignment = .center
        self.mainScrollView.linear_addSubview(label4, paddingTop: 6, paddingBottom: 20)

        
        print(self.mainScrollView.contentSize)
        self.bgImageView.frame = CGRect.init(x: 0, y: 0, width: self.mainScrollView.contentSize.width, height: self.mainScrollView.contentSize.height)
        self.bgImageView.image = UIImage.init(named: "signup_bg")
        self.bgImageView.contentMode = .scaleAspectFill
        
        
    }
    
    func updateBGView(){
        let image = UIImage.init(named: "signup_bg")
        let originalSize = image?.size
        
        let scale = (originalSize?.width)! / GlobalValue.SCREENBOUND.width
        let scaleWidth = GlobalValue.SCREENBOUND.height
        let scaleHeight = GlobalValue.SCREENBOUND.height * scale
        
        self.bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        self.bgImageView.image = image
        self.bgImageView.contentMode = .scaleAspectFill
//        self.view.addSubview(bgImageView)
    }
    

    func setupNavBar(){
        self.navigationController?.isNavigationBarHidden = false

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
    
    func createArtist(){
        guard let email = self.emailBox.getInfo(), email != "", let pwd = self.passwordBox.getInfo() , pwd != "",let Name = self.nickNameBox.getInfo(), Name != "", let regionId = self.RegionBox.getInfo(), let age = self.ageBox.getIntInfo(), age != -1, let gender = self.genderBox.getInfo() , let category = self.categoryBox.getInfo(), let phone = self.phoneBox.getInfo(), phone != "", let address = self.addressBox.getInfo(), address != "" else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("AGArtistCreateViewController-MissingValue"))
            return
        }
        
        // 是否是合适的邮箱的格式
        if !email.isValidEmail(){
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("InvalidEmail"))
            return
        }
        
        // Optional information
        var represent = ""
        if self.representativeBox.getInfo() != nil{
            represent = self.representativeBox.getInfo()!
        }
        var portfolio = ""
        if self.websiteBox.getInfo() != nil{
            portfolio = self.websiteBox.getInfo()!
        }

        let service = AGSignupService()
        
        service.ArtistSignup(pass: pwd, name: Name, email: email, regionid: regionId, age: age, gender: gender, portfolio: portfolio, phone: phone, address: address, represent: represent, categoryid: category)  { [weak self] (status, error) -> Void in
            if let weakSelf = self{
                if error != nil || status == 0{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("NetworkError"))
                    return
                }
                if status == 2{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString("Notice"), message: String.localizedString("AGArtistCreateViewController-ExistEmail"))
                    return
                }
                
                // Sign up succeed
                
                // set default sign in account
                UserDefaults.standard.set(email, forKey: "artist_email")
                UserDefaults.standard.synchronize()
                
                // show message
                let requireVC = AGVisitorActionRequiredViewController()
                weakSelf.navigationController?.present(requireVC, animated: true, completion: nil)
                
            }

        }

    }

}

//
//  AGSettingViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-09.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu
import TPKeyboardAvoiding
import SDWebImage

class AGSettingViewController: UIViewController {

    @IBOutlet weak var scrollView: AGLinearScrollView!
    var iconImageView: UIImageView!
    var mainScrollView: AGLinearScrollView!
    var emailBox: AGHasIconTextbox!
    var nickNameBox: AGHasIconTextbox!
    var RegionBox: AGDropListBox!
    var signupBtn: UIButton!
    var bgImageView: UIImageView!
    
    var oldPasswordBox: AGNoIconTextbox!
    var newPasswordBox: AGNoIconTextbox!
    
    var progress: UIActivityIndicatorView!
    
    var imagePickerController: UIImagePickerController!
    
    var photoSelectBlock: ((_ type: UIImagePickerControllerSourceType) -> Void)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        
        self.setupUI()
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func setupNavBar(){
        //获取登录身份并根据身份生成NavBar
//        let role = UserDefaults.standard.string(forKey: "AGRole")
        
        // 设置 bar 的背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        // 设置 title view
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString("AGLeftMenuViewController-settings")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
        
    }
    
    func setupUI(){
       
        // 初始化 图片选择 控制器
        self.imagePickerController = UIImagePickerController.init()
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        
        self.photoSelectBlock = { [weak self,weak imagePickerController] (type) -> Void in
            if let weakSelf = self, let weakImagePicker = imagePickerController{
                weakImagePicker.sourceType = type
                weakSelf.navigationController?.present(weakImagePicker, animated: true, completion: {
                    
                })
            }
        }
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT)
        
        print(self.scrollView.contentSize)
        print(self.scrollView.frame)
        
        self.scrollView.bounces = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        // icon view
        let iconView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        iconView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        iconImageView.image = UIImage.init(named: "avatar")
        
        iconView.addSubview(iconImageView)
        let changeImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
        changeImageView.center = iconImageView.center
        changeImageView.image = UIImage.init(named: "changephoto")
        iconView.addSubview(changeImageView)
        
        let changeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        changeBtn.addTarget(self, action: #selector(changePhotoAction), for: .touchUpInside)
        iconView.addSubview(changeBtn)
        
        self.scrollView.linear_addSubview(iconView, paddingTop: 30, paddingBottom: 0)

        
        let boxWidth = GlobalValue.SCREENBOUND.width - 25 * 2
        let boxHeight = CGFloat(55)
        
        // Display Email (read only)
        self.emailBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_email_icon", text: "Email Address" , isSecureText: false)
        self.emailBox.tintColor = UIColor.lightGray
        self.emailBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(self.emailBox, paddingTop: 20, paddingBottom: 0)
        self.emailBox.textField.isEnabled = false
        

        // Display Nickname (editable)
        self.nickNameBox = AGHasIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), iconName: "login_username_icon", text: "Name", isSecureText: false)
        self.nickNameBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(self.nickNameBox, paddingTop: 14, paddingBottom: 0)

        
        // Region
        self.RegionBox = AGDropListBox.init(frame: CGRect.init(x: 0, y: 25, width: boxWidth, height: boxHeight),bgImgName: "login_textbox_bg_clear" , text: "Region: Not Selected Yet")
        self.RegionBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(self.RegionBox, paddingTop: 14, paddingBottom: 0)
        
        // sign up button
        self.signupBtn = UIButton.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: boxHeight))
        self.signupBtn.setBackgroundImage(UIImage.init(named: "settings_button_bg"), for: UIControlState.normal)
        self.signupBtn.setTitle(String.localizedString("AGSettingViewController-update"), for: UIControlState.normal)
        self.signupBtn.addTarget(self, action: #selector(updateSetting), for: .touchUpInside)
        self.scrollView.linear_addSubview(self.signupBtn, paddingTop: 26, paddingBottom: 20)
        
        
        // 修改密码
        let separateLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: 1))
        separateLine.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        separateLine.backgroundColor = UIColor.white
        self.scrollView.linear_addSubview(separateLine, paddingTop: 20, paddingBottom: 0)
        
        let pawLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: 20))
        pawLabel.font = UIFont.init(name: "OpenSans-Bold", size: CGFloat(15))
        pawLabel.textAlignment = .center
        pawLabel.text = String.localizedString("AGSettingViewController-changepwd")
        pawLabel.textColor = UIColor.white
        pawLabel.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(pawLabel, paddingTop: 10, paddingBottom: 0)
        
        // old Password
        self.oldPasswordBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString("AGSettingViewController-oldpwd"), isSecure: true)
        self.oldPasswordBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(self.oldPasswordBox, paddingTop: 16, paddingBottom: 0)
        
        
        self.newPasswordBox = AGNoIconTextbox.init(frame: CGRect.init(x: 0, y: 0, width: boxWidth, height: boxHeight), bgImgName: "login_textbox_bg_clear" ,text: String.localizedString("AGSettingViewController-newpwd"), isSecure: true)
        self.newPasswordBox.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: 0)
        self.scrollView.linear_addSubview(self.newPasswordBox, paddingTop: 16, paddingBottom: 0)
      
        // 修改密码 button
        let changePwdBtn = UIButton.init(frame: CGRect.init(x: 25, y: 0, width: boxWidth, height: boxHeight))
        changePwdBtn.setBackgroundImage(UIImage.init(named: "settings_button_bg"), for: UIControlState.normal)
        changePwdBtn.setTitle(String.localizedString("AGSettingViewController-updatepwd"), for: UIControlState.normal)
        changePwdBtn.addTarget(self, action: #selector(updatePwd), for: .touchUpInside)
        self.scrollView.linear_addSubview(changePwdBtn, paddingTop: 26, paddingBottom: 30)

    }
    
    // 更新个人信息
    func updateSetting(){
        
        guard let seletedImg = self.iconImageView.image, let imgData = UIImageJPEGRepresentation(seletedImg, 1.0) else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString( "Notice" ), message: String.localizedString( "AGSettingViewController-NoticeSelectImage" ))
            return
        }
        guard let nickName = self.nickNameBox.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString( "Notice" ), message: String.localizedString("AGSettingViewController-InputName"))
            return
        }
        
        guard let REGIONID = self.RegionBox.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString( "Notice" ), message: String.localizedString("AGSettingViewController-SelectRegion"))
            return
        }
        
        self.progress = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.progress.frame = self.scrollView.frame
        self.progress.center = self.scrollView.center
        self.view.addSubview(self.progress)
        self.progress.startAnimating()
        
        let service = AGSettingService()
        let base64 = imgData.base64EncodedString()
        service.updateSetting(nickName: nickName, regionId: REGIONID, imageBase64: base64, finish: {[weak self](flag, error) -> Void in
            
            if let weakSelf = self{
            
            if error != nil || flag == false{
                weakSelf.progress.stopAnimating()
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString( "Notice" ), message: String.localizedString( "UpdateFail" ))
                return
            }
            weakSelf.progress.stopAnimating()
            ArtGalleryAppCenter.sharedInstance.InfoNotification(vc: weakSelf, title: String.localizedString( "Notice" ), message: String.localizedString( "UpdateSuccess" ))
            
            
            // WARNING : 更新用户信息 这一部分 按道理 应该是 服务器返回一个 完整的 用户信息，然后 解析用户信息 去重新覆盖 AppCenter 中的user，但目前没有这么做，只是象征性的更新。但是用户图像没办法更新
                
            ArtGalleryAppCenter.sharedInstance.user!.userName = nickName
            ArtGalleryAppCenter.sharedInstance.user!.regionid = REGIONID
            
            
            let timer = DispatchTime.now() + 1.6

            DispatchQueue.main.asyncAfter(deadline: timer) {
                if ArtGalleryAppCenter.sharedInstance.user!.userType == .Artist{
                    AGLeftMenuViewController.sharedInstance.resetUI(type: .Artist)
                    let bookmarkVC = AGArtistMainPageViewController()
                    SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
                }
                else{
                    AGLeftMenuViewController.sharedInstance.resetUI(type: .Visitor)
                    let bookmarkVC = AGVisitorMainPageViewController()
                    SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
                }
            }
            
            }

        })
    }
    
    func updatePwd(){
        let service = AGResetPWDService()
        
        guard let oldPwd = self.oldPasswordBox.getInfo(), oldPwd != "" else{
            return
        }
        guard let newPwd = self.newPasswordBox.getInfo(), newPwd != "" else{
            return
        }
        guard let email = self.emailBox.getInfo(), email != "" else{
            return
        }
        
        
        self.progress = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.progress.frame = self.scrollView.frame
        self.progress.center = self.scrollView.center
        self.view.addSubview(self.progress)
        self.progress.startAnimating()
        
        service.changePassword(target: oldPwd, by: newPwd, email: email) { [weak self] (flag, error) in
            
        if let weakSelf = self{
            if error != nil{
                print("fail")
                weakSelf.progress.stopAnimating()
                return
            }
            if flag == 1{
                weakSelf.progress.stopAnimating()
                ArtGalleryAppCenter.sharedInstance.InfoNotification(vc: weakSelf, title: String.localizedString( "Notice" ), message: String.localizedString( "UpdateSuccess" ))
                
                let timer = DispatchTime.now() + 1.6
                
                DispatchQueue.main.asyncAfter(deadline: timer) {
                    if ArtGalleryAppCenter.sharedInstance.user!.userType == .Artist{
                        let bookmarkVC = AGArtistMainPageViewController()
                        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
                    }
                    else{
                        let bookmarkVC = AGVisitorMainPageViewController()
                        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: bookmarkVC, withSlideOutAnimation: true, andCompletion: nil)
                    }
                }

                
            }
            else{
                weakSelf.progress.stopAnimating()
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: String.localizedString( "Notice" ), message: String.localizedString( "UpdateFail" ))
            }
        }
            
        }
    }
    
    func fetchData(){
        
        let user = ArtGalleryAppCenter.sharedInstance.user!
        let email = user.emailAddr
        let name = user.userName
        let photourl = user.photourl
        let regionid = user.regionid
        var region = String.localizedString("AGSettingViewController-Region") + String.localizedString("AGSettingViewController-NotYet")


        // 获取 region数据
        let regionService = AGGetRegion()
        
        regionService.getRegionList { (list, error) in
            if error != nil || list?.count == 0{
                let alertVC = UIAlertController.init(title: String.localizedString( "Notice" ), message: String.localizedString( "NetworkError" ), preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            self.RegionBox.updateData(list: list!)
            for element in list!{
                if element.id == regionid{
                    region = String.localizedString("AGSettingViewController-Region") + element.name!
                    self.RegionBox.selectedRegion = element
                }
            }
            
        // 填充用户数据
        self.emailBox.textField.text = email
        self.nickNameBox.textField.text = name
        self.RegionBox.textLabel.text = region
        let url = URL.init(string: photourl)
        // 初始化 圆形头像
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.borderWidth = 3
        self.iconImageView.layer.borderColor = UIColor.white.cgColor
        self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar"), options: SDWebImageOptions.allowInvalidSSLCertificates)
        }
       
    }
    
    // change photo
    @IBAction func changePhotoAction(_ sender: AnyObject) {
        
//        let blk = { [weak self] (type: UIImagePickerControllerSourceType) -> Void in
//            
//            if let weakSelf = self{
//                weakSelf.imagePickerController.sourceType = type
//                weakSelf.navigationController?.present(weakSelf.imagePickerController, animated: true, completion: {
//            
//                })
//            }
//        }
        
        let alertVC = UIAlertController.init(title: String.localizedString("Notice"), message: String.localizedString("AGSettingViewController-SelectFrom"), preferredStyle: .actionSheet)
        // 检测当前设备是否可以 访问 图库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction.init(title: String.localizedString("AGSettingViewController-PhotoLibrary"), style: .default) { (action) in
                self.photoSelectBlock(UIImagePickerControllerSourceType.photoLibrary)
            }
            alertVC.addAction(photoLibraryAction)
        }
        // 检测当前设备是否可以 访问 相机
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction.init(title: String.localizedString("AGSettingViewController-Camera"), style: .default) { (action) in
                self.photoSelectBlock(UIImagePickerControllerSourceType.camera)
            }
            alertVC.addAction(cameraAction)
        }
        let cancelAction = UIAlertAction.init(title: String.localizedString("Cancel"), style: .cancel) { (action) in
        }
        alertVC.addAction(cancelAction)

        self.present(alertVC, animated: true, completion: nil)

    }
    
    
}

extension AGSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    选择完图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.dismiss(animated: true, completion: nil)
            self.iconImageView.image = image
            if picker.sourceType == .camera{
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        else{
            self.dismiss(animated: true, completion: nil)

        }
//        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消图片选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
}

extension AGSettingViewController: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

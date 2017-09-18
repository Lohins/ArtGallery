//
//  AGVisitorForgetPWDViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-10-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu
import TPKeyboardAvoiding

class AGVisitorForgetPWDViewController: UIViewController {
    
    @IBOutlet var ResetButtonView: UIView!
    
    
    @IBOutlet weak var forgetLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var verificationField: UITextField!
    
    @IBOutlet weak var newpassField: UITextField!
    
    @IBOutlet weak var retrieveLabel: UILabel!

    @IBOutlet weak var resetLabel: UILabel!
    
    @IBOutlet var mainScrollView: TPKeyboardAvoidingScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localization()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mainScrollView.top = CGFloat(0)
        self.mainScrollView.bounces = false
        self.mainScrollView.contentSize = CGSize.init(width: GlobalValue.SCREENBOUND.width, height: self.ResetButtonView.bottom + 6)
    }
    
    func setupNavBar(){
        self.navigationController?.isNavigationBarHidden = false

        
        self.edgesForExtendedLayout = UIRectEdge()

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
    
    func localization(){
        
        let ClassName = "AGArtistForgetPWDViewController"
        
        forgetLabel.text = String.localizedString(ClassName + "-Forget")
        
        contentLabel.text = String.localizedString(ClassName + "-Description")
        
        emailField.placeholder = String.localizedString(ClassName + "-EmailAddress")
        
        retrieveLabel.text = String.localizedString(ClassName + "-RetrievePWD")
        
        verificationField.placeholder = String.localizedString(ClassName + "-verify")
        
        newpassField.placeholder = String.localizedString(ClassName + "-newpassword")
        
        resetLabel.text = String.localizedString(ClassName + "-reset")
        
    }

    
    @IBAction func sendcodeAction(_ sender: UIButton) {
        let service = AGRetrievePWDService()
        
        let email = self.emailField.text!
        
        service.sendcode(email: email){ [weak self] (status, error) -> Void in
            if let weakSelf  = self{
                if error != nil || status == 0 {
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "Sorry", message: "Failed to send verification code to the email address.")
                    return
                }
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "Success", message: "The verification code has been send to \(email)")
                return
            }

        }

    }

    @IBAction func resetAction(_ sender: UIButton) {
        let service = AGRetrievePWDService()
        
        let email = self.emailField.text!
        let code = self.verificationField.text!
        let newpass = self.newpassField.text!
        
        service.resetpass(email: email, verify: code, newpass: newpass){[weak self](status, error) -> Void in
            if let weakSelf = self{
                if error != nil || status == 0 {
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "Sorry", message: "Failed to reset password.")
                    return
                }
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "Success", message: "We have reset your password." ){ ()-> Void in
                    let _ = weakSelf.navigationController?.popViewController(animated: true)
                }
            }


        }

    }
    
    // 获取 之前的登陆 视图控制器， 然后 pop到那个视图控制器上面。
    func getLoginVC() -> UIViewController?{
        let vcs = SlideNavigationController.sharedInstance().viewControllers
        
        for vc in vcs{
            if vc.isKind(of: AGVisitorLoginViewController.classForCoder()) || vc.isKind(of: AGArtistLoginViewController.classForCoder()) {
                return vc
            }
        }
        return nil
        
    }
    
}

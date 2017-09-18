//
//  ArtGalleryAppCenter.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import Foundation

import iOS_Slide_Menu

class ArtGalleryAppCenter: NSObject {
    
    static let sharedInstance: ArtGalleryAppCenter = ArtGalleryAppCenter()
    
    // 没登录时候 是 游客类型
    var user: ArtGalleryBaseUser?
    
    var languageVersion: String{
        get{
            // 根据系统的语言进行判定， 目前，除了中文系统使用中文， 其他的语言均使用 英语
            let languages = NSLocale.preferredLanguages
            let language = languages[0]
            if language.hasPrefix("zh-Hans"){
                return "zh-Hans"
            }
            else{
                return "en"
            }
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: "LanguageVersion")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func login(user: ArtGalleryBaseUser){
        self.user = user
    }
    
    func login(artist: ArtGalleryArtistUser){
        self.user = artist
    }
    
    func logout(){
        self.user = nil
    }
    
    // 返回 user id， 如果登录了 就 使用， 没有登录就使用 id = 0
    func getUserId() -> Int{
        if let user  = self.user{
            return user.userId
        }
        else{
            return 0
        }
    }
    
    func isLogin() -> Bool{
        if self.user == nil || self.user?.userType == .SeeAround{
            return false
        }
        else{
            return true
        }
    }
    
    
    // 消息提示
    func InfoNotification(vc: UIViewController , title: String , message: String){
        // 提示信息
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        vc.present(alertVC, animated: true, completion: nil)
        
        let timer = DispatchTime.now() + 1.6
        DispatchQueue.main.asyncAfter(deadline: timer) { 
            alertVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func ErrorNotification(vc: UIViewController , title: String , message: String){
        // 提示信息
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        vc.present(alertVC, animated: true, completion: nil)
        
        let timer = DispatchTime.now() + 1.6
        DispatchQueue.main.asyncAfter(deadline: timer) {
            alertVC.dismiss(animated: true, completion: nil)
        }
        // 自动消失
//        let timer = DispatchTime.now() + 1
//        DispatchQueue.main.asyncAfter(deadline: timer){
//            // your code with delay
//            vc.dismiss(animated: true, completion: nil)
//        }
    }
    
    func ErrorNotification(vc: UIViewController , title: String , message: String, blk: @escaping (()-> Void)){
        // 提示信息
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        vc.present(alertVC, animated: true, completion: nil)
        
        let timer = DispatchTime.now() + 1.6
        DispatchQueue.main.asyncAfter(deadline: timer) {
            alertVC.dismiss(animated: true, completion: nil)
            blk()
        }
        // 自动消失
        //        let timer = DispatchTime.now() + 1
        //        DispatchQueue.main.asyncAfter(deadline: timer){
        //            // your code with delay
        //            vc.dismiss(animated: true, completion: nil)
        //        }
    }

    
    func OperateConfirmation(vc: UIViewController , title: String , message: String, handlerblock: BlockOperation){
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let confirmaction = UIAlertAction.init(title: "Yes", style: .default, handler:nil)
        let cancelaction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(confirmaction)
        alertVC.addAction(cancelaction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    // 需要登录才能 完成的操作
    func runAfterLogin(sourceVC: UIViewController ,block: () -> Void){
        if self.isLogin(){
            block()
        }
        else{
            let alertVC = UIAlertController.init(title: String.localizedString("ArtGalleryAppCenter-NoticeLogin"), message: "", preferredStyle: .actionSheet)
            let artistAction = UIAlertAction.init(title: String.localizedString("ArtGalleryAppCenter-Artist"), style: .default, handler: { (action) in
                let loginVC = AGArtistLoginViewController()
                sourceVC.navigationController?.pushViewController(loginVC, animated: true)
            })
            let visitorAction = UIAlertAction.init(title: String.localizedString("ArtGalleryAppCenter-Visitor"), style: .default, handler: { (action) in
                let loginVC = AGVisitorLoginViewController()
                sourceVC.navigationController?.pushViewController(loginVC, animated: true)
            })
            let cancelAction = UIAlertAction.init(title: String.localizedString("Cancel"), style: .cancel, handler: { (action) in
            })
            alertVC.addAction(artistAction)
            alertVC.addAction(visitorAction)
            alertVC.addAction(cancelAction)
            sourceVC.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    // ----- App 内部通知 管理
    func registerNotification(for target: Any, withName name: Notification.Name, selector: Selector){
        NotificationCenter.default.addObserver(target, selector:selector, name: name, object: nil)
    }
    
    func removeNotification(for target: Any){
        NotificationCenter.default.removeObserver(target)
    }
    
    func sendNotification(for name: Notification.Name, data: Dictionary<String, AnyObject>){
        NotificationCenter.default.post(name: name, object: data)
    }
}

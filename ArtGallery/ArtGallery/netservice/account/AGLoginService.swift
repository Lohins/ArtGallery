//
//  AGLoginService.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-14.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGLoginService: NSObject {
    
    func UserLogin(email:String, pass:String,  finish: @escaping (_ flag: Bool? , _ error: Error) -> Void){
        
        let url = GlobalValue.BASEURL + "user/login/post/"
        
        let params = ["data" :
                        ["email" : email,
                        "password": String.MD5_Encryption(rawStr: pass)]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let err = NSError.init(domain: String.localizedString("NetworkError"), code: 1, userInfo: nil)
                finish(false, err)
                return
            }
            else if result == nil{
                let err = NSError.init(domain: "", code: 1, userInfo: nil)
                finish(false , err)
                return
            }
            else{
                // parse data
                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init(domain: "", code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                
                let status = data["status"] as! Int
                if status == 0{
                    let err = NSError.init(domain: String.localizedString("NetworkError"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                else if status == -1{
                    let err = NSError.init(domain: String.localizedString("AGArtistLoginViewController-InvalidUOP"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }else if status == 2{ // 未激活用户
                    let err = NSError.init(domain: String.localizedString("AGArtistLoginViewController-Inactive"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                
                let info = ArtGalleryVisitorLoginInfo.init(data: data)
                
                let visitorUser = ArtGalleryVisitorUser.init(userID: info.userid!, userInfo: info, regionId: info.regionID!, photoURL: info.PhotoUrl!)
                
                UserDefaults.standard.set(email, forKey: "visitor_email")
                UserDefaults.standard.synchronize()
                
                ArtGalleryAppCenter.sharedInstance.login(user: visitorUser)
                
                finish(true , NSError.init())
            }
        }
    }
    
    // 艺术家登录
    func ArtistLogin(email:String, pass:String, finish: @escaping (_ flag: Bool? , _ error: Error) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/login/post/"
    
        let params = ["data" :
                        ["email" : email,
                         "password": String.MD5_Encryption(rawStr: pass)]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let err = NSError.init(domain: String.localizedString("NetworkError"), code: 1, userInfo: nil)
                finish(false, err)
                return
            }
            else if result == nil{
                let err = NSError.init(domain: "", code: 1, userInfo: nil)
                finish(false , err)
                return
            }
            else{
                // parse data
                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init(domain: "", code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                
                let status = data["status"] as! Int
                if status == 0{
                    let err = NSError.init(domain: String.localizedString("NetworkError"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                else if status == -1{
                    let err = NSError.init(domain: String.localizedString("AGArtistLoginViewController-InvalidUOP"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }else if status == 2{ // 未激活艺术家用户
                    let err = NSError.init(domain: String.localizedString("AGArtistLoginViewController-Inactive"), code: 1, userInfo: nil)
                    finish(false , err)
                    return
                }
                
//                let info = ArtGalleryVisitorLoginInfo.init(data: data)
//                
//                
//                let visitorUser = ArtGalleryVisitorUser.init(userID: info.userid!, userInfo: info, regionId: info.regionID!, photoURL: info.PhotoUrl!)
//                

                let rawData = data["data"] as! Dictionary<String , AnyObject>
                let info = AGArtistLoginInfo.init(data: rawData)
                
                let user = ArtGalleryArtistUser.init(artistID: info.artistID, info: info, regionId: info.regionID!)
                
                ArtGalleryAppCenter.sharedInstance.login(user: user)
                
                UserDefaults.standard.set(email, forKey: "artist_email")
                UserDefaults.standard.synchronize()
                
                finish(true , NSError.init())
            }
        }
    }
}

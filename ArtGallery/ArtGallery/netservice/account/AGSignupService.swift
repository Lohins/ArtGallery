//
//  AGSignupService.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-17.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGSignupService: NSObject {

    // 普通用户注册
    func VisitorSignup(pass:String, nick:String, photourl:String,  email:String, regionid:Int, finish:@escaping (_ result: Int? ,_ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "user/registry/signup/request/"
        
        let params = ["data" : ["password":String.MD5_Encryption(rawStr: pass),
                                "nickname":nick,
                                "firstname":"",
                                "lastname":"",
                                "email":email,
                                "regionid":regionid,
                                "photobase64":"",
                                "photoformat":""]]
        //print(params)
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            let status = result!["data"]!["status"] as! Int
            
            finish(status, nil)
            
        }
    }

    // 艺术家注册
    func ArtistSignup(pass:String,name:String,email:String,regionid:Int,age:Int,gender:Int,portfolio:String,phone:String,address:String,represent:String,categoryid:Int,
        finish:@escaping (_ result: Int? ,_ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/registry/request/"
        
        let params = ["data" : ["password":String.MD5_Encryption(rawStr: pass),
                                "nickname":name,
                                "firstname":name,
                                "lastname":"",
                                "email":email,
                                "regionid":regionid,
                                "age":age,
                                "gender":gender,
                                "portfolio":portfolio,
                                "phone":phone,
                                "address":address,
                                "represent":represent,
                                "categoryid":categoryid,
                                "photobase64":"",
                                "photoformat":""]]

        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            let status = result!["data"]!["status"] as! Int
            
            finish(status, nil)
            
        }
    
    }

}

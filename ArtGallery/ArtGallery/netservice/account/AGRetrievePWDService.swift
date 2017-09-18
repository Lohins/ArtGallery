//
//  AGRetrievePWDService.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-17.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGRetrievePWDService: NSObject {
    func sendcode(email:String, finish:@escaping (_ result: Int? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "user/resetpassword/request/post/"

        let params = ["data" : ["email":email]]
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
    // 重置密码
    func resetpass(email:String, verify:String, newpass:String, finish:@escaping (_ result: Int? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "user/resetpassword/reset/post/"
        
        let params = ["data" : ["email":email,
                                "password":String.MD5_Encryption(rawStr: newpass),
                                "code":verify]]
        
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

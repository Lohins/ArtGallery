//
//  AGResetPWDService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-10.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGResetPWDService: NSObject {
    
    // 修改密码
    //    user/resetpassword/fromoldone/post
    //
    //    email
    //    oldpassword
    //    newpassword
    
    func changePassword(target oldPassword:String, by newPassword: String, email: String, finish: @escaping ((_ flag: Int, _ error: Error?) -> Void) ){
        
        let url = GlobalValue.BASEURL + "user/resetpassword/fromoldone/post/"
        
        let params = ["data" : [ "email": email, "oldpassword" : String.MD5_Encryption(rawStr: oldPassword), "newpassword" : String.MD5_Encryption(rawStr: newPassword) ]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>) { (result, error) in
            if error != nil{
                finish(0, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            // status 是1 更新成功， 0 旧密码错误
            let status = data["status"] as! Int
            
            if status == 1{
                finish(1, nil)
            }else{
                finish(0, nil)
            }
            
        }
        
    }

}

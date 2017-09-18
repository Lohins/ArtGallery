//
//  AGSettingService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-10.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGSettingService: NSObject {
    
    func updateSetting(nickName: String, regionId: Int, imageBase64: String, finish: @escaping ((_ flag: Bool,_ error: Error?) -> Void)){
        
        let url = GlobalValue.BASEURL + "user/updateinfo/post/"
        print (ArtGalleryAppCenter.sharedInstance.user!.emailAddr)
        let params = ["data":
            [
                "email" : ArtGalleryAppCenter.sharedInstance.user!.emailAddr,
                "nickname" : nickName,
                "regionid" : regionId,
                "photo" : imageBase64,
                "fileformat" : ".jpeg"
            ]
        ]
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>? ) {(result , error) -> Void in
            if error != nil{
                finish(false, error!)
                return
            }
            
            guard let data = result?["data"] as? Dictionary<String, AnyObject>, let status = data["status"] as? Int else{
                finish(false, NSError.init())
                return
            }
            
            if status == 0{
                finish(false, nil)
                return
            }
            else{
//                更新 头像
                let photoUrl = data["photourl"] as! String
                ArtGalleryAppCenter.sharedInstance.user?.photourl = photoUrl
                finish(true, nil)
            }
            
        }
    }
}

//
//  AGFollowService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-20.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGFollowService: NSObject {
    // 获取当前用户 关注的 用户的 作品集
    func getFollowWorks( finish: @escaping (_ list: [AGArtwork]? , _ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/artistartworks/post/"
        
        let params = ["data" : ["userid": ArtGalleryAppCenter.sharedInstance.user!.userId]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            let status = data["status"] as! Int
            if status == 0{
                let err = NSError.init()
                finish(nil, err)
                return
            }
            
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            
            var artworkList = [AGArtwork]()
            
            for element in list{
                let artwork = AGArtwork.init(data: element)
                artworkList.append(artwork)
            }
            
            finish(artworkList , nil)
            
        }
    }
    
    // 获取当前用户 关注的 用户的 作品集
    func getFollowWorks(by userID: Int,  finish: @escaping (_ list: [AGArtwork]? , _ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/artistartworks/post/"

        let params = ["data" : ["userid": userID]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            let status = data["status"] as! Int
            if status == 0{
                let err = NSError.init()
                finish(nil, err)
                return
            }
            
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            
            var artworkList = [AGArtwork]()
            
            for element in list{
                let artwork = AGArtwork.init(data: element)
                artworkList.append(artwork)
            }
            
            finish(artworkList , nil)
            
        }
    }
}

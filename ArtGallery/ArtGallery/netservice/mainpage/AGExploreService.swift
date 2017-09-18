//
//  AGMainPageService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

// 这个类 去获取 用户的 “我关注的页面” 列表

class AGExploreService: NSObject {
    
    
    func getExploreInfo( finish:@escaping (_ list:[AGArtwork]? , _ error: Error?) -> Void ){
        let url = GlobalValue.BASEURL + "main/artwork/request/"
        
        if ArtGalleryAppCenter.sharedInstance.isLogin() == false{
            AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil, finishBlk: { (result, error) in
                if error != nil{
                    let error = NSError.init()
                    finish(nil , error)
                    return
                }
                // 解析 result
                let data = result!["data"] as! Dictionary<String, AnyObject>

                let status = data["status"] as! Int
                
                if status == 0{
                    finish([] , error)
                    return
                }
                else{
                    let content = data["data"] as! [Dictionary<String, AnyObject>]
                    
                    var list = [AGArtwork]()
                    for element in content{
                        let artwork = AGArtwork.init(data: element)
                        list.append(artwork)
                    }
                    finish(list , nil)
                }
            })
        }
        else{
            let params = ["data" : ["userid" : ArtGalleryAppCenter.sharedInstance.getUserId()]]
            AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?, finishBlk: { (result, error) in
                if error != nil{
                    finish(nil , error)
                    return
                }
                // 解析 result
                
                let data = result!["data"] as! Dictionary<String, AnyObject>
                
                let status = data["status"] as! Int
                
                if status == 0{
                    finish([] , error)
                    return
                }
                else{
                    let content = data["data"] as! [Dictionary<String, AnyObject>]
                    
                    var list = [AGArtwork]()
                    for element in content{
                        let artwork = AGArtwork.init(data: element)
                        list.append(artwork)
                    }
                    finish(list , nil)
                }
            })
        }
    }
    
    // 探索页面  获取 艺术家列表， 分为 登录 和 未登录
    func getExploreArtistInfo( finish:@escaping (_ list:[AGUser]? , _ error: Error?) -> Void ){
        let url = GlobalValue.BASEURL + "main/artist/request/"
        
        if ArtGalleryAppCenter.sharedInstance.isLogin() == false{
            AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil, finishBlk: { (result, error) in
                if error != nil{
                    let error = NSError.init()
                    finish(nil , error)
                    return
                }
                // 解析 result
                let data = result!["data"] as! Dictionary<String, AnyObject>
                
                let status = data["status"] as! Int
                
                if status == 0{
                    finish([] , error)
                    return
                }
                else{
                    let content = data["data"] as! [Dictionary<String, AnyObject>]
                    
                    var list = [AGUser]()
                    for element in content{
                        let artist = AGUser.init(data: element)
                        list.append(artist)
                    }
                    finish(list , nil)
                }
            })
        }
        else{
            let params = ["data" : ["userid" : ArtGalleryAppCenter.sharedInstance.getUserId()]]
            AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?, finishBlk: { (result, error) in
                if error != nil{
                    finish(nil , error)
                    return
                }
                // 解析 result
                
                let data = result!["data"] as! Dictionary<String, AnyObject>
                
                let status = data["status"] as! Int
                
                if status == 0{
                    finish([] , error)
                    return
                }
                else{
                    let content = data["data"] as! [Dictionary<String, AnyObject>]
                    
                    var list = [AGUser]()
                    for element in content{
                        let artist = AGUser.init(data: element)
                        list.append(artist)
                    }
                    finish(list , nil)
                }
            })
        }
    }

    
}

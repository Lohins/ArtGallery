//
//  AGFlollowService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

// 这个网络文件 包含了： 喜欢，收藏，跟踪等功能。

import UIKit

class AGInteractService: NSObject {
    // 返回 用户 following artists 的信息
    func getFollowing( finish:@escaping (_ list: [AGArtist]? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/getfollowinfo/request/"
        
        let params = ["retrievetype" : 1 ,
                      "userid" : ArtGalleryAppCenter.sharedInstance.user!.userId]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            // 返回的状态如果是 1 说明 更新成功， 0 则说明 由于某些原因更新失败。
            let status = data["status"] as! Int
            if status == 0{
                finish([] , nil)
                return
            }
            // 解析data
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            
            var artistList = [AGArtist]()
            for element in list{
                let artist = AGArtist.init(data: element)
                artistList.append(artist)
            }
            finish(artistList , nil)

        }
    }
    
    // 返回 user喜欢的作品列表
    func GetLikeWorksList(finish:@escaping (_ result: Any? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/like/getlikelist/request/"
        
        let params = ["retrievetype" : 1 ,
                      "retrieveid" : ArtGalleryAppCenter.sharedInstance.user!.userId]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            // TODO : 解析data
            finish(0 , nil)
            
        }
    }
    
    // 返回 喜欢作品的user列表
    func GetLikeUsersList(_ workId:Int , finish:@escaping (_ result: Any? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/like/getlikelist/request/"
        
        let params = ["retrievetype" : 0 ,
                      "retrieveid" : workId]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            // TODO : 解析data
            finish(0 , nil)
            
        }
    }
    
    // 返回 用户收藏了那些作品
    func GetCollectionList(finish:@escaping (_ result: Any? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/like/getlikelist/request/"
        
        let params = ["retrievetype" : 1 ,
                      "retrieveid" : ArtGalleryAppCenter.sharedInstance.user!.userId]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            // TODO : 解析data
            finish(0 , nil)
            
        }
    }
    
    // 返回 一个作品被哪些人收藏了
    func GetCollectUserList(ofWork workId: Int,finish:@escaping (_ result: Any? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/like/getlikelist/request/"
        
        let params = ["retrievetype" : 0 ,
                      "retrieveid" : workId]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , error)
                return
            }
            
            // TODO : 解析data
            finish(0 , nil)
            
        }
    }
    
    // 用户去 关注 另一个用户 (status = 1)， 或者 解除关注  (status = 0)
    func UpdateFollowStatus(_ status: Int , targetUserId:Int , finish:@escaping (_ result: Bool ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/update/request/"
        
        let params = ["data": ["operation" : status,
                      "userid" : ArtGalleryAppCenter.sharedInstance.user!.userId ,
                      "target" : targetUserId]
                    ]
    
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(false , error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String , AnyObject>
            
            let status = data["status"] as! Int
            
            if status == 0{
                finish(false, nil)
                return
            }
            else{
                finish(true, nil)
            }

        }
    }
    
    // 用户 去喜欢一个作品(status = 1) 或者 不喜欢一个作品 (status = 0)
    func UpdateLikeStatus(_ status: Int , targetWorkId:Int , finish:@escaping (_ result: Bool ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "like/update/request/"
        
        let params = ["data" : ["operation" : status,
                      "userid" : ArtGalleryAppCenter.sharedInstance.user!.userId ,
                      "artworkid" : targetWorkId] ]
    
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish(false , error)
                return
            }
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            // 返回的状态如果是 1 说明 更新成功， 0 则说明 由于某些原因更新失败。
            let status = data["status"] as! Int
            if status == 0{
                finish(false , nil)
                return
            }
            // TODO : 解析data
            finish(true, nil)
            
        }
    }
    
    // 用户 去收藏一个作品(status = 1) 或者 取消收藏一个作品 (status = 0)
    func UpdateCollectStatus(_ status: Int , targetWorkId:Int , finish:@escaping (_ result: Bool ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "collect/update/request/"
        
        let params = ["data" : ["operation" : status,
                      "userid" : ArtGalleryAppCenter.sharedInstance.user!.userId ,
                      "artworkid" : targetWorkId] ]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish( false, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            // 返回的状态如果是 1 说明 更新成功， 0 则说明 由于某些原因更新失败。
            let status = data["status"] as! Int
            if status == 0{
                finish(false , nil)
                return
            }
            // TODO : 解析data
            finish(true , nil)
            
        }
    }
    
    // 获取他的粉丝（type = 0）
    func getFans(type: Int, finish: @escaping (_ list: [Dictionary<String , AnyObject>]?,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/getfollowinfo/request/"
        
        let params = ["data" : ["retrievetype" : type,
                                "userid" : ArtGalleryAppCenter.sharedInstance.getUserId()]
        ]
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish( nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            // 返回的状态如果是 1 说明 更新成功， 0 则说明 由于某些原因更新失败。
            let status = data["status"] as! Int
            if status == 0{
                finish([] , nil)
                return
            }
            // 解析data
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            
            finish(list , nil)
            
        }
    }
    
    
    // 获取 user 关注了那些人（type = 1）
    func getFollower(type: Int, finish: @escaping (_ list: [AGUser]?,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "follow/getfollowinfo/request/"
        
        let params = ["data" : ["retrievetype" : type,
                                "userid" : ArtGalleryAppCenter.sharedInstance.getUserId()]
                        ]
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                let error = NSError.init()
                finish( nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            // 返回的状态如果是 1 说明 更新成功， 0 则说明 由于某些原因更新失败。
            let status = data["status"] as! Int
            if status == 0{
                finish([] , nil)
                return
            }
            // 解析data
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            
            var userList = [AGUser]()
            for element in list{
                let user = AGUser.init(data: element)
                userList.append(user)
            }
            finish(userList , nil)
            
        }
    }

}

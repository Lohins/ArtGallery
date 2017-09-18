//
//  AGArtistService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistService: NSObject {
    
    
    // 获取 当前艺术家的作品列表
    func getMyWorksList( finish:@escaping (_ artworkList: [AGArtwork]? , _ error: Error?) -> Void ){
        let url = GlobalValue.BASEURL + "artist/artworkinfo/post/"
        var artistid = 1
        
        if ArtGalleryAppCenter.sharedInstance.user!.isKind(of: ArtGalleryArtistUser.classForCoder()){
            let artist = ArtGalleryAppCenter.sharedInstance.user as! ArtGalleryArtistUser
            artistid = artist.artistId
        }
        // 这里的userid 服务器没有做解析，但是由于跟 根据用户搜索关注的艺术家 用到同一个底层 这里要求有一个userid字段。
        let params = ["data" : ["artistid" : artistid, "userid":0] ]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil , error)
                return
            }
            else if result == nil{
                let err = NSError.init()
                finish(nil , err)
                return
            }
            else{
                // parse data
                guard let data = result!["data"] as? Dictionary<String , AnyObject>, let data1 = data["data"] as? Dictionary<String , AnyObject>, let artworksList = data1["artworks"] as? [Dictionary<String , AnyObject>] else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                var list = [AGArtwork]()
                
                for element in artworksList{
                    let artwork = AGArtwork.init(data: element)
                    list.append(artwork)
                }
                finish(list , nil)
            }
            
        }
    }
    
    // 根据 artistid 获取艺术家作品列表
    func getWorksListbyArtistid( artistid:Int, finish:@escaping (_ artworkList: [AGArtwork]? , _ error: Error?) -> Void ){
        let url = GlobalValue.BASEURL + "artist/artworkinfo/post/"
        
        let userid = ArtGalleryAppCenter.sharedInstance.getUserId()
//        if ArtGalleryAppCenter.sharedInstance.isLogin(){
//            userid = ArtGalleryAppCenter.sharedInstance.user!.userId
//        }
        
        
        let params = ["data" : ["artistid" : artistid , "userid" : userid ] ]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil , error)
                return
            }
            else if result == nil{
                let err = NSError.init()
                finish(nil , err)
                return
            }
            else{
                // parse data
                guard let data = result!["data"] as? Dictionary<String , AnyObject>, let data1 = data["data"] as? Dictionary<String , AnyObject>, let artworksList = data1["artworks"] as? [Dictionary<String , AnyObject>] else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                var list = [AGArtwork]()
                
                for element in artworksList{
                    let artwork = AGArtwork.init(data: element)
                    list.append(artwork)
                }
                
                finish(list , nil)
            }
            
        }
    }

    
    
    
    // 获取当前艺术家的个人信息
    func getBasicInfo( finish: @escaping (_ info: AGArtistBasicInfo? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/basicinfo/post/"
        
        
        // artistid 和 user id 不一样
        let user =  ArtGalleryAppCenter.sharedInstance.user as! ArtGalleryArtistUser
        let params = ["data" : ["artistid" :  user.artistId]]
        
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
            let rawData = data["data"] as! Dictionary<String, AnyObject>
            let info = AGArtistBasicInfo.init(data: rawData)
            finish(info, nil)
        }
    }
    
    // 根据 artistid 获取当前艺术家信息
    func getBasicInfobyAritstid(artistid:Int, finish: @escaping (_ info: AGArtistBasicInfo? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/basicinfo/post/"
        
        let params = ["data" : ["artistid" :  artistid]]
        
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
            let rawData = data["data"] as! Dictionary<String, AnyObject>
            let info = AGArtistBasicInfo.init(data: rawData)
            finish(info, nil)
        }
    }

    
    // 根据关键词模糊搜索艺术家
    
    func getArtistListbyKeyword( keyword: String, finish: @escaping (_ info: AGArtistBasicInfo? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "search/artist/post/"
        
        let params = ["data" : ["keyword" : keyword]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, error)
                return
            }
            else if result == nil{
                let err = NSError.init()
                finish(nil , err)
                return
            }
            else{
                // parse data
                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                let info = AGArtistBasicInfo.init(data: data)
                
                finish(info , nil)
            }
        }
    }

}

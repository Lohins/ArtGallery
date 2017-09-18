//
//  AGSearchService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-19.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGSearchService: NSObject {

    // 普通作品 的作品
    func searchWorkBy(keyword: String , finish:@escaping (_ result: [AGArtwork]? , _ error: Error?)-> Void){
        let url = GlobalValue.BASEURL + "search/general/post/"
        
        let userid:Int = ArtGalleryAppCenter.sharedInstance.getUserId()
        let params = ["data" : ["keyword" : keyword, "userid": userid]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil , error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            let status = data["status"] as! Int
            
            if status == 0{
                let err = NSError.init()
                finish(nil, err)
                return
            }
            
            let list = data["data"] as! [[Dictionary<String, AnyObject>]]
            
            
            var resultList = [AGArtwork]()
            for element in list{
                for tmp in element{
                    let artwork = AGArtwork.init(data: tmp)
                    resultList.append(artwork)
                }
            }
            finish(resultList, nil)
        }
    }
    
    // 艺术家的搜索
    func searchArtistBy(keyword: String , finish:@escaping (_ result: [AGUser]? , _ error: Error?)-> Void){
        let url = GlobalValue.BASEURL + "search/preferartist/post/"
        let userid:Int = ArtGalleryAppCenter.sharedInstance.getUserId()
        let params = ["data" : ["keyword" : keyword, "userid": userid]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil , error)
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
            
            var resultList = [AGUser]()
            for element in list{
                let artist = AGUser.init(data: element)
                resultList.append(artist)
            }
            finish(resultList, nil)
        }
    }
}

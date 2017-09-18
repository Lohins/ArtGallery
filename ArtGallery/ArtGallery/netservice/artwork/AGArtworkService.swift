//
//  AGArtworkService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtworkService: NSObject {
    
    // 获取某个artwork 的详细信息
    func getArtworkInfo(id : Int , finish: @escaping (_ info: AGArtwork? , _ error: Error?) -> Void){
        
        
        let url = GlobalValue.BASEURL + "artwork/info/" + String(id) + "/get"
        
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (result, error) in
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
                guard let data = result!["data"] as? Dictionary<String, AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let status = data["status"] as? Int, status == 1 else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let info = data["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                let artwork = AGArtwork.init(detail: info)
                
                finish(artwork , nil)
            }
        }
    }
    
    // 根据Tag获取artwork list
    func getArtworkListbyTag(keyword : String , finish: @escaping (_ info: AGArtworkList? , _ error: Error?) -> Void){

        let url = GlobalValue.BASEURL + "search/general/post"
        
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
                
                let info = AGArtworkList.init(data: data)
                
                finish(info , nil)
            }
        }
    }
    
    // 根据userid 获取收藏的 artwork list
    func getCollectedArtworkList(finish: @escaping (_ list: [AGArtwork]? , _ error: Error?) -> Void){
        let id = ArtGalleryAppCenter.sharedInstance.user?.userId
        
        let url = GlobalValue.BASEURL + "collect/getcollectionlist/request/"
        let params = ["data" : ["retrievetype" : 1, "retrieveid" : id!]]
        
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
                guard let data = result!["data"] as? Dictionary<String, AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let status = data["status"] as? Int, status == 1 else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let info = data["data"] as? [Dictionary<String , AnyObject>] else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                var list = [AGArtwork]()
                
                for element in info{
                    let artwork = AGArtwork.init(data: element)
                    list.append(artwork)
                }
                finish(list, nil)
                
            }
        }
    }

    
    
    // 获取某个artwork 的评论列表
    func getCommentListbyArtworkID(id : Int , finish: @escaping (_ list: [AGComment]? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artwork/comment/" + String(id) + "/get"
        
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (result, error) in
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
                guard let data = result!["data"] as? Dictionary<String, AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let status = data["status"] as? Int, status == 1 else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let info = data["data"] as? [Dictionary<String , AnyObject>] else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                var list = [AGComment]()
                
                for element in info{
                    let comment = AGComment.init(data: element)
                    list.append(comment)
                }
                finish(list, nil)
                // 解析info（Comment List）
                // Model 位于 Model/artworks/AGComment.swift
                
            }
        }
    }
    
    // 评论某个作品
    func postComment(userid : Int , artworkid : Int, comment : String, finish: @escaping (_ result: AGComment?  , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artwork/comment/request/"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStr = dateFormatter.string(from: date)
                
        let params = ["data" : ["parentid" : 0,
                                "targetid" : 0,
                                "comment"  : comment,
                                "artworkid": artworkid,
                                "userid"   : userid,
                                "createddate" : timeStr]]
        
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
                
                // 只返回status，1成功，0失败
                
                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                guard let status = data["status"] as? Int, status == 1 else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                // 发表成功了， 创建一个新的comment。
                let comment = AGComment.init(data: params["data"]! as Dictionary<String, AnyObject>)
                // 由于 该评论是 当前登录的用户发的，所以把用户的icon赋给 comment
                comment.photourl = ArtGalleryAppCenter.sharedInstance.user!.photourl
                finish(comment, nil)
                
                //检查一下是否写完整

            }
        }
    }
    

    // 上传艺术作品
    func uploadArtwork(
        caption: String , description: String, imageBase64: String, videoBase64: String, subjectid:Int, taglist:[Int],
        finish: @escaping ( _ result: Bool , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/uploadartwork/post/"
        
        var artistid = 0
        if ArtGalleryAppCenter.sharedInstance.user!.isKind(of: ArtGalleryArtistUser.classForCoder()){
            let artist = ArtGalleryAppCenter.sharedInstance.user as! ArtGalleryArtistUser
            artistid = artist.artistId
        }
        else{
            return
        }

        print(artistid)
        
        let params = ["data" :
                        [ "base" : [
                            "artistid"   : artistid,
                            "caption"    : caption,
                            "description": description,
                            "imagepath"  : "",
                            "imagebase64" : imageBase64,
                            "imageformat" : ".jpeg",
                            "status"     : 1,
                            "videoembedcode": "",
                            "videobase64" : videoBase64,
                            "videoformat" : ".mp4",
                            "audioexternallink":"",
                            "subjectid"  : subjectid],
                          "taglist": taglist
                        ]
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
    
    // 更新艺术作品信息
    func updateArtwork (artworkid:Int, caption: String , description: String, imageBase64: String, videoBase64: String, subjectid:Int, tagId:Int,
                        finish: @escaping ( _ result: Bool , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/updateartwork/content/post/"
        
        var artistid = 0
        if ArtGalleryAppCenter.sharedInstance.user!.isKind(of: ArtGalleryArtistUser.classForCoder()){
            let artist = ArtGalleryAppCenter.sharedInstance.user as! ArtGalleryArtistUser
            artistid = artist.artistId
        }
        else{
            return
        }
        
        let params = ["data" :
            [
                "artistid"   : artistid,
                "artworkid"  : artworkid,
                "caption"    : caption,
                "description": description,
                "imagepath"  : "",
                "imagebase64" : imageBase64,
                "imageformat" : ".jpeg",
                "status"     : 1,
                "videoembedcode": "",
                "videobase64" : videoBase64,
                "videoformat" : ".mp4",
                "audioexternallink":"",
                "subjectid"  : subjectid,
                "tagid": tagId
            ]
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

    
    // 删除艺术作品 （保留在数据库，status ＝ 0）
    func deleteArtwork( artworkid :Int, finish: @escaping ( _ result: Bool , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "artist/deleteartwork/post/"
        
        let params = ["data" : ["artworkid": artworkid]]
        
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


    
}

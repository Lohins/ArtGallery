//
//  AGNewsService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGNewsService: NSObject {
    
    //获取全球新闻列表
    func getNewsList( finish:@escaping (_ result: [AGNews]?  ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "news/getlist/get/"
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (result, error) in
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
                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                
                let status = data["status"] as! Int
                
                if status == 0{
                    let err = NSError.init()
                    finish(nil, err)
                    return
                }
                
                let list = data["data"] as? [Dictionary<String, AnyObject>]
                
                var resultList = [AGNews]()
                
                for elem in list!{
                    let news = AGNews.init(data: elem)
                    resultList.append(news)
                }
                
                finish(resultList, nil)
                
            }
        }
    }
    
    //获取区域新闻列表
    func getNewsListbyRegionID( finish:@escaping (_ result: [AGNews]? ,_ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "news/getlistbyregion/post/"
        
        let user =  ArtGalleryAppCenter.sharedInstance.user! as ArtGalleryBaseUser
        let regionid = user.regionid
        
        let params = ["data" :   ["regionid" : regionid]]
        
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
                
                let status = data["status"] as! Int
                
                if status == 0{
                    let err = NSError.init()
                    finish(nil, err)
                    return
                }
                
                let list = data["data"] as? [Dictionary<String, AnyObject>]
                
                var resultList = [AGNews]()
                
                for elem in list!{
                    let news = AGNews.init(data: elem)
                    resultList.append(news)
                }
                
                finish(resultList, nil)
            
            }
        }
    }

    
    //获取一条具体新闻
    func getNewsDetail(newsid:Int, finish: @escaping (_ info: AGNews? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "news/getdetailedinfo/post/"
        
        let params = ["data" :   ["newsid" : newsid]]
        
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
                let data = result!["data"] as! Dictionary<String, AnyObject>
                let status = data["status"] as! Int
                if status == 0{
                    let err = NSError.init()
                    finish(nil , err)
                    return
                }
                let info = data["data"] as! Dictionary<String, AnyObject>
                
                let news = AGNews.init(data: info)
                finish(news, nil)
                
            }
        }
    }
    
    //获取展览列表
    func getExhibitionList( finish:@escaping (_ result: [AGExhibition]? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "exhibition/getlist/get/"
        
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (result, error) in
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
            
            let list = data["data"] as? [Dictionary<String, AnyObject>]
            
            var resultList = [AGExhibition]()
            
            for elem in list!{
                let exibition = AGExhibition.init(data: elem)
                resultList.append(exibition)
            }
            
            finish(resultList, nil)
            // 解析data
            
        }
    }

    //获取一个具体展览
//    func getExhibitionDetail(exbid:Int, finish: @escaping (_ info: AGExhibition? , _ error: Error?) -> Void){
//        
//        let url = GlobalValue.BASEURL + "exhibition/getdetailedinfo/post/"
//        
//        let params = ["data" :   ["exhibitionid" : exbid]]
//        
//        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
//            if error != nil{
//                finish(nil, error)
//                return
//            }
//            else if result == nil{
//                let err = NSError.init()
//                finish(nil , err)
//                return
//            }
//            else{
//                // parse data
//                guard let data = result?["data"] as? Dictionary<String , AnyObject> else{
//                    let err = NSError.init()
//                    finish(nil , err)
//                    return
//                }
//                
//                let info = AGExhibition.init(data: data)
//                
//                finish(info , nil)
//            }
//        }
//    }

    
    //获取一个具体展览的展品列表
    func getExhibitList(exbid:Int, finish: @escaping (_ IDList: [Int]? , _ ImgPathList: [String]?, _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "exhibits/getlist/post/"
        
        let params = ["data" :   ["exhibitionid" : exbid]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            let status = data["status"] as! Int
            if status == 0{
                let err = NSError.init()
                finish(nil, nil , err)
                return
            }
            
            let list = data["data"] as! [Dictionary<String, AnyObject>]
            var IDList = [Int]()
            var ImgPathList = [String]()
            
            for element in list{
                IDList.append(element["exhibitid"] as! Int)
                ImgPathList.append(element["fileurl"] as! String)
            }
            finish(IDList, ImgPathList , nil)
        }
    }
    
    //获取一个具体的展品
    func getExhibitDetail(exbitid:Int, finish: @escaping (_ info: AGExhibit? , _ error: Error?) -> Void){
        
        let url = GlobalValue.BASEURL + "exhibits/getsingle/post/"
        
        let params = ["data" :   ["exhibitid" : exbitid]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, error)
                return
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            let status = data["status"] as! Int
            if status == 0{
                let err = NSError.init()
                finish(nil , err)
                return
            }
            
            let rawData = data["data"] as! Dictionary<String, AnyObject>
            
            let exhibit = AGExhibit.init(data: rawData)
            finish(exhibit, nil)
        }
    }
    
}

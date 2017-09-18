//
//  AGPreferenceService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGPreferenceService: NSObject {
    
    // 获取 主题 和 类型 的数据列表
    func getPreferenceInfo( finish:@escaping (_ subList:[AGSubject]? , _ tagDict: Dictionary<String , [AGTag]>?, _ cateDict: Dictionary<String , Int>?, _ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "preference/get/"
        
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (data, error) in
            if error != nil{
                let error = NSError.init()
                finish(nil , nil , nil, error)
                return
            }

            if let data = data , let tmp = data["data"] as? Dictionary<String , Any>, let dict = tmp["data"] as? Dictionary<String , Any>{
                let tagInfoList = dict["taginfo"] as! [Dictionary<String , Any>]
                let subjectInfoList = dict["subjectinfo"] as! [Dictionary<String , Any>]
                
                var subList = [AGSubject]()
                for element in subjectInfoList{
                    let subjectObj = AGSubject.init(data: element)
                    subList.append(subjectObj)
                }
                
                var tagDict = Dictionary<String , [AGTag]>()
                var cateDict = Dictionary<String, Int>()
                
                for element in tagInfoList{
                    let tag = AGTag.init(data: element)
                    if tagDict.index(forKey: tag.categoryName) == nil{
                        tagDict[tag.categoryName] = [tag]
                    }
                    
                    else{
                        var tmp = tagDict[tag.categoryName]
                        tmp!.append(tag)
                        tagDict.updateValue(tmp!, forKey: tag.categoryName)
                    }
                }
                
                for element in tagInfoList{
                    let tag = AGTag.init(data: element)
                    if cateDict.index(forKey: tag.categoryName) == nil{
                        cateDict[tag.categoryName] = tag.categoryId
                    }
                    
                }

                
                print (tagDict)
                print (cateDict)
                finish(subList , tagDict , cateDict, nil)
            }
            else{
                let error = NSError.init()
                finish(nil , nil , nil, error)
            }
        }
    }
    
    // 获取用户的 偏好设置
    func getUserPreferenceSetting(userid: Int, finish: @escaping (_ subjectList:[AGSubject]?, _ tagList:[AGTag]?, _ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "user/getpreference/post"
        
        let params = ["data":["userid" : userid]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(nil, nil, error)
            }
            
            let data = result!["data"] as! Dictionary<String, AnyObject>
            
            let status = data["status"] as! Int
            
            if status == 0{
                finish([], [], nil)
            }
            
            let data2 = data["data"] as! Dictionary<String, AnyObject>
            
            let tagData = data2["tag"] as! [Dictionary<String, AnyObject>]
            
            let subData = data2["sub"] as! [Dictionary<String, AnyObject>]
            
            var tagList = [AGTag]()
            var subList = [AGSubject]()
            
            for element in tagData{
                let tag = AGTag.init(data: element)
                tagList.append(tag)
            }
            
            for element in subData{
                let sub = AGSubject.init(data: element)
                subList.append(sub)
            }
            
            finish(subList, tagList, nil)
        }
        
    }

    
    // 更新用户的 类型偏好 列表
    func updateUserTagPreference(list: [Int] , finish: @escaping (_ success: Bool) -> Void){
        let url = GlobalValue.BASEURL + "preference/tags/multiupdate/post/"
        
        let params = ["data":["userid" : ArtGalleryAppCenter.sharedInstance.user!.userId
            , "tagidlist" : list]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(false)
            }
            
            finish(true)
        }
    }
    
    // 更新用户的 主题偏好 列表
    func updateUserSubjectPreference (list: [Int] , finish: @escaping (_ success: Bool) -> Void){
        let url = GlobalValue.BASEURL + "preference/subjects/multiupdate/post/"
        
        let params = ["data":["userid" : ArtGalleryAppCenter.sharedInstance.user!.userId , "subjectidlist" : list]]
        
        AGBaseNetworkService.sharedInstance.postWithoutCache(url, params: params as Dictionary<String, AnyObject>?) { (result, error) in
            if error != nil{
                finish(false)
            }
            
            finish(true)
        }
    }
}

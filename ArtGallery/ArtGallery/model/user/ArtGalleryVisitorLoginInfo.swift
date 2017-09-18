//
//  ArtGalleryVisitorLogin.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-15.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class ArtGalleryVisitorLoginInfo: NSObject {
    
    var status: Int!
    var userid: Int?
    var FisrtName:String = ""
    var PhotoUrl:String?
    var NickName: String = ""
    var regionID :Int?
    var dataJoined: String?
    var isActive: Int?
    var isSuperuser: Int?
    var lastLogin: String?
    var lastName: String?
    var isAdmin:Int?
    var userStatusID : Int?
    var email:String?
    
    var tagList = [AGTag]()
    var subjectList = [AGSubject]()
    
    init(data: Dictionary<String , AnyObject>) {
        super.init()
        
        if let Status = data["status"] as? Int{
            self.status = Status
            // 1: Activated visitor / artist (Give Access),
            // 0: Inactivated user / Under review or blocked artist (Forbid Access)
        }
        
        let info = data["data"]
        
        // Preference tag list
        
        guard let tags = info!["taginfo"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in tags{
            let tag = AGTag.init(data: element)
            self.tagList.append(tag)
        }

        // Preference subject list
        
        guard let subjects = info!["subjectinfo"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in subjects{
            let subject = AGSubject.init(data: element)
            self.subjectList.append(subject)
        }
        
        // Basic info
        
        if let userinfo = info!["userinfo"] as? [Dictionary<String, AnyObject>]{
            
            for e in userinfo{
            
                if let firstname = e["firstname"] as? String{
                    self.FisrtName = firstname
                }
            
                if let photourl = e["photourl"] as? String{
                    self.PhotoUrl = photourl
                }
            
                if let nickname = e["nickname"] as? String{
                    self.NickName = nickname
                }
            
                if let regionid = e["regionid"] as? Int{
                    self.regionID = regionid
                }
            
                if let userid = e["userid"] as? Int{
                    self.userid = userid
                }
            
                if let datejoined = e["datejoined"] as? String{
                    self.dataJoined = datejoined
                }
            
                if let is_active = e["is_active"] as? Int{
                    self.isActive = is_active
                }
            
                if let is_superuser = e["is_superuser"] as? Int{
                    self.isSuperuser = is_superuser
                }
            
                if let last_login = e["last_login"] as? String{
                    self.lastLogin = last_login
                }
            
            
                if let lastname = e["lastname"] as? String{
                    self.lastName = lastname
                }
            
                if let is_admin = e["is_admin"] as? Int{
                    self.isAdmin = is_admin
                }
            
                if let userstatusid = e["userstatusid"] as? Int{
                    self.userStatusID = userstatusid
                }
            
                if let email = e["email"] as? String{
                    self.email = email
                }
            }
        }
    }
}

//
//  AGArtistLogin.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-15.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit


class AGArtistLoginInfo: NSObject {
    var status: Int!
    var userid: Int?
    var FirstName:String = ""
    var PhotoUrl:String?
    var NickName: String?
    var regionID :Int?
    var dataJoined: String?
    var isActive: Int?
    var isSuperuser: Int?
    var lastLogin: String?
    var lastName: String = ""
    var isAdmin:Int?
    var userStatusID : Int?
    var email:String = ""
    
    var gender: Int = 0
    var age: Int  = 0
    var artworkCategory: String = ""
    var phone: String = ""
    var artistID: Int!
    var address: String = ""
    var artworkNum: Int = 0
    var fansNumber: Int = 0
    
    var representativeWork: String = ""
    var website : String = ""
    
    
    var tagList = [AGTag]()
    var subjectList = [AGSubject]()
    
    init(data: Dictionary<String , AnyObject>) {
        super.init()


        if let Gender = data["gender"] as? Int{
            self.gender = Gender
        }
        if let Age = data["age"] as? Int{
            self.age = Age
        }
        if let artworkcategory = data["artworkcategory"] as? String{
            self.artworkCategory = artworkcategory
        }
        if let Phone = data["phone"] as? String{
            self.phone = Phone
        }

        if let artistid = data["artistid"] as? Int{
            self.artistID = artistid
        }

        if let Address = data["address"] as? String{
            self.address = Address
        }

        if let artworknum = data["artworknum"] as? Int{
            self.artworkNum = artworknum
        }
        if let fansnumber = data["fansnumber"] as? Int{
            self.fansNumber = fansnumber
        }

        // Preference tag list
        guard let tags = data["taginfo"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in tags{
            let tag = AGTag.init(data: element)
            self.tagList.append(tag)
        }
        
        // Preference subject list
        
        guard let subjects = data["subjectinfo"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in subjects{
            let subject = AGSubject.init(data: element)
            self.subjectList.append(subject)
        }
        
        // Basic info
        
        if let userinfo = data["userinfo"] as? [Dictionary<String, AnyObject>]{
            
            for e in userinfo{
                
                if let firstname = e["firstname"] as? String{
                    self.FirstName = firstname
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
                
                if let userId = e["userid"] as? Int{
                    self.userid = userId
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
                
                if let Email = e["email"] as? String{
                    self.email = Email
                }
            }
        }
    }
}

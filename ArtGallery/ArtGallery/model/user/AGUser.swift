//
//  AGUser.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-20.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGUser: NSObject {
    var userStatusID: Int?
    var firstName: String?
    var photoUrl: String?
    var regionID: Int?
    var userID: Int?
    var dateJoined:String?
//  var isActive: Int?
//  var isSuperUser: Int?
    var lastLogin: String?
    var nickName: String?
    var email: String?
    var category: String?
    var artistid: Int?
    var artisttitle: String?
    var worknum: Int?
    var followernum: Int = 0
    
    
    // 登录用户是否关注这个用户
    var isFollowed: Int! = 1 // 0 没关注， 1 关注
    
    init(data: Dictionary<String , AnyObject>){
        if let UserStatusID = data["userstatusid"] as? Int{
            self.userStatusID = UserStatusID
        }
        
        if let FirstName = data["firstname"] as? String{
            self.firstName = FirstName
        }
        
        if let PhotoUrl = data["photourl"] as? String{
            self.photoUrl = PhotoUrl
        }
        
        
        if let RegionID = data["regionid"] as? Int{
            self.regionID = RegionID
        }
        
        if let UserID = data["userid"] as? Int{
            self.userID = UserID
        }
        
        if let DateJoined = data["datejoined"] as? String{
            self.dateJoined = DateJoined
        }
        
//        if let IsActive = data["is_active"] as? Int{
//            self.isActive = IsActive
//        }
//        
//        if let IsSuperUser = data["is_superuser"] as? Int{
//            self.isSuperUser = IsSuperUser
//        }
//        
//        if let LastLogin = data["last_login"] as? String{
//            self.lastLogin = LastLogin
//        }
        
        if let NickName = data["nickname"] as? String{
            self.nickName = NickName
        }
        
        if let Email = data["email"] as? String{
            self.email = Email
        }
        
        // Artist User
        if let category = data["categoryname"] as? String{
            self.category = category
        }
        
        if let artistID = data["artistid"] as? Int{
            self.artistid = artistID
        }
        
        if let title = data["artistcategory"] as? String{
            self.artisttitle = title
        }
        
        if let followers = data["followernum"] as? Int{
            self.followernum = followers
        }
        
        if let works = data["artworknum"] as? Int{
            self.worknum = works
        }
        
        if let isfollow = data["isfollowed"] as? Int{
            self.isFollowed = isfollow
        }

    }
}

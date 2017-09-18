//
//  ArtGalleryBaseUser.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

/*
 描述： 系统用户的基本类， 普通用户， 艺术家 和 游客都应基于 该类
 */

import Foundation

enum UserType: Int{
    case SeeAround = 0, Artist, Visitor
    
}

class ArtGalleryBaseUser: NSObject {
    
    var userId: Int
    var photourl: String
    var regionid: Int
    var userName:String
    var emailAddr: String
    var userType: UserType
    
    init(_ userId: Int, userName: String , email: String, type: UserType, regionId: Int, photoUrl: String) {
        self.userId = userId
        self.userName = userName
        self.emailAddr = email
        self.userType = type
        self.regionid = regionId
        self.photourl = photoUrl
        super.init()
    }

}

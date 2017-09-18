//
//  ArtGalleryArtistUser.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class ArtGalleryArtistUser: ArtGalleryBaseUser {
    
    var artistId:Int
    var status: Int!
    var userid: Int?
    var FirstName:String?
//    var PhotoUrl:String?
    var NickName: String?
    var regionID :Int?
    var dataJoined: String?
    var isActive: Int?
    var isSuperuser: Int?
    var lastLogin: String?
    var lastName: String?
    var isAdmin:Int?
    var userStatusID : Int?
    var email:String?
    
    var gender: Int = 0
    var age: Int  = 0
    var artworkCategory: String = ""
    var phone: String = ""
    var artistID: Int!
    var address: String = ""
    var artworkNum: Int = 0
    var fansNumber: Int = 0
    
    var tagList = [AGTag]()
    var subjectList = [AGSubject]()

    var info: AGArtistLoginInfo!
    
    init(artistID: Int , info: AGArtistLoginInfo, regionId: Int){
        self.info = info
        self.artistId = artistID
        self.regionID = regionId
        self.FirstName = info.FirstName
        self.fansNumber = info.fansNumber
//        self.PhotoUrl = info.PhotoUrl
        self.email = info.email
        self.NickName = info.NickName
        self.artworkCategory = info.artworkCategory
        super.init(info.userid!, userName: self.NickName!, email: self.email!, type: .Artist, regionId:regionId, photoUrl: info.PhotoUrl!)
    }
    
}

//
//  ArtGalleryVisitorUser.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class ArtGalleryVisitorUser: ArtGalleryBaseUser {
    
    var info: ArtGalleryVisitorLoginInfo
    
    init(userID: Int , userInfo: ArtGalleryVisitorLoginInfo, regionId:Int, photoURL:String){
        self.info = userInfo
        super.init(userID, userName: "", email: "", type: .Visitor, regionId: regionId, photoUrl: photoURL)
        self.userName = info.NickName
        self.emailAddr = info.email!
    }
    
}

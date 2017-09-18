//
//  AGArtistBasicInfo.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistBasicInfo: NSObject {
    var id: Int!
    var firstName: String = ""
    var lastName: String  = ""
    var fanNumber: Int = 0
    var artworkNum: Int = 0
    var artistTypeList: [String] = [String]()
    var dateJoined: String = ""
    var address: String = ""
    var artworkCategory: String = ""
    
    var gender: Int = 0
    var age: Int = 0
    
    init(data: Dictionary<String , AnyObject>) {
        super.init()

        if let ID = data["artistid"] as? Int{
            self.id = ID
        }
        
        if let FirstName = data["firstname"] as? String{
            self.firstName = FirstName
        }
        
        if let LastName = data["lasttname"] as? String{
            self.lastName = LastName
        }
        
        if let FanNumber = data["fansnumber"] as? Int{
            self.fanNumber = FanNumber
        }
        
        if let ArtworkNum = data["artworknum"] as? Int{
            self.artworkNum = ArtworkNum
        }
        
        if let ArtistTypeList = data["artisttype"] as? [String]{
            self.artistTypeList = ArtistTypeList
        }
        
        if let DateJoined = data["datejoined"] as? String{
            self.dateJoined = DateJoined
        }
        
    }
}

//
//  AGArtistList.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-16.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtist: NSObject {

    var userid: Int!
    var artistid: Int!
    var firstName: String!
    var lastName: String!
    var artworklist = [AGArtwork]()
    var artworknum: Int?
    var followernum: Int?
    var photourl: String?
    var category: String?
    var date: String?
    
    init(data: Dictionary<String , AnyObject>) {
        super.init()
        
        if let FirstName = data["firstname"] as? String{
            self.firstName = FirstName
        }
        
        if let LastName = data["lastname"] as? String{
            self.lastName = LastName
        }
        
        if let UID = data["userid"] as? Int{
            self.userid = UID
        }
        if let AID = data["artistid"] as? Int{
            self.artistid = AID
        }
        
        if let follower = data["followernum"] as? Int{
            self.followernum = follower
        }

        if let worknum = data["artworknum"] as? Int{
            self.artworknum = worknum
        }
        
        if let title = data["artistcategory"] as? String{
            self.category = title
        }
        
        if let Date = data["datejoined"] as? String{
            self.date = Date
        }
    }

}

//
//  AGRegions.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-17.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGRegion: NSObject {
    
    var name: String?
    var id: Int?
    
    init(data: Dictionary<String, AnyObject>){
        if let Name = data["name"] as? String{
            self.name = Name
        }
        
        if let Id = data["regionid"] as? Int{
            self.id = Id
        }
    }

    init(key:String, value:Int){
        self.id = value
        self.name = key
    }
}

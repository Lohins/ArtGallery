//
//  ArtworkList.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-16.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtworkList: NSObject {
    
    var status: Int!
    var artworklist = [AGArtwork]()
    
    init(data: Dictionary<String , AnyObject>) {
        super.init()
        
        if let Status = data["status"] as? Int{
            self.status = Status
        }
        
        guard let artworklist = data["data"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in artworklist{
            let artwork = AGArtwork.init(data: element)
            self.artworklist.append(artwork)
        }
    }

}

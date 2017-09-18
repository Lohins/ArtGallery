//
//  AGExhibition.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-16.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGExhibition: NSObject {
    
    var postTime: String?
    var imagePath: String?
    var title: String?
    var abstract: String?
    var content: String?
    var id: Int?
    
    init(data: Dictionary<String, AnyObject>){
        if let PostTime = data["posttime"] as? String{
            self.postTime = PostTime
        }
        
        if let path = data["thumbnails"] as? String{
            self.imagePath = path
        }
        
        if let Title = data["title"] as? String{
            self.title = Title
        }
        
        if let Abstract = data["abstract"] as? String{
            self.abstract = Abstract
        }
        
        if let Content = data["content"] as? String{
            self.content = Content
        }
        
        if let exhibitionid = data["exhibitionid"] as? Int{
            self.id = exhibitionid
        }
    }

}

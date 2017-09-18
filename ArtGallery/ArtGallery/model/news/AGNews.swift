//
//  AGNews.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-16.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

/*  JSON Response
 
 "newsid": 1,
 "abstract": null,
 "createddate": "2016-11-18T20:10:10",
 "thumbnails": "~/img/gala.jpg",
 "title": "Online Bidding Now Open for Canadian Arts Gala Auction"
 
 */


import UIKit

class AGNews: NSObject {
    
    var postTime: String?
    var imagePath: String?
    var title: String?
    var abstract: String?
    var id: Int?
    var content: String?
    var author: String?
    
    init(data: Dictionary<String, AnyObject>){
        if let PostTime = data["createddate"] as? String{
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
        
        if let newsid = data["newsid"] as? Int{
            self.id = newsid
        }
        
        if let Author = data["author"] as? String{
            self.author = Author
        }
    }

}

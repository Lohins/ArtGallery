//
//  AGExhibit.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-20.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGExhibit: NSObject {
    
    var author: String?
    var title: String?
    var userID: Int?
    var content: String?
    var exhibitID: Int?
    var fileUrl: String?
    
    init(data: Dictionary<String, AnyObject>){
        if let Author = data["author"] as? String{
            self.author = Author
        }
        
        if let Title = data["title"] as? String{
            self.title = Title
        }
        
        if let UserId = data["userid"] as? Int{
            self.userID = UserId
        }
        
        if let Content = data["content"] as? String{
            self.content = Content
        }
        
        if let ExhibitId = data["exhibitid"] as? Int{
            self.exhibitID = ExhibitId
        }
        
        if let FileUrl = data["fileurl"] as? String{
            self.fileUrl = FileUrl
        }
    }

}

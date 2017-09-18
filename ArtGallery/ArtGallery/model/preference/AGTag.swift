//
//  AGTag.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGTag: NSObject {
    
    var tagId: Int!
    var categoryId: Int!
    var tagName: String!
    var categoryName: String!
    
    init(data: Dictionary<String , Any>) {
        super.init()
        
        if let tagid = data["tagid"] as? Int{
            self.tagId = tagid
        }
        
        if let categoryid = data["categoryid"] as? Int{
            self.categoryId = categoryid
        }
        
        if let tagname = data["tagname"] as? String{
            self.tagName = tagname
        }
        
        if let categoryname = data["categoryname"] as? String{
            self.categoryName = categoryname
        }
        
        
    }
    
    func isEqual(object: AGTag) -> Bool {
        if self.tagId! == object.tagId! &&  self.tagName! == object.tagName!{
            return true
        }
        
        return false
    }

}

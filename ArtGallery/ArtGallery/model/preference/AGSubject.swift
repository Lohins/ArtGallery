//
//  AGSubject.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGSubject: NSObject {
    
    var subjectName: String!
    var subjectId : Int!
    
    init(data: Dictionary<String , Any>) {
        super.init()
        
        if let subjectid = data["subjectid"] as? Int{
            self.subjectId = subjectid
        }
        
        if let subjectname = data["subjectname"] as? String{
            self.subjectName = subjectname
        }
    }
    
    func isEqual(object: AGSubject) -> Bool{
        if self.subjectId == object.subjectId {
            return true
        }
        
        return false
    }
}

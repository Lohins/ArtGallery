//
//  AGComment.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-17.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGComment: NSObject {

    /* JSON RESPONSE
     
     "data":[
        {
            "comment": "Here comes trouble!",
            "artworkid": 2,
            "userid": 2,
            "parentid": 0,
            "targetid": 0,
            "createddate": null,
            "commentid": 1
        },
        {
            "comment": "My target is the comment of no 2",
            "artworkid": 2,
            "userid": 3,
            "parentid": 2,
            "targetid": 2,
            "createddate": null,
            "commentid": 2
        }
     ]
     
     */
    
    //每一条评论的parentid和targetid不用解析，因为当前版本不设评论层数，不支持对评论进行评论和回复
    //Post的时候，前端paretntid, commentid都 hard code 为0
    
    var content: String = ""
    var artworkId: Int = -1
    var userId: Int  = -1
    var parentId : Int = -1
    var targetId: Int = -1
    var createDate: String = ""
    var postUserName: String = "My Comment"
    var commentId: Int = -1
    var photourl: String = ""
    
    init(data: Dictionary<String, AnyObject>){
        
        if let Content = data["comment"] as? String{
            self.content = Content
        }
        
        if let Artworkid = data["artworkid"] as? Int{
            self.artworkId = Artworkid
        }
        
        if let Userid = data["userid"] as? Int{
            self.userId = Userid
        }
        
        if let parentid = data["parentid"] as? Int{
            self.parentId = parentid
        }
        
        if let targetid = data["targetid"] as? Int{
            self.targetId = targetid
        }
        
        if let createddate = data["createddate"] as? String{
            self.createDate = createddate
        }
        
        if let commentid = data["commentid"] as? Int{
            self.commentId = commentid
        }
        
        if let name = data["nickname"] as? String{
            self.postUserName = name
        }
        
        if let photo = data["photourl"] as? String{
            self.photourl = photo
        }
    }
        
}

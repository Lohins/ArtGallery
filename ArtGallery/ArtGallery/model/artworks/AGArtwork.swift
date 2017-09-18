//
//  AGWork.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit


class AGArtwork: NSObject {
    
    
    var worksType: WorksType = .Photo
    
    var id:Int!
    var type:String!
    var imagePath: String!
    var caption: String!
    var updateDate: String!
    var likeNum: Int = 0
    var commentNum: Int = 0
    var isLiked: Int = 0  // 1 - yes , 0 - no
    var isCollected:Int = 0  // 1 - yes , 0 - no
    var isFollowed: Int = 0  // 1 - yes , 0 - no
    
    var artistName: String = "Artist Name"
    var artistID:Int!
    var userID: Int = -1
    var status: Int!  // 1 是公开， 0 是仅自己可见
    var desc : String!
    var subjectID: Int!
    var audioLink: String!
    var createDate: String!
    var videoLink: String!
    var subjectName: String = ""
    
    var followerNum: Int = 0
    
    var category: String!
    
    var tagsList = [AGTag]()
    var subjectList = [AGSubject]()
    
    init(data: Dictionary<String, AnyObject>) {
        
        if let Id = data["artworkid"] as? Int{
            self.id = Id
        }
        
        if let Type = data["artworktype"] as? String{
            self.type = Type
        }
        
        if let ImagePath = data["imagepath"] as? String{
            self.imagePath = ImagePath
        }
        
        if let Caption = data["caption"] as? String{
            self.caption = Caption
        }
        
        if let SubjectName = data["subjectname"] as? String{
            self.subjectName = SubjectName
        }
        
        if let followernum = data["followernum"] as? Int{
            self.followerNum = followernum
        }
        
        if let likenum = data["likenum"] as? Int{
            self.likeNum = likenum
        }
        
        if let commentnum = data["commentnum"] as? Int{
            self.commentNum = commentnum
        }
        
        if let UpdateDate = data["updatedate"] as? String{
            self.updateDate = UpdateDate
        }
        
        if let userid = data["userid"] as? Int{
            self.userID = userid
        }
        
        if let LikeNum = data["likenum"] as? Int{
            self.likeNum = LikeNum
        }
        
        if let CommentNum = data["commentnum"] as? Int{
            self.commentNum = CommentNum
        }
        
        if let IsLike = data["isliked"] as? Int{
            self.isLiked = IsLike
        }
        
        if let IsCollected = data["iscollected"] as? Int{
            self.isCollected = IsCollected
        }
        
        if let Isfollowed = data["isfollowed"] as? Int{
            self.isFollowed = Isfollowed
        }
        
        if let Name = data["firstname"] as? String{
            self.artistName = Name
        }
        
        
        if let VideoLink = data["videoembedcode"] as? String{
            self.videoLink = VideoLink
            if self.videoLink == ""{
                self.worksType = .Photo
            }
            else{
                self.worksType = .Video
            }
        }
        super.init()
    }
    
    init(detail data: Dictionary<String , AnyObject>) {
        super.init()
        
        // info
        
        guard let info = data["info"] as? Dictionary<String ,AnyObject> else {
            return
        }
        
        if let Id = info["artworkid"] as? Int{
            self.id = Id
        }
        
        if let ImagePath = info["imagepath"] as? String{
            self.imagePath = ImagePath
        }
        
        if let Desc = info["description"] as? String{
            self.desc = Desc
        }
        
        if let Status = info["status"] as? Int{
            self.status = Status
        }
        
        if let updateddate = info["updateddate"] as? String{
            self.updateDate = updateddate
        }
        
        if let subjectid = info["subjectid"] as? Int{
            self.subjectID = subjectid
        }
        
        if let Caption = info["caption"] as? String{
            self.caption = Caption
        }
        
        if let artistid = info["artistid"] as? Int{
            self.artistID = artistid
        }
        
        if let AudioLink = info["audioexternallink"] as? String{
            self.audioLink = AudioLink
        }
        
        if let createddate = info["createddate"] as? String{
            self.createDate = createddate
        }
        
        if let VideoLink = info["videoembedcode"] as? String{
            self.videoLink = VideoLink
            if self.videoLink == ""{
                self.worksType = .Photo
            }
            else{
                self.worksType = .Video
            }
        }
        
        if let Name = info["firstname"] as? String{
            self.artistName = Name
        }
        
        // tag list
        
        guard let tags = data["tag"] as? [Dictionary<String , AnyObject>] else {
            return
        }
        
        for element in tags{
            let tag = AGTag.init(data: element)
            self.tagsList.append(tag)
        }
        
        
        
        // subject list
        guard let subjects = data["subject"] as? [Dictionary<String , AnyObject>]  else {
            return
        }
        
        for element in subjects{
            let sub = AGSubject.init(data: element)
            self.subjectList.append(sub)
        }
        
        
    }
    
    func getTags() -> String{
        var result = [String]()
        for element in self.tagsList{
            result.append(element.tagName)
        }
        return result.joined(separator: ", ")
    }
    
    // 暂时处理， 由于作品的详情页面有一部分数据不全， 所以将 列表传进的 artwork 和 详情页名请求到的 artwork 进行结合。
    func update(append work: AGArtwork){
        self.id = work.id
        self.imagePath = work.imagePath
        self.desc = work.desc
        self.status = work.status
        self.updateDate = work.updateDate
        self.subjectID = work.subjectID
        self.caption = work.caption
        self.artistID = work.artistID
        self.audioLink = work.audioLink
        self.createDate = work.createDate
        self.videoLink = work.videoLink
        self.tagsList = work.tagsList
        self.subjectList = work.subjectList
    }
}


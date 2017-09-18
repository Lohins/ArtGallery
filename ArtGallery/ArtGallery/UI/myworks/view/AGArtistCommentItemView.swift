//
//  AGArtistCommentItemView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-30.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistCommentItemView: UIView {
    
    var iconImageView: UIImageView!
    var timeLabel: UILabel!
    var nameLabel: UILabel!
    var contentLabel: UILabel!
    
    var comment: AGComment!
    
    var replyBlock: (() -> Void)?
    
    convenience init(frame: CGRect , commentObj:AGComment){
        
        self.init(frame: frame)
        self.comment = commentObj
        updateUI()
    
    }
    // override initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    func updateUI(){
        let labelWidth = GlobalValue.SCREENBOUND.width - 18 - 39 - 10 - 25
        
        self.iconImageView = UIImageView.init(frame: CGRect.init(x: 18, y: 0, width: 45, height: 45))
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.borderWidth = 1
        self.iconImageView.layer.borderColor = UIColor.init(floatValueRed: 248, green: 248, blue: 248, alpha: 0.8).cgColor
        
        
        self.timeLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.right + 10, y: 0, width: labelWidth, height: 12))
        self.timeLabel.font = UIFont.init(name: "Montserrat-Regular", size: 10)
        self.timeLabel.textColor = UIColor.init(floatValueRed: 240, green: 113, blue: 68, alpha: 1)
        
        
        self.nameLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.right + 10, y: self.timeLabel.bottom + 5, width: labelWidth, height: 15))
        self.nameLabel.font = UIFont.init(name: "OpenSans-Bold", size: 12)
        self.nameLabel.textColor = UIColor.init(floatValueRed: 240, green: 113, blue: 68, alpha: 1)
        
        // comment 占得size
        let constraintSize = CGSize.init(width: labelWidth , height: GlobalValue.SCREENBOUND.height)
        let font = UIFont.init(name: "OpenSans", size: 11)
        let attr = [ NSFontAttributeName: font!  ]
        let suitableSize = String.getBound(comment.content, size: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil)
        
        
        self.contentLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.right + 10, y: self.nameLabel.bottom + 5, width: labelWidth, height: suitableSize.height))
        self.contentLabel.font = UIFont.init(name: "OpenSans", size: 11)
        self.contentLabel.lineBreakMode = .byWordWrapping
        self.contentLabel.numberOfLines = 0
        self.contentLabel.textColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1)
        
        
        // comment Button View
        let commentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        commentView.right = GlobalValue.SCREENBOUND.width
        
        let commentLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        commentLabel.font = UIFont.init(name: "OpenSans", size: 11)
        commentLabel.textAlignment = .right
        commentLabel.textColor = UIColor.init(floatValueRed: 240, green: 112, blue: 68, alpha: 1)
        commentLabel.text = String.localizedString("AGArtistCommentItemView-reply")
        commentLabel.center = CGPoint.init(x: commentView.width / 2, y: commentView.height / 2)
        commentLabel.right = CGFloat(25)
        commentView.addSubview(commentLabel)

        
        let commentIconView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        commentIconView.image = UIImage.init(named: "bookmark_comment_icon")
        commentIconView.center = CGPoint.init(x: commentView.width / 2, y: commentView.height / 2)
        commentIconView.left = CGFloat(0)
//        commentView.addSubview(commentIconView)
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        commentView.addSubview(button)
        print(suitableSize)
        let f = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: self.contentLabel.bottom + 10)
        self.frame = f
        
        button.addTarget(self, action: #selector(replyAction), for: .touchUpInside)
        
        self.addSubview(iconImageView)
        self.addSubview(timeLabel)
        self.addSubview(nameLabel)
        self.addSubview(contentLabel)
        self.addSubview(commentView)
        
        self.timeLabel.text = self.comment.createDate
        self.nameLabel.text = self.comment.postUserName
        self.contentLabel.text = self.comment.content
        let str:String = self.comment.photourl
        let url = URL.init(string: str)
        self.iconImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "explore_users_icon"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replyAction(){
        if let blk = self.replyBlock{
            blk()
        }
    }
    class AddCommentView: UIView{
        
    }
}

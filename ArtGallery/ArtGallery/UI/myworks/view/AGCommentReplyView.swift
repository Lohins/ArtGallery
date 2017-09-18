//
//  AGCommentReplyView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-18.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGCommentReplyView: UIView {
    var iconImageView: UIImageView!
    var nameLabel: UILabel!

    var btnView: UIView!
    var editBtn: UIButton!
    var deleteBtn: UIButton!
    var timeLabel: UILabel!
    var contentLabel: UILabel!
    
    var time: String!
    var comment: String!
    
    convenience init(frame: CGRect ,data: Dictionary<String, String>){
        self.init(frame: frame)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setupUI(){
        let labelWidth = GlobalValue.SCREENBOUND.width - 25 - 39 - 10 - 25
        
        self.iconImageView = UIImageView.init(frame: CGRect.init(x: 25, y: 0, width: 45, height: 45))
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.borderWidth = 1
        self.iconImageView.layer.borderColor = UIColor.init(floatValueRed: 248, green: 248, blue: 248, alpha: 0.8).cgColor
        
        self.timeLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.right + 10, y: 0, width: labelWidth, height: 12))
        self.timeLabel.font = UIFont.init(name: "Montserrat-Regular", size: 10)
        self.timeLabel.textColor = UIColor.init(floatValueRed: 240, green: 113, blue: 68, alpha: 1)
        
        // nameLabel 中应该显示 谁 - 回复了 谁
        self.nameLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.right + 10, y: self.timeLabel.bottom + 5, width: labelWidth, height: 15))
        self.nameLabel.font = UIFont.init(name: "Montserrat-Bold", size: 12)
        self.nameLabel.textColor = UIColor.init(floatValueRed: 240, green: 113, blue: 68, alpha: 1)
        
        // comment 占得size
        let constraintSize = CGSize.init(width: labelWidth , height: GlobalValue.SCREENBOUND.height)
        let font = UIFont.init(name: "Montserrat-Regular", size: 11)
        let attr = [ NSFontAttributeName: font!  ]
        let suitableSize = String.getBound(comment, size: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil)
        
        
        self.btnView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 47, height: 21))
        let bgImageView = UIImageView.init(frame: btnView.frame)
        bgImageView.image = UIImage.init(named: "myworks_edit_icon")
        self.editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 23, height: 21))
        self.deleteBtn = UIButton.init(frame: CGRect.init(x: self.editBtn.right, y: 0, width: 23, height: 21))
        
        self.timeLabel = UILabel.init(frame: CGRect.init(x: 5, y: 7, width: frame.width, height: 12))
        self.timeLabel.font = UIFont.init(name: "Montserrat-Regular", size: 10)
        self.timeLabel.textColor = UIColor.init(floatValueRed: 240, green: 113, blue: 68, alpha: 1)
        self.timeLabel.text = time
        
        self.contentLabel = UILabel.init(frame: CGRect.init(x: 5, y: 21, width: GlobalValue.SCREENBOUND.width - 69 - 8 , height: suitableSize.height))
        self.contentLabel.font = UIFont.init(name: "Montserrat-Regular", size: 11)
        self.contentLabel.textColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1)
        self.contentLabel.text = comment
        
        
        self.btnView.addSubview(bgImageView)
        self.btnView.addSubview(self.editBtn)
        self.btnView.addSubview(self.deleteBtn)
        
        self.addSubview(btnView)
        self.addSubview(self.timeLabel)
        self.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

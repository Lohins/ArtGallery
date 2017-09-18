//
//  AGUploadWorkTextfieldBox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGUploadWorkTextfieldBox: UIView {
    
    var textfield: UITextField!

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String){
        self.init(frame: frame)
        
        setupUI(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(title: String){
        
        
        
        let rawImg = UIImage.init(named: "upload_input_border")
        

        let stretchImg = rawImg?.stretchableImage(withLeftCapWidth: Int((rawImg?.size.width)! / 2), topCapHeight: Int((rawImg?.size.height)! / 2))
        
        let bgImgView = UIImageView.init()
        bgImgView.image = stretchImg
        bgImgView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.addSubview(bgImgView)
        
        let gap = CGFloat(20)
        let height = CGFloat(20)
        
        self.textfield = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width - gap * 2, height: height))
        self.textfield.center = bgImgView.center
        
        let textColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1)
        self.textfield.textColor = textColor
        self.textfield.font = GlobalValue.StandardFontForText
        let attributedString = NSMutableAttributedString.init(string: title, attributes: [NSFontAttributeName: UIFont.init(name: "OpenSans", size: CGFloat(13))!])
        attributedString.addAttributes([NSForegroundColorAttributeName: textColor ], range: NSRange.init(location: 0, length: title.characters.count))
        self.textfield.attributedPlaceholder = attributedString
        
        self.addSubview(textfield)

        
    }
    
    func updateData(content: String){
        self.textfield.text = content
    }

    func getInfo() -> String?{
        return self.textfield.text
    }
}

//
//  AGHasIconTextbox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGHasIconTextbox: UIView {
    
    // default to load xib file

    var view: UIView!
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib()-> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AGHasIconTextbox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // --------------------------
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    
//    convenience init( frame: CGRect, iconName: String , text: String){
//        self.init(frame: frame)
//        
//        self.iconView.image = UIImage.init(named: iconName)
//        self.iconView.contentMode = .scaleAspectFit
//        
//        self.textField.placeholder = text
//        //self.textField.textColor = UIColor.white
//        self.textField.font = GlobalValue.StandardFontForText
//
//        let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSFontAttributeName: UIFont.init(name: "OpenSans", size: CGFloat(13))!])
//        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSRange.init(location: 0, length: text.characters.count))
//        self.textField.attributedPlaceholder = attributedString
//        
//        
//        
//    }
    
    convenience init( frame: CGRect, iconName: String , text: String, isSecureText: Bool){
        self.init(frame: frame)
        
        self.iconView.image = UIImage.init(named: iconName)
        self.iconView.contentMode = .scaleAspectFit
        
        self.textField.placeholder = text
        //self.textField.textColor = UIColor.white
        self.textField.font = GlobalValue.StandardFontForText
        
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSFontAttributeName: UIFont.init(name: "OpenSans", size: CGFloat(13))!])
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSRange.init(location: 0, length: text.characters.count))
        self.textField.attributedPlaceholder = attributedString
        self.textField.isSecureTextEntry = isSecureText
        
        
    }

    
    func getInfo() -> String?{
        return self.textField.text
    }

}

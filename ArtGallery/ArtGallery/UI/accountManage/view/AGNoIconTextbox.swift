//
//  AGNoIconTextbox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGNoIconTextbox: UIView {
    
    
    @IBOutlet weak var bgImageView: UIImageView!
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
        let nib = UINib(nibName: "AGNoIconTextbox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func getInfo() -> String?{
        return self.textField.text
    }
    
    func getIntInfo() -> Int?{
        if self.textField.text == ""{
            return -1
        }
        else{
            return Int(self.textField.text!)
        }
    }
    
    
    // ------------
    
    @IBOutlet weak var textField: UITextField!

    convenience init(frame: CGRect, bgImgName: String, text: String, isSecure: Bool){
        self.init(frame : frame)
        self.textField.placeholder = "Test"
        self.textField.textColor = UIColor.white
        self.textField.font = GlobalValue.StandardFontForText
        self.textField.isSecureTextEntry = isSecure
        
        self.bgImageView.image = UIImage.init(named: bgImgName)
        
//        UIColor.init(red: 0, green: 0, blue:0, alpha: 0.25)
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSFontAttributeName: UIFont.init(name: "OpenSans", size: CGFloat(13))!])
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.white ], range: NSRange.init(location: 0, length: text.characters.count))
        self.textField.attributedPlaceholder = attributedString
        
    }

}

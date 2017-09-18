//
//  AGCommentTextBox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGCommentTextBox: UIView {

    var view: UIView!
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
        self.textfield.returnKeyType = .done
        self.textfield.delegate = self
        
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
        let nib = UINib(nibName: "AGCommentTextBox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // --------------------
    @IBOutlet weak var textfield: UITextField!
    
    var flag: Bool = true // true 是 comment， false 是 reply。
    
    var replyTarget:String = "" // 回复对象的 名称
    
    var isDisplayed: Bool = false{
        didSet{
            if self.isDisplayed == true{
                self.textfield.becomeFirstResponder()
            }
            else{
                self.textfield.resignFirstResponder()
            }
        }
    }
    
    func setCommentMode(){
        self.flag = true
    }
    
    func setReplyMode(target : String){
        self.flag = false
        self.replyTarget = target
    }
    
    var InputFinishBlock: ((_ text: String)-> Void)?
}

extension AGCommentTextBox: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text != ""{
            if let blk = self.InputFinishBlock{
                if self.flag == false{
                    let modiftText = "reply to \(self.replyTarget) : \(text)"
                    blk(modiftText)
                }
                else{
                    blk(text)
                }
            }
        }
        textfield.text = ""
        self.isDisplayed = false
        return true
    }
}

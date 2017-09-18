//
//  AGExploreSearchView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-19.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGExploreSearchView: UIView {

    var view: UIView!
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
        self.textfield.delegate = self
        self.textfield.returnKeyType = .go
        
        self.imageButton.isSelected = true
        self.userButton.isSelected = false
        
        self.picImageView.image = UIImage.init(named: "explore_works_icon")
        self.userImageView.image = UIImage.init(named: "explore_users_icon_opacity")
        
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
        let nib = UINib(nibName: "AGExploreSearchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // ----
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var picImageView: UIImageView!
    
    @IBOutlet weak var textfield: UITextField!

    
    @IBAction func picAction(_ sender: AnyObject) {
        
        self.imageButton.isSelected = true
        self.userButton.isSelected = false
        
        self.picImageView.image = UIImage.init(named: "explore_works_icon")
        self.userImageView.image = UIImage.init(named: "explore_users_icon_opacity")


        
        guard let text = self.textfield.text, text != "" else{
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name.init("workSearchKeyword" ), object: ["workKeyword": text])
        
        self.textfield.resignFirstResponder()
    }
    
    @IBAction func userAction(_ sender: AnyObject) {
        
        self.imageButton.isSelected = false
        self.userButton.isSelected = true
        
        self.picImageView.image = UIImage.init(named: "explore_works_icon_opacity")
        self.userImageView.image = UIImage.init(named: "explore_users_icon")
        
        guard let text = self.textfield.text, text != "" else{
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name.init("artistSearchKeyword" ), object: ["artistKeyword": text])
        self.textfield.resignFirstResponder()

    }
    
}


extension AGExploreSearchView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 如果当前work 的button是选中的
        if self.imageButton.isSelected{
            guard let text = self.textfield.text, text != "" else{
                return true
            }
            NotificationCenter.default.post(name: Notification.Name.init("workSearchKeyword" ), object: ["workKeyword": text])
        }
        // 如果当前artist 的button是选中的
        else{
            
            guard let text = self.textfield.text, text != "" else{
                return true
            }
            
            NotificationCenter.default.post(name: Notification.Name.init("artistSearchKeyword" ), object: ["artistKeyword": text])
        }
        
        textField.resignFirstResponder()
        return true
    }
}

//
//  AGArtistFieldView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-28.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistFieldItemView: UIView {
    
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
        let nib = UINib(nibName: "AGArtistFieldItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    // tag 用的是小图， subject 用的是大图
    
    var unSelectedBGImageName: String!
    var selectedBGImageName: String!

    
    var isSelected: Bool = false{
        didSet{
            if isSelected == true{
                self.bgImageView.image = UIImage.init(named: self.selectedBGImageName)
                self.titleLabel.textColor = UIColor.white
            }
            else{
                self.bgImageView.image = UIImage.init(named: self.unSelectedBGImageName)
                self.titleLabel.textColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1)

            }
        }
    }
    
    var title: String = ""

    convenience init(frame: CGRect ,title: String ){
        
        self.init(frame: frame)
        self.title = title
        self.titleLabel.text = title
        
        // 添加手势
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        if frame.width > (GlobalValue.SCREENBOUND.width / 3.0){
            self.selectedBGImageName = "artist_field_select_btnBG_selected"
            self.unSelectedBGImageName = "artist_field_select_btnBG"
        }else{
            self.selectedBGImageName = "short_artist_field_select_btnBG_selected"
            self.unSelectedBGImageName = "short_artist_field_select_btnBG"
        }
        
    }
    
    func tapAction(){
        self.isSelected = !self.isSelected
    }
    


}



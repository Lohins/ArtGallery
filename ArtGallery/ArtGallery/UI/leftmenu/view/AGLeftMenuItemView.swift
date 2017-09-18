//
//  AGLeftMenuItemView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-29.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGLeftMenuItemView: UIView {
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
        let nib = UINib(nibName: "AGLeftMenuItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // ----- 
    
    var actionBlk: (() -> Void)?
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    convenience init( width: CGFloat,title: String , iconName: String){
        self.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 38))
        
        self.iconImageView.image = UIImage.init(named: iconName)
        self.titleLabel.text = title
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func tapAction(){
        print("Item is selected.")
        
        if self.actionBlk != nil{
            self.actionBlk!()
        }
        
    }

}

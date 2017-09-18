//
//  AGArtistWorkLinkEditView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistWorkLinkEditView: UIView {

    var view: UIView!
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
        self.editable = false
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib()-> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AGArtistWorkLinkEditView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // -------
    
    @IBOutlet weak var linkTextfiled: UITextField!
    
    var editable: Bool = false{
        didSet{
            if self.editable == true{
                let darkColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1).cgColor
                linkTextfiled.layer.borderColor = darkColor
                linkTextfiled.isUserInteractionEnabled = false
            }
            else{
                linkTextfiled.layer.borderWidth = 1
                linkTextfiled.layer.borderColor = UIColor.clear.cgColor
                linkTextfiled.isUserInteractionEnabled = true

            }
        }
    }
    
    func updateData(artwork: AGArtwork){
        self.linkTextfiled.text = artwork.videoLink
    }
    
    func getLink() -> String{
        if let link = self.linkTextfiled.text{
            return link
        }
        
        return ""
    }
    

}

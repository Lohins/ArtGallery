//
//  AGArtistProfileInfoItemView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-10.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistProfileInfoItemView: UIView {

    var view: UIView!
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
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
        let nib = UINib(nibName: "AGArtistProfileInfoItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // -----
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    convenience init(frame: CGRect, title: String, content : String){
        self.init(frame: frame)
        
        self.titleLabel.text = title
        if content == ""{
            self.contentLabel.text = "Not Yet"
        }
        else{
            self.contentLabel.text = content
        }
    }

}

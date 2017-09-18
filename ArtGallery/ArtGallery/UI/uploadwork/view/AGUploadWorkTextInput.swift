//
//  AGUploadWorkTextInput.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGUploadWorkTextInput: UIView {

    var view: UIView!
    
    var block: (() -> String)?
    
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
        let nib = UINib(nibName: "AGUploadWorkTextInput", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // ---------------
    @IBOutlet weak var textinput: UITextView!
    
    convenience init(frame: CGRect , title: String) {
        self.init(frame: frame)
    }
    
    func updateData(content: String){
        self.textinput.text = content
    }
    
    func getInfo() -> String?{
        return self.textinput.text
    }
    

}

//
//  AGArtistWorkInfoEditView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-30.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistWorkInfoEditView: UIView {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: UITextField!
    
    @IBOutlet weak var descriptionTextfield: UITextView!
    @IBOutlet weak var tagsTextfield: UITextField!

    var view: UIView!
    
    var editable: Bool = false{
        didSet{
            if editable == false{
//                nameTextfield.borderStyle = .none
                nameTextfield.layer.borderWidth = 1
                nameTextfield.layer.borderColor = UIColor.clear.cgColor
//                categoryTextfield.borderStyle = .none
                categoryTextfield.layer.borderWidth = 1
                categoryTextfield.layer.borderColor = UIColor.clear.cgColor
                descriptionTextfield.layer.borderColor = UIColor.clear.cgColor
//                tagsTextfield.borderStyle = .none
                tagsTextfield.layer.borderWidth = 1
                tagsTextfield.layer.borderColor = UIColor.clear.cgColor
                
                nameTextfield.isUserInteractionEnabled = false
                categoryTextfield.isUserInteractionEnabled = false
                descriptionTextfield.isUserInteractionEnabled = false
                tagsTextfield.isUserInteractionEnabled = false

                setNeedsLayout()
                
            }
            else{
//                nameTextfield.borderStyle = .line
//                categoryTextfield.borderStyle = .line
//                tagsTextfield.borderStyle = .line
                let darkColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1).cgColor
                nameTextfield.layer.borderColor = darkColor
                categoryTextfield.layer.borderColor = darkColor
                tagsTextfield.layer.borderColor = darkColor

                descriptionTextfield.layer.borderWidth = 1
                descriptionTextfield.layer.borderColor = UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1).cgColor
                
                nameTextfield.isUserInteractionEnabled = true
                categoryTextfield.isUserInteractionEnabled = true
                descriptionTextfield.isUserInteractionEnabled = true
                tagsTextfield.isUserInteractionEnabled = true
            }
        }
    }
    
    // override initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
        self.editable = false
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
        let nib = UINib(nibName: "AGArtistWorkInfoEditView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // 更新 UI
    func updateData(artwork: AGArtwork){
        self.nameTextfield.text = artwork.caption
        let subject = artwork.subjectList[0]
        self.categoryTextfield.text = subject.subjectName
        self.descriptionTextfield.text = artwork.desc
        self.tagsTextfield.text = artwork.getTags()
    }
    
    func disableEditing(){
        self.editable = false
    }

}

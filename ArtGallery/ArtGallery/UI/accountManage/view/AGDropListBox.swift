//
//  AGDropListBox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGDropListBox: UIView {

    // default to load xib file
    
    var view: UIView!
    
    @IBOutlet weak var bgImageView: UIImageView!
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
        let nib = UINib(nibName: "AGDropListBox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // ------------------
    
    @IBOutlet weak var textLabel: UILabel!
    
    var list: [AGRegion] = [AGRegion]()
    
    var selectedRegion: AGRegion?
    
    convenience init(frame: CGRect ,bgImgName: String , text: String){
        self.init(frame: frame)
        
        self.textLabel.font = GlobalValue.StandardFontForText
        self.textLabel.textColor = UIColor.white
        self.textLabel.text = text
        
        self.bgImageView.image = UIImage.init(named: bgImgName)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func updateData(list : [AGRegion]){
        self.list = list
    }
    
    func getInfo() -> Int?{
        if selectedRegion != nil{
            return self.selectedRegion!.id
        }
        else{
            return nil
        }
    }
    
    func tapAction(){
        if let vc = self.getCurrentViewController(){
            let alertVC = UIAlertController.init(title: "Ecomarte", message: "Please select one", preferredStyle: .actionSheet)
            for region in self.list{
                let alertAction = UIAlertAction.init(title: region.name, style: .default, handler: { (action) in
                    self.textLabel.text = region.name!
                    self.selectedRegion = region
                })
                alertVC.addAction(alertAction)
            }
            let alertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(alertAction)
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

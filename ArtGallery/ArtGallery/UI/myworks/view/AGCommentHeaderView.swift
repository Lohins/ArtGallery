//
//  AGCommentHeaderView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-25.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGCommentHeaderView: UIView {

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
        let nib = UINib(nibName: "AGCommentHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // ----------------
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var tapBlock: (() -> Void)!

    
    @IBAction func tapAction(_ sender: AnyObject) {
        
        if let blk = self.tapBlock{
            blk()
        }
    }
    
    func updateTitle(with num: Int){
        self.titleLabel.text = "Comment(\(num))"
    }
    
}

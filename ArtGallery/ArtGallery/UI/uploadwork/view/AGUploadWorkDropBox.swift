//
//  AGUploadWorkDropBox.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGUploadWorkDropBox: UIView {
    
    var artworktag: AGTag?
    
    var artworksubject: AGSubject?

    var view: UIView!
    
    var block: (() -> Void)?
    
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
        let nib = UINib(nibName: "AGUploadWorkDropBox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    // --------
    @IBOutlet weak var contentLabel: UILabel!

    
    convenience init(frame: CGRect , title: String) {
        self.init(frame: frame)
        
        setupUI(title: title)
    }
    
    func setupUI(title: String){
        self.contentLabel.text = title
    }
    
    @IBAction func tapAction(_ sender: AnyObject) {
        if let blk = self.block{
            blk()
        }
        
    }
    
    func updateData(content: String){
        self.contentLabel.text = content
    }
    
    func updateData(tag: AGTag){
        self.artworktag = tag
        self.contentLabel.text = tag.tagName
    }
    
    func updateData(subject: AGSubject){
        self.artworksubject = subject
        self.contentLabel.text = subject.subjectName
    }
    
    func getInfo() -> String?{
        return self.contentLabel.text
    }
    
    func getTagid() -> Int?{
        return self.artworktag?.tagId
    }
    
    func getSubjectid() -> Int?{
        return self.artworksubject?.subjectId
    }

}

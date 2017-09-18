//
//  AGTableEmptyFooter.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-12.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGTableEmptyFooter: UIView {
    
    var label: UILabel!

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
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.font = UIFont.init(name: "OpenSans-Bold", size: 15)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = "No data for displaying."
        self.addSubview(label)
    }
    
    convenience init(frame: CGRect ,title: String){
        self.init(frame: frame)
        label.text = title
    }

}

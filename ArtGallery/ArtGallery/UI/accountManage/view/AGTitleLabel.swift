//
//  AGTitleLabel.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGTitleLabel: UILabel {

    init(title: String) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 20))
        
        self.setupAttr()
        
        self.text = title
    }
    
    func setupAttr(){
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.font = UIFont.init(name: "OpenSans-Bold", size: CGFloat(13))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

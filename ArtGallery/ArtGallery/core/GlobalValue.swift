//
//  GlobalValue.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

struct GlobalValue {
    
    static let APPNAME = "ArtGallery"
    
    static let BASEURL = "https://74.207.249.142/api/"
//    static let BASEURL = "http://192.168.0.3:8000/api/"
//    static let BASEURL = "https://47.93.86.32/api/"
    static let SCREENBOUND = UIScreen.main.bounds
    static let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    static let NVBAR_HEIGHT = CGFloat(44)
    
    static let StandardFontForText = UIFont.init(name: "OpenSans", size: CGFloat(13))
    static let StandardFontForTitle = UIFont.init(name: "OpenSans-Bold", size: CGFloat(13))

}

let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.size.height
let NVBAR_HEIGHT = CGFloat(44)

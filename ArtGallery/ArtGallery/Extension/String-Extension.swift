//
//  String-Extension.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import Foundation


extension String{
    
    func isValidEmail() -> Bool{
        
        let pattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        
        let regex = try! NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let numofmatch = regex.numberOfMatches(in: self, options: .init(rawValue: 0), range: NSRange.init(location: 0, length: self.characters.count))
        
        if numofmatch == 0 {
            return false
        }
        return true
    }
    
    static func MD5_Encryption(rawStr: String) -> String{
        let utf8String = rawStr.cString(using: String.Encoding.utf8)
        
        let strLen = CUnsignedInt(rawStr.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(utf8String!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen{
            hash.appendFormat("%02x", result[i])
        }
        
        print(result)
        return hash as String
    }
    
    
    
    static func localizedString(_ key: String) -> String {
        let lanType = ArtGalleryAppCenter.sharedInstance.languageVersion
        let path = Bundle.main.path(forResource: lanType, ofType: "lproj")
        let string = Bundle.init(path: path!)?.localizedString(forKey: key, value: "", table: "MultiLanguageLocalized")

        return string!
    }
    
    /*
     描述： 获取给定字号字体下 string所占有的size
     */
    static func getBound(_ string: String,size:CGSize , options: NSStringDrawingOptions , attributes: [String : AnyObject]?, context: NSStringDrawingContext?) -> CGRect {
        let text: NSString = NSString(cString: string.cString(using: String.Encoding.utf8)! , encoding:String.Encoding.utf8.rawValue)!
        
        let bound = text.boundingRect(with: size , options: options, attributes: attributes, context: context)
        
        return bound
    }
}

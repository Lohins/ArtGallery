//
//  AGGetRegion.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-16.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGGetRegion: NSObject {
    
    func getRegionList( finish:@escaping ( _ list: [AGRegion]? ,_ error: Error?) -> Void){
        let url = GlobalValue.BASEURL + "user/registry/region/get"
        
        AGBaseNetworkService.sharedInstance.getWithoutCache(url, params: nil) { (result, error) in
            if error != nil || result == nil {
                finish(nil , error)
                return
            }
            
            // 解析data
            var regionList = [AGRegion]()
            if let list = result?["data"] as? [Dictionary<String , AnyObject>]{
                for element in list{
                    let region = AGRegion.init(data: element)
                    regionList.append(region)
                }
            }
            
            finish(regionList , nil)
            
        }
    }

    
    
}

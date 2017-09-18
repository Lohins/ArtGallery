//
//  ArtGalleryNetwork.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import AFNetworking


typealias FeedbackBlock = (_ result: Dictionary<String, AnyObject>?, _ error: Error?) -> Void

class ArtGalleryNetwork: NSObject {
    static let sharedInstance: ArtGalleryNetwork = ArtGalleryNetwork()
    
    var sessionManager: AFHTTPSessionManager
    
    override init(){
        
        let cerPath = Bundle.main.path(forResource: "artgallery", ofType: "cer")
        let url = URL.init(fileURLWithPath: cerPath!)
        let cerData = try! Data.init(contentsOf: url)
        
        let securityPolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.certificate)
        securityPolicy.pinnedCertificates = [cerData]
        
        self.sessionManager = AFHTTPSessionManager()
        self.sessionManager.securityPolicy = securityPolicy
        self.sessionManager.requestSerializer = AFJSONRequestSerializer.init(writingOptions: JSONSerialization.WritingOptions.init(rawValue: 0))
        self.sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        self.sessionManager.requestSerializer.timeoutInterval = 7
        self.sessionManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json", "text/json", "text/javascript","text/html") as? Set<String>
    }
    
    func getWithoutCache(_ urlString: String, params: Dictionary<String, AnyObject> , completion: @escaping FeedbackBlock){
        self.sessionManager.get(urlString, parameters: params, progress: { (progress: Progress) -> Void in
            }, success: { (task, result) in
                if let jsonResult = result as? Dictionary<String, AnyObject> {
                    completion(jsonResult,nil)
                    return
                }
                completion(nil,nil)
                return
            }) { (task, error) in
                completion(nil, error)
        }
    }
    
    func postWithoutCache(_ urlString: String, params: Dictionary<String, AnyObject> , completion: @escaping FeedbackBlock){
        self.sessionManager.post(urlString, parameters: params, progress: { (progress: Progress) -> Void in
            }, success: { (task, result) in
                if let jsonResult = result as? Dictionary<String, AnyObject> {
                    completion(jsonResult,nil)
                    return
                }
                completion(nil,nil)
                return
        }) { (task, error) in
            completion(nil, error)
        }
    }
    
}

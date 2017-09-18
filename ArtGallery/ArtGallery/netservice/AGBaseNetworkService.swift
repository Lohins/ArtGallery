//
//  AGBaseNetworkService.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-11.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import AFNetworking
import Foundation

typealias finishBlock = (_ result: Dictionary<String , AnyObject>? , _ error: Error?) -> Void

class AGBaseNetworkService: NSObject {
    
    static let sharedInstance:AGBaseNetworkService = AGBaseNetworkService()
    
    var sessionManager: AFHTTPSessionManager!
    
    override init(){
        super.init()
        
        self.initManager()
    }
    
    func initManager(){

        
        self.sessionManager = AFHTTPSessionManager()
        if let securityPolicy = initSecurityPolicy(){
            self.sessionManager.securityPolicy = securityPolicy
        }

        self.sessionManager.requestSerializer = AFJSONRequestSerializer.init(writingOptions: .init(rawValue: 0))
        self.sessionManager.requestSerializer.timeoutInterval = 8
        self.sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        self.sessionManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json" , "text/json" , "text/javascript" , "text/html") as? Set<String>
    }
    
//    let cerPath = Bundle.main.path(forResource: "artgallery", ofType: "cer")
//    let url = URL.init(fileURLWithPath: cerPath!)
//    let cerData = try! Data.init(contentsOf: url)
//    
//    let securityPolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.certificate)
//    securityPolicy.pinnedCertificates = [cerData]
//    securityPolicy.allowInvalidCertificates = true
//    securityPolicy.validatesDomainName = false
    func initSecurityPolicy() -> AFSecurityPolicy?{
        guard let cerPath = Bundle.main.path(forResource: "artgallery", ofType: "cer") else{
            return nil
        }
        
        let url = URL.init(fileURLWithPath: cerPath)
        do{
            var cerData: Data? = try Data.init(contentsOf: url)
            let securityPolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.certificate)
            securityPolicy.pinnedCertificates = [cerData!]
            securityPolicy.allowInvalidCertificates = true
            securityPolicy.validatesDomainName = false
            
            cerData = nil
            
            return securityPolicy
        }catch{
            return nil
        }
    }
    
    // Get Method without cache
    func getWithoutCache(_ url: String , params: Dictionary<String , AnyObject>? , finishBlk:@escaping finishBlock){
        self.sessionManager.get(url, parameters: params, progress: { (progress: Progress) -> Void in
            }, success: { (task, result) -> Void in
                if let jsonDict = result as? Dictionary<String , AnyObject>{
                    finishBlk( jsonDict , nil )
                }
                else{
                    let error = NSError.init(domain: "Data Missing", code: 20, userInfo: nil)
                    finishBlk(nil, error)
                }
            }, failure: { (task , error) -> Void in
                finishBlk(nil , error)
        })
    }
    
    
    // Post Method without cache
    func postWithoutCache(_ url: String , params: Dictionary<String , AnyObject>? , finishBlk:@escaping finishBlock){
        self.sessionManager.post(url, parameters: params, progress: { (progress: Progress) -> Void in
            }, success: { (task, result) -> Void in
                if let jsonDict = result as? Dictionary<String , AnyObject>{
                    finishBlk( jsonDict , nil )
                }
                else{
                    let error = NSError.init(domain: "Data Missing", code: 20, userInfo: nil)
                    finishBlk(nil, error)
                }
            }, failure: { (task , error) -> Void in
                finishBlk(nil , error)
        })
    }
}

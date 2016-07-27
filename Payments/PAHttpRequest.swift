//
//  PAHttpRequest.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import AFNetworking

class PAHttpRequest: NSObject {
    static let defaultDomain = "https://paymentsapp.herokuapp.com"
    //static let defaultDomain = "http://fahim.mac:3031"
    
    private static let sharedManager : AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string : defaultDomain)!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        return manager
    }()
    
    typealias PAJSONCompletion = (success : Bool, json : [String : AnyObject]) -> ()
    typealias PADataCompletion = (success : Bool, data : NSData?) -> ()
    typealias PAImageCompletion = (success : Bool, image : UIImage?) -> ()
    
    class func addAuthorizationHeader(token: String?) {
        sharedManager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
    }
    
    class func dispatchPostRequest(url : String, params : [String : AnyObject], completion: PAJSONCompletion) {
        PAHttpRequest.sharedManager.POST(completeURL(url), parameters: params, progress: nil,
                                         success: { (task, response) in
                                            if let response = response as? [String : AnyObject] {
                                                completion(success: true, json: response)
                                            }
                                            else {
                                                completion(success: false, json: [:])
                                            }
                                         },
                                         failure: { (task, error) in
                                            completion(success: false, json: [:])
                                         }
        )
    }
    
    class func dispatchGetRequest(url : String, params : [String : AnyObject], completion: PAJSONCompletion) {
        PAHttpRequest.sharedManager.GET(completeURL(url), parameters: params, progress: nil,
                                         success: { (task, response) in
                                            if let response = response as? [String : AnyObject] {
                                                completion(success: true, json: response)
                                            }
                                            else {
                                                completion(success: false, json: [:])
                                            }
                                         },
                                         failure: { (task, error) in
                                            completion(success: false, json: [:])
                                         }
        )
    }
    
    class func completeURL(url : String) -> String {
        return "\(defaultDomain)/\(url)"
    }
}

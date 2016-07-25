//
//  PAHttpRequest.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAHttpRequest: NSObject {
    static let defaultDomain = "http://fahim.mac:3031"
    
    typealias PAJSONCompletion = (success : Bool, json : [String : AnyObject]) -> ()
    typealias PADataCompletion = (success : Bool, data : NSData?) -> ()
    typealias PAImageCompletion = (success : Bool, image : UIImage?) -> ()
    
    class func postJSON(url : String, params : [String : AnyObject], completion: PAJSONCompletion) {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string : defaultDomain)!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.POST(url, parameters: params, progress: nil, success: { (task, response) in
            if let response = response as? [String : AnyObject] {
                completion(success: true, json: response)
            }
            else {
                completion(success: false, json: [:])
            }
            }) { (task, error) in
                print("error is: \(error)")
        }
    }
    
    class func fetchJSON(url : String, completion : PAJSONCompletion) {
        fetchData("\(defaultDomain)/\(url)") { (success, data) in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                    completion(success: true, json: json)
                }
                else {
                    completion(success: false, json: [:])
                }
            }
            catch {
                completion(success: false, json: [:])
            }
        }
    }
    
    class func fetchImage(url : String, completion: PAImageCompletion) {
        fetchData(url) { (success, data) in
            guard let data = data else {
                completion(success: false, image: nil)
                
                return
            }
            
            completion(success :true, image : UIImage(data: data))
        }
    }
    
    class func fetchData(url : String, completion : PADataCompletion) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
        
        dataRequest(request, completion: completion)
    }
    
    class func dataRequest(request : NSMutableURLRequest, completion : PADataCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respone, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                completion(success: true, data: data)
            })
        }
        
        task.resume()
    }

}

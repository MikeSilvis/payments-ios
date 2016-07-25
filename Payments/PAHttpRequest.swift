//
//  PAHttpRequest.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAHttpRequest: NSObject {
    typealias PAJSONCompletion = (success : Bool, json : [String : AnyObject]) -> ()
    typealias PADataCompletion = (success : Bool, data : NSData?) -> ()
    typealias PAImageCompletion = (success : Bool, image : UIImage?) -> ()
    
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
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respone, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                completion(success: true, data: data)
            })
        }
        
        task.resume()
    }

}

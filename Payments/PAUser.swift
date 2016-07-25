//
//  PAUserModel.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAUser: NSObject {
    
    static let currentUser = PAUser()
    
    typealias PAEventCompletion = (success : Bool, events : [PAEvent]) -> ()
    
    func findEvents(completion: PAEventCompletion) {
        let request = NSMutableURLRequest(URL: NSURL(string:"http://fahim.mac:3031/events/history")!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (response, something, error) in
            print("response is: \(response)")
        }
        
        task.resume()
    }

}

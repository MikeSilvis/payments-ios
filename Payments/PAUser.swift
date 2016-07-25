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
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respone, error) in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                
                var allEvents : [PAEvent] = []
                
                if let events = json?.objectForKey("events") as? [[String : AnyObject]] {
                    for event in events {
                        let paEvent = PAEvent(description: event["description"] as! String, amount: event["amount"] as! NSNumber, avatars: event["avatars"] as! [String], state: .Sent)
                        allEvents.append(paEvent)
                    }
                }
                
                completion(success: true, events: allEvents)
            }
            catch {
                completion(success: false, events: [])
            }
        }
        
        task.resume()
    }
    
}

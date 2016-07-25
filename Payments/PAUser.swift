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
        PAHttpRequest.fetchJSON("events/history") { (success, json) in
            var allEvents : [PAEvent] = []
                
            if let events = json["events"] as? [[String : AnyObject]] {
                for event in events {
                    let paEvent = PAEvent(description: event["description"] as! String,
                                               amount: event["amount"] as! NSNumber,
                                              avatars: event["avatars"] as! [String],
                                                state: .Sent
                    )
                    
                    allEvents.append(paEvent)
                }
            }
            
            completion(success: true, events: allEvents)
        }
    }
    
}

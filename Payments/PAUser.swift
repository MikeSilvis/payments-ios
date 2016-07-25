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
    
    typealias PAEventGetCompletion = (success : Bool, events : [PAEvent]) -> ()
    typealias PAEventCreateCompletion = (success : Bool) -> ()
    
    func findEvents(completion: PAEventGetCompletion) {
        PAHttpRequest.dispatchGetRequest("events/history", params: [:]) { (success, json) in
            var allEvents : [PAEvent] = []
                
            if let events = json["events"] as? [[String : AnyObject]] {
                for event in events {
                    let paEvent = PAEvent(description: event["description"] as! String,
                                               amount_cents: event["amount_cents"] as! NSNumber,
                                              avatars: event["avatars"] as! [String],
                                                state: .Sent
                    )
                    
                    allEvents.append(paEvent)
                }
            }
            
            completion(success: success, events: allEvents)
        }
    }
    
    func createEvent(event : PAEvent, completion : PAEventCreateCompletion) {
        PAHttpRequest.dispatchPostRequest("events", params: event.asJSON()) { (success, json) in
            print("Json response is: \(json)")
            
        }
    }
    
}

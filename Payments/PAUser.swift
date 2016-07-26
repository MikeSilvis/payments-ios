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
    
    
    //
    // MARK: Defaults
    //
    
    private static let kUserDefaultAccessToken : String = "kUserDefaultAccessToken"
    
    //
    // MARK : Alias
    //
    
    typealias PAEventGetCompletion = (success : Bool, pendingEvents : [PAEvent], pastEvents: [PAEvent]) -> ()
    typealias PAEventCreateCompletion = (success : Bool) -> ()
    typealias PACreateUserCompletion = (success : Bool) -> ()
    
    lazy var isLoggedIn : Bool = {
        return self.accessToken != nil
    }()

    var accessToken : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultAccessToken) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultAccessToken)
            
            isLoggedIn = accessToken != nil
        }
    }
    
    //
    // MARK : Requests
    //
    
    func authenticateWithFacebook(facebookID : String, accessToken: String, completion : PACreateUserCompletion) {
        PAHttpRequest.dispatchPostRequest("users", params: ["facebook_id" : facebookID, "facebook_access_token" : accessToken]) { [weak self] (success, json) in
            if let userJSON = json["user"] as? [String : AnyObject], let token = userJSON["access_token"] as? String where success {
                self?.accessToken = token
            }
            
            completion(success: success)
        }
    }
    
    func findEvents(completion: PAEventGetCompletion) {
        PAHttpRequest.dispatchGetRequest("events/history", params: [:]) { (success, json) in
            var pastEvents : [PAEvent] = []
            var pendingEvents : [PAEvent] = []
                
            if let events = json["events"] as? [[String : AnyObject]] {
                for event in events {
                    let paEvent = PAEvent(description: event["description"] as! String,
                                               amount_cents: event["amount_cents"] as! NSNumber,
                                              avatars: event["avatars"] as! [String],
                                                state: .Sent
                    )
                    
                    pastEvents.append(paEvent)
                    pendingEvents.append(paEvent)
                }
            }
            
            completion(success: success, pendingEvents: pendingEvents, pastEvents: pastEvents)
        }
    }
    
    func createEvent(event : PAEvent, completion : PAEventCreateCompletion) {
        PAHttpRequest.dispatchPostRequest("events", params: event.asJSON()) { (success, json) in
            print("Json response is: \(json)")
            
        }
    }
    
}

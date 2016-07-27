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
    
    override init() {
        super.init()
        
        PAHttpRequest.addAuthorizationHeader(accessToken)
    }
    
    //
    // MARK: Defaults
    //
    
    private static let kUserDefaultAccessToken : String = "kUserDefaultAccessToken"
    private static let kUserDefaultUserEmail   : String = "kUserDefaultUserEmail"
    
    //
    // MARK : Alias
    //
    
    typealias PAEventGetCompletion = (success : Bool, pendingEvents : [PAEvent], pastEvents: [PAEvent]) -> ()
    typealias PACreateUserCompletion = (success : Bool) -> ()
    
    lazy var isLoggedIn : Bool = {
        return self.accessToken != nil
    }()

    var accessToken : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultAccessToken) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultAccessToken)
            
            isLoggedIn = accessToken != nil
            
            PAHttpRequest.addAuthorizationHeader(accessToken)
        }
    }
    
    var email : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultUserEmail) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultUserEmail)
        }
    }
    
    //
    // MARK : Requests
    //
    
    func authenticateWithFacebook(facebookID : String, accessToken: String, completion : PACreateUserCompletion) {
        PAHttpRequest.dispatchPostRequest("users", params: ["facebook_id" : facebookID, "facebook_access_token" : accessToken]) { [weak self] (success, json) in
            guard let userJSON = json["user"] as? [String : AnyObject] else {
                completion(success: false)
                return
            }
            
            guard success else {
                completion(success: false)
                return
            }
            
            if let token = userJSON["access_token"] as? String {
                self?.accessToken = token
            }
            
            if let email = userJSON["email"] as? String {
                self?.email = email
            }
            
            completion(success: success)
        }
    }
    
    func findEvents(completion: PAEventGetCompletion) {
        func createEventFromResponse(json : [String : AnyObject]) -> PAEvent {
            return PAEvent(objectID: json["id"] as! NSNumber, amount_cents: json["amount_cents"] as! NSNumber, avatars: json["avatars"] as! [String], photo: json["photo"] as? String)
        }
        
        PAHttpRequest.dispatchGetRequest("events", params: [:]) { (success, json) in
            var historyEvents : [PAEvent] = []
            var nearbyEvents : [PAEvent] = []
                
            if let events = json["history"] as? [[String : AnyObject]] {
                for event in events {
                    historyEvents.append(createEventFromResponse(event))
                }
            }
            
            if let events = json["nearby"] as? [[String : AnyObject]] {
                for event in events {
                    nearbyEvents.append(createEventFromResponse(event))
                }
            }

            completion(success: success, pendingEvents: nearbyEvents, pastEvents: historyEvents)
        }
    }
    
}

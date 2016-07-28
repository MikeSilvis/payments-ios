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
    
    private static let kUserDefaultAccessToken      : String = "kUserDefaultAccessToken"
    private static let kUserDefaultEmailAddress     : String = "kUserDefaultEmailAddress"
    private static let kUserDefaultBalanceCents     : String = "kUserDefaultBalanceCents"
    private static let kUserDefaultPhotoURL         : String = "kUserDefaultPhotoURL"
    
    //
    // MARK : Alias
    //
    
    typealias PAUserCompletion = (success : Bool) -> ()
    
    //
    // MARK: Properties
    //
    
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
    
    var email : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultEmailAddress) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultEmailAddress)
        }
    }
    
    var balance_cents : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultBalanceCents) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultBalanceCents)
        }
    }
    
    var photoURL : String? = NSUserDefaults.standardUserDefaults().stringForKey(PAUser.kUserDefaultPhotoURL) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: PAUser.kUserDefaultPhotoURL)
        }
    }
    
    //
    // MARK : Requests
    //
    
    func refresh(completion: PAUserCompletion) {
        guard isLoggedIn else {
            completion(success: false)
            return
        }
        
        PAHttpRequest.dispatchGetRequest("users/get_current_user", params: [:]) { [ weak self] (success, json) in
            self?.parseJSONResponse(success, json: json, completion: completion)
        }
    }
    
    func authenticateWithFacebook(facebookID : String, accessToken: String, completion : PAUserCompletion) {
        PAHttpRequest.dispatchPostRequest("users", params: ["facebook_id" : facebookID, "facebook_access_token" : accessToken]) { [weak self] (success, json) in
            self?.parseJSONResponse(success, json: json, completion: completion)
        }
    }
    
    private func parseJSONResponse(success : Bool, json : [String : AnyObject], completion: PAUserCompletion) {
        guard let userJSON = json["user"] as? [String : AnyObject] else {
            completion(success: false)
            return
        }
        
        guard success else {
            completion(success: false)
            return
        }
        
        if let token = userJSON["access_token"] as? String {
            self.accessToken = token
        }
        
        if let email = userJSON["email"] as? String {
            self.email = email
        }
        
        if let balance_cents = userJSON["balance_cents"] as? String {
            self.balance_cents = balance_cents
        }
        
        completion(success: success)
    }
    
    
}

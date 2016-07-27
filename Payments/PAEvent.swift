//
//  PAEvent.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

enum PAEventState : Int {
    case Sent
    case Pending
    case Received
    
    func color() -> UIColor {
        switch self {
        case .Sent:
            return .redColor()
        case .Received:
            return .greenColor()
        case .Pending:
            return .clearColor()
        }
    }
}

struct PAFriend {
    var name           : String
    var profilePicture : NSURL
}

struct PAEvent {
    var objectID        : NSNumber
    var description     : String
    var amount_cents    : NSNumber
    var avatars         : [String]
    var state           : PAEventState = .Sent
    
    func dollarAmount() -> String {
        return "$\(amount_cents.floatValue / 100)"
    }
    
    func asJSON() -> [String : AnyObject] {
        return [
            "name"         : description,
            "amount_cents" : amount_cents
        ]
    }
    
    //
    // MARK : Alias
    //
    
    typealias PAEventPaymentCompletion = (success : Bool) -> ()
    
    //
    // MARK : Requests
    //
    
    func makePayment(completion: PAEventPaymentCompletion) {
        PAHttpRequest.dispatchPostRequest("events/\(objectID)/make_payment", params: [:]) { (success, json) in
            print(json)
            completion(success: success)
        }
    }
}

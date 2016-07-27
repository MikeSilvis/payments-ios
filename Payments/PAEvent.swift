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
    var objectID        : NSNumber?
    var description     : String?
    var amount_cents    : NSNumber
    var avatars         : [String]?
    var state           : PAEventState = .Sent
    var photo           : UIImage?
    var photoURL        : NSURL?
    
    func dollarAmount() -> String {
        return "$\(amount_cents.floatValue / 100)"
    }
    
    // TODO: Remove nill properties
    func asJSON() -> [String : AnyObject] {
        return [
            "event" : [
                "name"         : description!,
                "amount_cents" : amount_cents,
            ]
        ]
    }
    
    //
    // MARK: Custom Inits
    //
    
    init(photo: UIImage, amount_cents: NSNumber) {
        self.photo = photo
        self.amount_cents = amount_cents
        self.description = "heyo"
    }
    
    init(objectID: NSNumber, amount_cents : NSNumber, avatars : [String], photo: String?) {
        self.objectID = objectID
        self.amount_cents = amount_cents
        self.avatars = avatars
        
        if let photo = photo {
            self.photoURL = NSURL(string: photo)
        }
    }
    
    //
    // MARK : Alias
    //
    
    typealias PAEventPaymentCompletion = (success : Bool) -> ()
    typealias PAEventCreateCompletion = (success : Bool) -> ()
    
    //
    // MARK : Requests
    //
    
    func makePayment(completion: PAEventPaymentCompletion) {
        PAHttpRequest.dispatchPostRequest("events/\(objectID)/make_payment", params: [:]) { (success, json) in
            completion(success: success)
        }
    }
    
    func create(completion : PAEventCreateCompletion) {
        let file = UIImageJPEGRepresentation(photo!, 0.3)
        
        PAHttpRequest.dispatchMultipartRequest("events", file: file!, params: asJSON()) { (success, json) in
            completion(success: success)
        }
    }
    
}

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
    var name           : String?
    var photoURL       : NSURL?
    
    init(json : [String : AnyObject]) {
        self.name = json["name"] as? String
        
        if let photoURL = json["avatar_image_url"] as? String {
            self.photoURL = NSURL(string: photoURL)
        }
    }
}

struct PAEvent {
    var objectID        : NSNumber?
    
    // TODO: Remove
    var description     : String?
    var amount_cents    : NSNumber
    var members         : [PAFriend]?
    var state           : PAEventState = .Sent
    var photo           : UIImage?
    var photoURL        : NSURL?
    var requester       : PAFriend?
    
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
    
    init(objectID: NSNumber, amount_cents : NSNumber, members : [PAFriend], photo: String?, requester: PAFriend?) {
        self.objectID = objectID
        self.amount_cents = amount_cents
        self.members = members
        self.requester = requester
        
        if let photo = photo {
            self.photoURL = NSURL(string: photo)
        }
    }
    
    //
    // MARK : Alias
    //
    
    typealias PAEventPaymentCompletion = (success : Bool) -> ()
    typealias PAEventCreateCompletion = (success : Bool) -> ()
    typealias PAEventGetCompletion = (success : Bool, pendingEvents : [PAEvent], pastEvents: [PAEvent]) -> ()
    
    //
    // MARK : Requests
    //
    
    func makePayment(completion: PAEventPaymentCompletion) {
        PAHttpRequest.dispatchPostRequest("events/\(objectID!)/make_payment", params: [:]) { (success, json) in
            completion(success: success)
        }
    }
    
    func create(completion : PAEventCreateCompletion) {
        let file = UIImageJPEGRepresentation(photo!, 0.3)
        
        PAHttpRequest.dispatchMultipartRequest("events", file: file!, params: asJSON()) { (success, json) in
            completion(success: success)
        }
    }
    
    static func findEvents(completion: PAEventGetCompletion) {
        func createEventFromResponse(json : [String : AnyObject]) -> PAEvent {
            let members = (json["members"] as! [[String : AnyObject]]).map({ PAFriend(json: $0) })
            
            return PAEvent(objectID: json["id"] as! NSNumber,
                           amount_cents: json["amount_cents"] as! NSNumber,
                           members: members,
                           photo: json["photo_url"] as? String,
                           requester: PAFriend(json: json["requestor"] as! [String : AnyObject])
            )
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

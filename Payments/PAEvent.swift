//
//  PAEvent.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import ObjectMapper

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
    
    init?(_ map: Map) {

    }
}

extension PAFriend : Mappable {
    mutating func mapping(map: Map) {
        name            <- map["name"]
        photoURL        <- (map["avatar_image_url"], URLTransform())
    }
}

struct PAEvent {
    var objectID        : NSNumber?
    var amount_cents    : NSNumber?
    var members         : [PAFriend]?
    var state           : PAEventState = .Sent
    var photo           : UIImage?
    var photoURL        : NSURL?
    var requester       : PAFriend?
    
    func dollarAmount() -> String {
        guard let cents = amount_cents else {
            return "$0"
        }
        
        return "$\(cents.floatValue / 100)"
    }
    
    // TODO: Remove nill properties
    func asJSON() -> [String : AnyObject] {
        return [
            "event" : [
                "amount_cents" : amount_cents!,
            ]
        ]
    }
    
    //
    // MARK: Custom Inits
    //
    
    init(photo: UIImage, amount_cents: NSNumber) {
        self.photo = photo
        self.amount_cents = amount_cents
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
    
    init?(_ map: Map) {

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
            return Mapper<PAEvent>().map(json)!
        }
        
        PAHttpRequest.dispatchGetRequest("events", params: [:]) { (success, json) in
            if let historyJSON = json["history"] as? [[String : AnyObject]], nearbyJSON = json["nearby"] as? [[String : AnyObject]] {
                let historyEvents = historyJSON.map({ Mapper<PAEvent>().map($0)! })
                let nearbyEvents = nearbyJSON.map({ Mapper<PAEvent>().map($0)! })
                
                completion(success: success, pendingEvents: nearbyEvents, pastEvents: historyEvents)
                return
            }
            
            completion(success: false, pendingEvents: [], pastEvents: [])
        }
    }
    
}

extension PAEvent : Mappable {
    mutating func mapping(map: Map) {
        objectID        <- map["id"]
        amount_cents    <- map["amount_cents"]
        members         <- map["members"]
        photoURL        <- (map["photo_url"], URLTransform())
        requester       <- map["requestor"]
    }
}

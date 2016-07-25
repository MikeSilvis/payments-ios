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
    case Received
    
    func color() -> UIColor {
        switch self {
        case .Sent:
            return .redColor()
        case .Received:
            return .greenColor()
        }
    }
}

struct PAFriend {
    var name           : String
    var profilePicture : NSURL
}

struct PAEvent {
    var description : String
    var amount      : NSNumber
    var avatars     : [String]
    var state       : PAEventState = .Sent
}

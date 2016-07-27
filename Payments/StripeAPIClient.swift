//
//  StripeAPIClient.swift
//  Payments
//
//  Created by Fahim Ferdous on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import Foundation
import Stripe

class StripeAPIClient: NSObject, STPBackendAPIAdapter {

    static let sharedClient = StripeAPIClient()
    let session: NSURLSession
    var baseURLString: String? = nil
    var customerID: String? = nil
    var defaultSource: STPCard? = nil
    var sources: [STPCard] = []

    override init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 5
        self.session = NSURLSession(configuration: configuration)
        super.init()
    }

    func completeCharge(result: STPPaymentResult, amount: Int, completion: STPErrorBlock) {
        let params: [String: AnyObject] = [
            "source": result.source.stripeID,
            "amount": amount,
        ]

        PAHttpRequest.dispatchPostRequest("charge", params: params) { (success, json) in
            print(json)
        }
    }

    @objc func retrieveCustomer(completion: STPCustomerCompletionBlock) {
        PAHttpRequest.dispatchGetRequest("users/current_customer", params: [:]) { (success, json) in
            let deserializer = STPCustomerDeserializer(JSONResponse: json)
            completion(deserializer.customer, deserializer.error)
        }
    }

    @objc func selectDefaultCustomerSource(source: STPSource, completion: STPErrorBlock) {
        let params = ["source": source.stripeID]

        PAHttpRequest.dispatchPostRequest("users/set_default_source_for_current_user", params: params) { (success, json) in
            print(json)
            completion(nil)
        }
    }

    @objc func attachSourceToCustomer(source: STPSource, completion: STPErrorBlock) {
        let params = ["source": source.stripeID]

        PAHttpRequest.dispatchPostRequest("users/attach_source_to_current_user", params: params) { (success, json) in
            print(json)
            completion(nil)
        }
    }

}
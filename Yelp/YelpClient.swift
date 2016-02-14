//
//  YelpClient.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/8/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import Foundation

import AFNetworking
import BDBOAuth1Manager

let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {

    var accessToken: String!
    var accessSecret: String!

    class var sharedInstance: YelpClient {
        struct Static {
            static var token: dispatch_once_t = 0
            static var instance: YelpClient? = nil
        }

        dispatch_once(&Static.token) {
            Static.instance = YelpClient(
                consumerKey: yelpConsumerKey,
                consumerSecret: yelpConsumerSecret,
                accessToken: yelpToken,
                accessSecret: yelpTokenSecret
            )
        }
        return Static.instance!
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(
        consumerKey key: String!,
        consumerSecret secret: String!,
        accessToken: String!,
        accessSecret: String!
    ) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);

        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    func search(
        term: String,
        offset: Int,
        completion: ([Business]!, NSError!) -> Void
    ) -> AFHTTPRequestOperation {

        // Default the location to San Francisco
        let parameters: [String: AnyObject] = [
            "term": term,
            "offset": offset,
            "ll": "37.785771,-122.406165"
        ]

        return self.GET(
            "search",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let dictionaries = response["businesses"] as? [NSDictionary] {
                    completion(Business.businesses(dictionaries: dictionaries), nil)
                }
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                completion(nil, error)
            }
        )!
    }

}

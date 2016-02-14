//
//  Business.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/8/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import Foundation

class Business: NSObject {

    let address: String
    let categories: String?
    let distance: String?
    let imageUrl: NSURL?
    let latitude: Double?
    let longitude: Double?
    let name: String?
    let ratingImageUrl: NSURL?
    let reviewCount: NSNumber?

    init(dictionary: NSDictionary) {
        var address = ""
        var latitude: Double? = nil
        var longitude: Double? = nil
        if let location = dictionary["location"] as? NSDictionary {
            let addresses = location["address"] as? NSArray
            if addresses != nil && addresses!.count > 0 {
                address = addresses![0] as! String
            }

            let neighborhoods = location["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }

            if let coordinate = location["coordinate"] as? NSDictionary {
                latitude = (coordinate["latitude"] as! Double)
                longitude = (coordinate["longitude"] as! Double)
            }
        }
        self.address = address
        self.latitude = latitude
        self.longitude = longitude

        let categories = dictionary["categories"] as? [[String]]
        self.categories = categories != nil
            ? categories!.map({category in category[0]}).joinWithSeparator(", ")
            : nil

        let distanceInMeters = dictionary["distance"] as? NSNumber
        let milesPerMeter = 0.000621371
        distance = distanceInMeters != nil
            ? String(format: "%.2f mi", milesPerMeter * distanceInMeters!.doubleValue)
            : nil

        let imageUrlString = dictionary["image_url"] as? String
        imageUrl = imageUrlString != nil ? NSURL(string: imageUrlString!) : nil

        let ratingImageUrlString = dictionary["rating_img_url_large"] as? String
        ratingImageUrl = ratingImageUrlString != nil
            ? NSURL(string: ratingImageUrlString!)
            : nil

        name = dictionary["name"] as? String
        reviewCount = dictionary["review_count"] as? NSNumber
    }

    class func businesses(dictionaries dictionaries: [NSDictionary]) -> [Business] {
        return dictionaries.map({dictionary in Business(dictionary: dictionary)})
    }

}

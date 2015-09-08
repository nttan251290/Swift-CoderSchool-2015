//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class Business: NSObject {
    var name: String?
    var address: String?
    var imageURL: NSURL?
    var categories: String?
    var distance: String?
    var ratingImageURL: NSURL?
    var reviewCount: NSNumber?
    var longitude: NSNumber?
    var latitude: NSNumber?
    
    static var lastResponse : NSDictionary? = nil
    
    var location: CLLocation {
        get {
            return CLLocation (latitude: latitude as! Double, longitude: longitude as! Double)
        }
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            if let snipURLString = dictionary["snippet_image_url"] as? String {
                imageURL = NSURL(string: snipURLString)!
            }
            else {
                imageURL = nil
            }
        }
        
        let ilocation = dictionary["location"] as? NSDictionary
        var addressS = ""
        if ilocation != nil {
            let addressArray = ilocation!["address"] as? NSArray
            var street: String? = ""
            if addressArray != nil && addressArray!.count > 0 {
                addressS = addressArray![0] as! String
            }
            
            var neighborhoods = ilocation!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !addressS.isEmpty {
                    addressS += ", "
                }
                addressS += neighborhoods![0] as! String
            }
        }
        address = addressS
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                var categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = ", ".join(categoryNames)
        } else {
            categories = nil
        }
        
        if let ilocation = dictionary["location"] as? NSDictionary {
            if let coordinate = ilocation["coordinate"] as? NSDictionary {
                latitude = coordinate["latitude"] as? NSNumber
                longitude = coordinate["longitude"] as? NSNumber
            } else {
                latitude = nil
                longitude = nil
            }
        } else {
            latitude = nil
            longitude = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            if longitude != nil && latitude != nil {
                distance = String(format: "%.2f mi", UserLocation.instance.location.distanceFromLocation(CLLocation(latitude: latitude as! Double, longitude: longitude as! Double)) / 1609.344)
            } else {
                distance = nil
            }
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
    }
    
    class func businesses(#array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            var business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    class func searchWithTerm(term: String, parameters: Dictionary<String, String>, offset: Int = 0, limit: Int = 20,  completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, parameters: parameters, offset: offset, limit: limit, completion: completion)
    }
    
}

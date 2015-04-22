//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func getString(categorys: [String]) -> String {
        var str = ""
        for (i, category) in enumerate(categorys) {
            str += "\(category)"
            if i < categorys.count-1 {
                str += ","
            }
        }
        return str
    }
    
    func searchWithTerm(term: String, radius: Int, categories:[String], sortBy: Int, offset: Int, limit: Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var categoriesString = getString(categories)
        NSLog(categoriesString)
        
        var parameters = ["term": term, "location": "San Francisco", "category_filter" : categoriesString, "sort": sortBy, "offset": offset, "limit": limit, "cll": "37.427474,-122.169719"] as NSMutableDictionary
        if (radius > 0) {
            parameters["radius_filter"] = radius
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}



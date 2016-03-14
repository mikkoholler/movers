//
//  HeiaHandler.swift
//  Movers
//
//  Created by Michael Holler on 14/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation

class HeiaHandler {

    var token:String?
    
    init() {
    }
    
    func login() {
    
        let secret = Secret()
        let params = "grant_type=password&username=\(secret.username)&password=\(secret.passwd)&client_id=\(secret.clientid)&client_secret=\(secret.secret)"
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        request.URL = NSURL(string: "https://api.heiaheia.com/oauth/token")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            do {
                if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.token = jsonObject["access_token"] as? String
                        self.getFeed()
                    }
                }
            } catch {
                print("Could not tokenize")
            }
        }
        task.resume()
    }

    func getFeed() {
        let request = NSMutableURLRequest()
        request.addValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "GET"
        request.URL = NSURL(string: "https://api.heiaheia.com/rest/v2/feeds")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            print(data)
            /*
            do {
                if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                    HeiaHandler.token = jsonObject["access_token"] as? String
                }
            } catch {
            }
            */
        }
        task.resume()
    }
    
}
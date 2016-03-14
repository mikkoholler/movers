//
//  HeiaHandler.swift
//  Movers
//
//  Created by Michael Holler on 14/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation

class HeiaHandler {
    
    init() {
    }
    
    func login(completion: (String) -> ()) {
        var token:String?
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
                        token = jsonObject["access_token"] as? String
                        completion(token!)
                    }
                }
            } catch {
                print("Could not tokenize")
            }
        }
        task.resume()
    }

    func getFeed(completion: ([FeedItem]) -> ()) {
        var feed = [FeedItem]()

        login() { (token) in
            let request = NSMutableURLRequest()
            let params = "direction=desc&per_page=20&access_token=\(token)"
            let components = NSURLComponents(string: "https://api.heiaheia.com/api/v2/feeds")
            components?.query = params
        
            request.HTTPMethod = "GET"
            request.URL = components?.URL
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? Array<[String:AnyObject]> {
                        feed = jsonObject.map { (var item) -> FeedItem in
                            var feeditem = FeedItem()
                            feeditem.id = item["id"] as! Int
                        
                            let isTrainingEntry = (item["kind"] as! String == "TrainingLog")
                            if (isTrainingEntry) {
                        
                                if let entry = item["entry"] as? [String:AnyObject] {
                                    if let date = entry["date"] as? String {
                                        feeditem.date = date
                                    }
                                    if let title = entry["title"] as? String {
                                        feeditem.title = title
                                    }
                                    if let desc = entry["description"] as? String {
                                        feeditem.desc = desc
                                    }
                                    if let mood = entry["mood"] as? Int {
                                        feeditem.mood = mood
                                    }
                                    if let user = entry["user"] as? [String:AnyObject] {
                                        if let name = user["first_name"] as? String {
                                            feeditem.user = name
                                        }
                                    }
                                    if let sport = entry["sport"] as? [String:AnyObject] {
                                        if let sportname = sport["name"] as? String {
                                            feeditem.sport = sportname
                                        }
                                    }
                                }
                            } else {
                                print("some other entry")
                            }
                            return feeditem
                        }
                    }
                } catch let e {
                    print(e)
                }

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(feed)
                }
            }
            task.resume()
        }
    }
    
}
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
                        feed = jsonObject
                            .filter { $0["kind"] as! String != "TextEntry" }
                            .map { (let item) -> FeedItem in
                                if (item["kind"] as! String == "Weight") {
                                    return self.parseWeight(item)
                                } else {
                                    return self.parse(item)
                                }
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
    
    func getLogs(completion: ([FeedItem]) -> ()) {
        var logs = [FeedItem]()

        login() { (token) in
            let request = NSMutableURLRequest()
            let params = "status=regular&year=2016&page=1&per_page=20&access_token=\(token)"
            let components = NSURLComponents(string: "https://api.heiaheia.com/v2/training_logs")
            components?.query = params
        
            request.HTTPMethod = "GET"
            request.URL = components?.URL
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? Array<[String:AnyObject]> {
                        logs = jsonObject
                            .map { (let item) -> FeedItem in
                                return self.parseLog(item)
                            }
                    }
                } catch let e {
                    print(e)
                }

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(logs)
                }
            }
            task.resume()
        }
    }

    func getRidingDays(completion: (Int) -> ()) {
        var days = Int()

        login() { (token) in
            
            let request = NSMutableURLRequest()
            let components = NSURLComponents(string: "https://api.heiaheia.com/v2/training_logs")
            var params = "page=1&per_page=100&year=2016&access_token=\(token)"
            components?.query = params
        
            request.HTTPMethod = "GET"
            request.URL = components?.URL
  
            self.fetchDays(request) { adddays in
                print("2016: \(adddays)")
                days += adddays
                print(days)

                if (!self.lastJulyWasThisYear()) {
                    params = "page=1&per_page=100&year=2015&access_token=\(token)"
                    components?.query = params
                    
                    request.HTTPMethod = "GET"
                    request.URL = components?.URL
                    
                    self.fetchDays(request) { adddays in
                        print("2015: \(adddays)")
                        days += adddays
                        print(days)
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            print("total: \(days)")
                            completion(days)
                        }
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        print("total: \(days)")
                        completion(days)
                    }
                }
            }
        }
    }
    
            
    func fetchDays(request:NSMutableURLRequest, completion: (Int) -> ()) {
        var days = Int()
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? Array<[String:AnyObject]> {
                        
                        days = jsonObject
                            .filter { (let item) -> Bool in

                                var delete = false
                                
                                if let sport = item["sport"] as? [String:AnyObject] {
                                    if let id = sport["id"] as? Int {
                                        if (id == 55) {
                                            delete = true
                                        }
                                    }
                                }
                                return delete
                                
                            }
                            .count
                    }
                } catch let e {
                    print(e)
                }

                NSOperationQueue.mainQueue().addOperationWithBlock {        // might not be needed
                    completion(days)
                }

            }
            task.resume()
        
    }

    func parse(item: [String:AnyObject]) -> FeedItem {
        var feeditem = FeedItem()
        if let id = item["id"] as? Int {
            feeditem.id = id
        }
        if let type = item["kind"] as? String {
            feeditem.type = type
        }
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
                if let firstname = user["first_name"] as? String {
                    if let lastname = user["last_name"] as? String {
                        feeditem.name = firstname + " " + lastname
                    }
                }
            }
            if let sport = entry["sport"] as? [String:AnyObject] {
                if let sportname = sport["name"] as? String {
                    feeditem.sport = sportname
                }
            }
        }
        if (feeditem.title == "") {
        }
        return feeditem
    }
    
    func parseWeight(item: [String:AnyObject]) -> FeedItem {
        var feeditem = FeedItem()
        if let id = item["id"] as? Int {
            feeditem.id = id
        }
        if let type = item["kind"] as? String {
            feeditem.type = type
        }
        if let entry = item["entry"] as? [String:AnyObject] {
            if let date = entry["date"] as? String {
                feeditem.date = date
            }
            if let value = entry["value"] as? Double {
                feeditem.weight = value
            }
            if let user = entry["user"] as? [String:AnyObject] {
                if let firstname = user["first_name"] as? String {
                    if let lastname = user["last_name"] as? String {
                        feeditem.name = firstname + " " + lastname
                    }
                }
            }
        }
        return feeditem
    }
    
    func parseLog(item: [String:AnyObject]) -> FeedItem {
        var feeditem = FeedItem()
        if let title = item["title"] as? String {
            feeditem.title = title
        }
        if let date = item["date"] as? String {
            feeditem.date = date
        }
        if let desc = item["description"] as? String {
            feeditem.desc = desc
        }
        if let mood = item["mood"] as? Int {
            feeditem.mood = mood
        }
        if let sport = item["sport"] as? [String:AnyObject] {
            if let sportname = sport["name"] as? String {
                feeditem.sport = sportname
            }
        }
        return feeditem
    }

    func saveWeight(date:NSDate, weight:Double) {
        login() { (token) in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datestr = dateFormatter.stringFromDate(date)
            let weightstr = String(format: "%.1f", weight)
            
            let params = "access_token=\(token)&date=\(datestr)&value=\(weightstr)&notes=&private=true"
            let request = NSMutableURLRequest()
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            request.URL = NSURL(string: "https://api.heiaheia.com/v2/weights")
            print(params)
 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                print(response)
            }
            task.resume()
        }
    }
    
    func lastJulyWasThisYear() -> Bool {
    
        var thisYear = true
    
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let julyComponents = NSDateComponents()
        julyComponents.month = 7
        
        if (todayComponents.month < julyComponents.month) {
            thisYear = false
        }
        
        return thisYear
    }

    func lastJuly() -> NSDate {
    
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let julyComponents = NSDateComponents()
        julyComponents.day = 1
        julyComponents.month = 7
        
        if (todayComponents.month < julyComponents.month) {
            julyComponents.year = todayComponents.year
        } else {
            julyComponents.year = todayComponents.year - 1
        }
        
        let lastJuly = calendar.dateFromComponents(julyComponents)
        
        return lastJuly!
    }

}
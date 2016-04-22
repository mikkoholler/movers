//
//  HeiaHandler.swift
//  Movers
//
//  Created by Michael Holler on 14/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation
import UIKit

class HeiaHandler {
    
    var userid = 28811619755    // this is mine
    
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
                // TODO: crashes with no internets
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
            let params = "direction=desc&per_page=100&access_token=\(token)"
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
    
    func getNotificationFeed(completion: ([FeedItem]) -> ()) {
        var feed = [FeedItem]()
        
        // replace with data from Heia
        var feeditem = FeedItem()
        feeditem.title = "Testies"
        feeditem.name = "Matti Meikkis"

        feed.append(feeditem)
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            completion(feed)
        }
    }

    func getRidingDays(completion: (Int) -> ()) {
        var days = 0  // böö

        login() { (token) in
        
            let year = self.thisYear()
            
            self.fetchDays(token, year: year) { adddays in
                days += adddays

                if (!self.lastJulyWasThisYear()) {
                    self.fetchDays(token, year: year-1, page: 1) { adddays in
                        days += adddays
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            completion(days)
                        }
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        completion(days)
                    }
                }
            }
        }
    }
    
            
    func fetchDays(token: String, year: Int, page: Int = 1, daysTotal: Int = 0, completion: (Int) -> ()) {
        var days = Int()
        var rows = Int()
        var lastdate = NSDate()
        
        let request = NSMutableURLRequest()
        let components = NSURLComponents(string: "https://api.heiaheia.com/v2/training_logs")
        let params = "page=\(page)&per_page=100&year=\(year)&access_token=\(token)"
        components?.query = params
        
        request.HTTPMethod = "GET"
        request.URL = components?.URL
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            do {
                if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Array<[String:AnyObject]> {
                    rows = jsonObject.count
                    days = jsonObject
                        .filter { (let item) -> Bool in
                            
                            var delete = false
                            if let date = item["date"] as? String {
                                lastdate = self.dateFromString(date)
                            }

                            if let sport = item["sport"] as? [String:AnyObject] {
                                if let id = sport["id"] as? Int {
                                    if (id == 55 && lastdate.compare(self.lastJuly()) == NSComparisonResult.OrderedDescending) {
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
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if (rows == 100 && lastdate.compare(self.lastJuly()) == NSComparisonResult.OrderedDescending) {
                    self.fetchDays(token, year: year, page: page+1, daysTotal: daysTotal + days, completion: completion)
                } else {
                    completion(daysTotal + days)
                }
            }
            
        }
        task.resume()
        
    }

    func parse(item:[String:AnyObject]) -> FeedItem {
        var feeditem = FeedItem()
        if let type = item["kind"] as? String {
            feeditem.type = type
        }
        if let entry = item["entry"] as? [String:AnyObject] {
            if let id = entry["id"] as? Int {
                feeditem.id = id
            }
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
            if let commentcount = entry["comments_count"] as? Int {
                feeditem.commentcount = commentcount
            }
            if let cheercount = entry["cheers_count"] as? Int {
                feeditem.cheercount = cheercount
            }
            
            if let cheers = entry["latest_cheers"] as? [[String:AnyObject]] {
                for (i, cheer) in cheers.enumerate() {
                    if let user = cheer["user"] as? [String:AnyObject] {
                        if let id = user["id"] as? Int {
                            if (userid == id) {
                                feeditem.hasCheered = true
                                if (cheers.count == 1) {
                                    feeditem.cheeredby = "You"
                                } else {
                                    feeditem.cheeredby = "You, \(feeditem.cheeredby)"
                                }
                            } else if let firstname = user["first_name"] as? String {
                                if let lastname = user["last_name"] as? String {
                                    feeditem.cheeredby += firstname + " " + lastname
                                    if (i < cheers.count-1) {
                                        feeditem.cheeredby += ", "
                                    }
                                }
                            }
                        }
                    }
                }
                if (cheers.count < feeditem.cheercount) {
                    feeditem.cheeredby += " + \(feeditem.cheercount - cheers.count)"
                }
            }
            if let comments = entry["latest_comments"] as? [[String:AnyObject]] {
                for (i, comment) in comments.enumerate() {
                    var newcomment = Comment()
                    if let notes = comment["notes"] as? String {
                        newcomment.text = notes
                    }
                    if let user = comment["user"] as? [String:AnyObject] {
                        if let firstname = user["first_name"] as? String {
                            if let lastname = user["last_name"] as? String {
                                newcomment.name = firstname + " " + lastname
                                feeditem.commentedby += firstname + " " + lastname
                                if (i < comments.count-1) {
                                    feeditem.commentedby += ", "
                                } else if (i < feeditem.commentcount - 1) {
                                    feeditem.commentedby += " + \(feeditem.commentcount - i - 1)"
                                }
                            }
                        }
                    }
                    feeditem.comments.append(newcomment)
                }
            }
            if let user = entry["user"] as? [String:AnyObject] {
                if let firstname = user["first_name"] as? String {
                    if let lastname = user["last_name"] as? String {
                        feeditem.name = firstname + " " + lastname
                    }
                }
                if let avatar = user["avatar_url"] as? String {
                    feeditem.avatarurl = avatar.stringByReplacingOccurrencesOfString("{size}", withString: "48x48")
                    // should the image be fetched here?
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

    func cheerFor(id:Int) {
        login() { (token) in
            let params = "access_token=\(token)&cheer_type_id=111"
            let request = NSMutableURLRequest()
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            request.URL = NSURL(string: "https://api.heiaheia.com/v2/training_logs/\(id)/cheers")
 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                print(response)
            }
            task.resume()
        }
    }
    
    func addComment(id:Int, comment:String) {
        login() { (token) in
            let params = "access_token=\(token)&notes=\(comment)"
            let request = NSMutableURLRequest()
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            request.URL = NSURL(string: "https://api.heiaheia.com/v2/training_logs/\(id)/comments")
 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                print(response)
            }
            task.resume()
        }
    }
    
    // for testing. maybe need laetr?
    func getCheerTypes() {
        login() { (token) in
            let request = NSMutableURLRequest()
            let params = "access_token=\(token)"
            let components = NSURLComponents(string: "https://api.heiaheia.com/v2/cheer_types")
            components?.query = params
        
            request.HTTPMethod = "GET"
            request.URL = components?.URL
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? Array<[String:AnyObject]> {
                        print(jsonObject)
                    }
                } catch let e {
                    print(e)
                }

            }
            task.resume()
        }
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
 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                print(response)
            }
            task.resume()
        }
    }

    func fetchImageForItem(item: FeedItem, completion: (UIImage) -> ()) {
        let size = CGSize(width: 0, height: 0)
        if (item.avatar.size.width != size.width) {
            completion(item.avatar)
        } else {
            let task = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: item.avatarurl)!) { (location, httpResponse, error) -> Void in
                guard let location = location, let data = NSData(contentsOfURL: location) else {
                    return
                }
                let image = UIImage(data: data)
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(image!)
                }
            }
            task.resume()
        }
    }
    
    
    func fetchImage(urlstr: String, completion: (UIImage) -> ()) {
        let task = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: urlstr)!) { (location, httpResponse, error) -> Void in
            guard let location = location, let data = NSData(contentsOfURL: location) else {
                return
            }
            let image = UIImage(data: data)
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(image!)
            }
        }
        task.resume()
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

    func lastJuly() -> NSDate {             // three hours missing???
    
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let julyComponents = NSDateComponents()
        julyComponents.day = 1
        julyComponents.month = 7
        
        if (todayComponents.month > julyComponents.month) {
            julyComponents.year = todayComponents.year
        } else {
            julyComponents.year = todayComponents.year - 1
        }
        
        let lastJuly = calendar.dateFromComponents(julyComponents)
        
        return lastJuly!
    }
    
    func thisYear() -> Int {
        return NSCalendar.currentCalendar().components([.Year], fromDate: NSDate()).year
    }
    
    func dateFromString(date:String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(date)!
    }
}
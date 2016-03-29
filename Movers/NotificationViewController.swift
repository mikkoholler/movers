//
//  NotificationViewController.swift
//  Movers
//
//  Created by Michael Holler on 23/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let notificationTableView = UITableView()
    let heiaHandler = HeiaHandler()
    
    var notifications:[FeedItem] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.registerClass(FeedTableViewCell.self, forCellReuseIdentifier: "feedcell")
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(notificationTableView)

        notificationTableView.backgroundColor = UIColor.whiteColor()
        notificationTableView.separatorStyle = .None
        notificationTableView.rowHeight = 75
        notificationTableView.allowsSelection = false
        
        notificationTableView.translatesAutoresizingMaskIntoConstraints = false
        notificationTableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
        notificationTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        notificationTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        notificationTableView.heightAnchor.constraintEqualToConstant(1000).active = true        // check height

    }
    
    func getData() {
        heiaHandler.getNotificationFeed() { notifications in
            self.notifications = notifications
            self.notificationTableView.reloadData()
        }
    }

    // Conforming to UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell") as! FeedTableViewCell
        
        let row = indexPath.row
        
        cell.descLabel.text = notifications[row].title
        cell.nameLabel.text = notifications[row].name
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

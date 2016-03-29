//
//  LogViewController.swift
//  Movers
//
//  Created by Michael Holler on 16/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let rideDaysView = UIView()
    let rideTextLabel = UILabel()
    let rideLabel = UILabel()
    let feedTableView = UITableView()

    var logs:[FeedItem] = Array()
    
    var healthHandler = HealthHandler()
    var heiaHandler = HeiaHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.registerClass(FeedTableViewCell.self, forCellReuseIdentifier: "feedcell")
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(rideDaysView)
        view.addSubview(feedTableView)

        rideDaysView.backgroundColor = UIColor.whiteColor()

        rideDaysView.translatesAutoresizingMaskIntoConstraints = false
        rideDaysView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
        rideDaysView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        rideDaysView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        rideDaysView.heightAnchor.constraintEqualToConstant(100).active = true

        rideDaysView.addSubview(rideTextLabel)
        rideDaysView.addSubview(rideLabel)
        
        // looks
        rideTextLabel.text = "Days riding"
        rideTextLabel.textColor = UIColor.blackColor()

        rideLabel.font = rideLabel.font.fontWithSize(48)
        rideLabel.text = "0"

        // layout
        rideTextLabel.translatesAutoresizingMaskIntoConstraints = false
        rideTextLabel.topAnchor.constraintEqualToAnchor(rideDaysView.topAnchor, constant: 10).active = true
        rideTextLabel.leftAnchor.constraintEqualToAnchor(rideDaysView.leftAnchor, constant: 10).active = true

        rideLabel.translatesAutoresizingMaskIntoConstraints = false
        rideLabel.centerXAnchor.constraintEqualToAnchor(rideDaysView.centerXAnchor).active = true
        rideLabel.centerYAnchor.constraintEqualToAnchor(rideDaysView.centerYAnchor).active = true
        
        feedTableView.backgroundColor = UIColor.whiteColor()
        feedTableView.separatorStyle = .None
        feedTableView.rowHeight = 75
        feedTableView.allowsSelection = false
        
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.topAnchor.constraintEqualToAnchor(rideDaysView.bottomAnchor, constant: 10).active = true
        feedTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        feedTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        feedTableView.heightAnchor.constraintEqualToConstant(1000).active = true        // check height
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getData() {
        heiaHandler.getLogs() { logs in
            self.logs = logs
            self.showData()
        }
        
        heiaHandler.getRidingDays() { days in
            self.rideLabel.text = String(format: "%d", days)
        }
    }
    
    // needs animation
    func showData() {
        feedTableView.reloadData()
    }
    

    // Conforming to UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell") as! FeedTableViewCell        // could also be done without reuse
        let row = indexPath.row

        cell.descLabel.text = logs[row].title
        cell.dateLabel.text = logs[row].date
        cell.sportLabel.text = logs[row].sport
        cell.nameLabel.text = logs[row].name
        
        if (logs[row].type == "Weight") {
            cell.sportLabel.text = "Weight"
            cell.weightLabel.text = String(format: "%.1f", logs[row].weight)
        } else {
            cell.weightLabel.text = ""
        }
        
        return cell
    }

    func dateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateInFormat = dateFormatter.stringFromDate(date)

        return dateInFormat
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


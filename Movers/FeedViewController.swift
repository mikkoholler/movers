//
//  FeedViewController.swift
//  Movers
//
//  Created by Michael Holler on 29/02/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let weightInputView = UIView()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let weightButton = UIButton()
    let feedTableView = UITableView()

    var weight = 75.0
    var priorPoint = CGPoint()
    var weights:[Weight] = Array()
    var feed:[FeedItem] = Array()
    var logWeightEnabled = true
    
    var healthHandler = HealthHandler()
    var heiaHandler = HeiaHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.registerClass(FeedTableViewCell.self, forCellReuseIdentifier: "feedcell")
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(weightInputView)
        view.addSubview(feedTableView)

        weightInputView.backgroundColor = UIColor.whiteColor()

        weightInputView.translatesAutoresizingMaskIntoConstraints = false
        weightInputView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
        weightInputView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        weightInputView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        weightInputView.heightAnchor.constraintEqualToConstant(100).active = true

        weightInputView.addSubview(weightTextLabel)
        weightInputView.addSubview(weightLabel)
        weightInputView.addSubview(weightButton)
        
        // looks
        weightTextLabel.text = "Enter weight"
        weightTextLabel.textColor = UIColor.blackColor()

        weightLabel.font = weightLabel.font.fontWithSize(48)
        weightLabel.text = String(format:"%.1f", weight)

        weightButton.setTitle("Save", forState: .Normal)
        weightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        weightButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)

        // layout
        weightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextLabel.topAnchor.constraintEqualToAnchor(weightInputView.topAnchor, constant: 10).active = true
        weightTextLabel.leftAnchor.constraintEqualToAnchor(weightInputView.leftAnchor, constant: 10).active = true

        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.centerXAnchor.constraintEqualToAnchor(weightInputView.centerXAnchor).active = true
        weightLabel.centerYAnchor.constraintEqualToAnchor(weightInputView.centerYAnchor).active = true
        
        weightButton.translatesAutoresizingMaskIntoConstraints = false
        weightButton.bottomAnchor.constraintEqualToAnchor(weightInputView.bottomAnchor, constant: -10).active = true
        weightButton.rightAnchor.constraintEqualToAnchor(weightInputView.rightAnchor, constant: -10).active = true

        // action
        weightLabel.userInteractionEnabled = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        longPressRecognizer.minimumPressDuration = 0.1
        weightLabel.addGestureRecognizer(longPressRecognizer)

        weightButton.addTarget(self, action: "buttonPressed", forControlEvents: UIControlEvents.TouchUpInside)

        feedTableView.backgroundColor = UIColor.whiteColor()
        feedTableView.separatorStyle = .None
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 75
        feedTableView.allowsSelection = false
        
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.topAnchor.constraintEqualToAnchor(weightInputView.bottomAnchor, constant: 10).active = true
        feedTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        feedTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        feedTableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -49).active = true   // tab bar height

        healthHandler.authorizeHealthKit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getData() {
        healthHandler.loadWeights() { weights in
            self.weights = weights
//            self.showData()
        }

        heiaHandler.getFeed() { feed in
            self.feed = feed
            self.showData()
        }
        
    }
    
    // needs animation
    func showData() {
        if (weights.count > 0) {
            weight = weights[0].kg
            weightLabel.text = String(format:"%.1f", weight)
            feedTableView.reloadData()
            
            if (isToday(weights[0].date)) {
                disableToday()
            } else {
                enableToday()
            }
        }
    }
    
    func isToday(date: NSDate) -> Bool{
        var isOK = false

        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let todayComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: NSDate())

        if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
            isOK = true
        }

        return isOK
    }
    
    func disableToday() {
        weightTextLabel.text = "Today's weight"
        weightButton.hidden = true
        logWeightEnabled = false
    }
    
    func enableToday() {
        weightTextLabel.text = "Enter weight"
        weightButton.hidden = false
        logWeightEnabled = true
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        if (logWeightEnabled) {
            let point = sender.locationInView(view)
            let diff = priorPoint.y - point.y

            if (sender.state == UIGestureRecognizerState.Began) {
                priorPoint = point;
                weightLabel.textColor = UIColor.lightGrayColor()
            
            } else if (sender.state == UIGestureRecognizerState.Changed) {
                if (diff < -5) {
                    weight -= 0.1;
                    priorPoint = point;
                } else if (diff > 5) {
                    weight += 0.1;
                    priorPoint = point;
                }
                weightLabel.text = String(format:"%.1f", weight);
            
            } else if (sender.state == UIGestureRecognizerState.Ended) {
                weightLabel.textColor = UIColor.blackColor()
            }
        }
    }

    func buttonPressed() {
        let adddate = NSDate()
        let addweight = Double(weightLabel.text!)!              // what is this sorcery?
        
        weights.insert(Weight(date: adddate, kg: addweight), atIndex: 0)
        healthHandler.saveWeight(adddate, weight: addweight)
        heiaHandler.saveWeight(adddate, weight: addweight)
//        feedTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        getData()
    }

    // Conforming to UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell") as! FeedTableViewCell        // could also be done without reuse
        let row = indexPath.row

        cell.descLabel.text = feed[row].desc
        cell.dateLabel.text = feed[row].date
        cell.sportLabel.text = feed[row].sport
        cell.nameLabel.text = feed[row].name
        
        if (feed[row].type == "Weight") {
            cell.sportLabel.text = "Weight"
            cell.weightLabel.text = String(format: "%.1f", feed[row].weight)
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


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
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.1
        weightLabel.addGestureRecognizer(longPressRecognizer)

        weightButton.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target:self, action: #selector(doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        feedTableView.addGestureRecognizer(doubleTap)

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
            
            if (isToday(weights[0].date)) {
                disableToday()
            } else {
                enableToday()
            }
        }
        feedTableView.reloadData()
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

    func doubleTap(sender: UITapGestureRecognizer) {
        
        let point = sender.locationInView(sender.view)
        let indexPath = feedTableView.indexPathForRowAtPoint(point)
        let cell = feedTableView.cellForRowAtIndexPath(indexPath!) as! FeedTableViewCell

        if (!cell.hasCheered) {
            heiaHandler.cheerFor(cell.feedid)

            let row = indexPath!.row
            feed[row].cheercount += 1
            feed[row].hasCheered = true
            if (feed[row].cheercount == 1) {
                feed[row].cheeredby = "You"
            } else {
                feed[row].cheeredby = "You, \(feed[row].cheeredby)"
            }
            
            feedTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }

    func showCheer(cell:FeedTableViewCell) {
        if (!cell.cheerLabel.text!.isEmpty) {
            cell.cheerLabel.text = "You, " + cell.cheerLabel.text!
        } else {
            cell.cheerLabel.text = "You"
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

        cell.feedid = feed[row].id
        cell.hasCheered = feed[row].hasCheered

        // TODO: title could be edited even if there's no desc
        if (!feed[row].desc.isEmpty) {
            cell.descLabel.text = feed[row].title + " " + feed[row].desc
        } else {
            cell.descLabel.text = ""
        }
        cell.dateLabel.text = feed[row].date
        cell.sportLabel.text = feed[row].sport
        cell.nameLabel.text = feed[row].name
        
        var stars = ""
        for _ in 0..<feed[row].mood {
            stars = stars + "\u{2B50}"
        }
        
        cell.moodLabel.text = stars
        
        if (feed[row].type == "Weight") {
            cell.sportLabel.text = "Weight"
            cell.weightLabel.text = String(format: "%.1f", feed[row].weight)
        } else {
            cell.weightLabel.text = ""
        }

        // TODO: show empty avatar url
        if (!feed[row].avatarurl.isEmpty) {
            let size = CGSize(width: 0, height: 0)
            if (self.feed[row].avatar.size.width != size.width) {
                cell.avatarView.image = self.feed[row].avatar
            } else {
                heiaHandler.fetchImage(self.feed[row].avatarurl, completion: { image in
                    self.feed[row].avatar = image
                    cell.avatarView.image = image
                })
            }
        } else {
            cell.avatarView.image = UIImage()
        }

        if (feed[row].hasCheered) {
            cell.actionLabel.text = "You cheered for this"
        } else {
            cell.actionLabel.text = "Double tap to cheer"
        }

        if (feed[row].cheercount == 0) {
            cell.cheerLabel.text = ""
        } else {
            cell.cheerLabel.text = "\u{1F44A} \(feed[row].cheeredby)"
        }

        if (feed[row].commentcount == 0) {
            cell.commentLabel.text = ""
        } else {
            var notes = ""
            for (i, comment) in feed[row].comments.enumerate().reverse() {
                notes += comment.name + ": " + comment.text
                if (i > 0) {
                    notes += "\n"
                }
            }
            // moar than the latest?
            cell.commentLabel.text = "\u{1F4AC}\n\(notes)"
        }
        
        cell.commentButton.tag = row
        cell.commentButton.addTarget(self, action: #selector(addComment(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }

    func addComment(sender: UIButton) {
        let row = sender.tag
        let indexPath = NSIndexPath(forRow:row, inSection:0)
        let cell = feedTableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell

        let newcomment = Comment(name: "You", text: cell.commentTextField.text!)
        feed[row].commentcount += 1
        feed[row].commentedby = "You, " + feed[row].commentedby
        feed[row].comments.insert(newcomment, atIndex: 0)
        
        cell.commentTextField.text = ""
        
        feedTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        // add to Heia
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


//
//  ViewController.swift
//  Movers
//
//  Created by Michael Holler on 29/02/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let weightInputView = UIView()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let weightButton = UIButton()
    let feedTableView = UITableView()

    var weight = 75.0
    var priorPoint = CGPoint()
    var weights:[[String:AnyObject]] = Array()
    
    var healthHandler = HealthHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthHandler.loadWeights() { weights in
            self.weights = weights
            
            // redraw shit in main thread. otherwise the sky will fall
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.redraw()
            })
        }

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

        // TODO toggle: we have your input for today

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
        feedTableView.rowHeight = 50
        feedTableView.allowsSelection = false
        
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.topAnchor.constraintEqualToAnchor(weightInputView.bottomAnchor, constant: 10).active = true
        feedTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        feedTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        feedTableView.heightAnchor.constraintEqualToConstant(1000).active = true

        healthHandler.authorizeHealthKit()
        
        print("did load")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
/*
        healthHandler.loadWeights() { weights in
            self.weights = weights
            self.redraw()
        }
*/
    }
    
    // needs animation
    func redraw() {
        print("redarwing")
   
        if (weights.count > 0) {
            weight = weights[weights.count-1]["weight"] as! Double
            weightLabel.text = String(format:"%.1f", weight)
            feedTableView.reloadData()
        }
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        
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


    func buttonPressed() {
        healthHandler.saveWeight(NSDate(), weight: Double(weightLabel.text!)!)  // what is this sorcery?
        // feedTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }

    // Conforming to UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weights.count
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell", forIndexPath: indexPath) as! FeedTableViewCell

        let row = weights.count - indexPath.row - 1
        cell.dateLabel.text = dateString((weights[row]["date"] as? NSDate)!)
        cell.weightLabel.text = String(format: "%.1f", (weights[row]["weight"] as? Double)!)
        
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


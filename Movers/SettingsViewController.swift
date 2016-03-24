//
//  SettingsViewController.swift
//  Movers
//
//  Created by Michael Holler on 23/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let notificationLabel = UILabel()
    let notificationSwitch = UISwitch()

    let weightLabel = UILabel()
    let weightSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(notificationLabel)
        view.addSubview(notificationSwitch)
        view.addSubview(weightLabel)
        view.addSubview(weightSwitch)
        
        notificationLabel.text = "Send notifications"
        notificationLabel.textColor = UIColor.blackColor()

        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true
        notificationLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true

        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.centerYAnchor.constraintEqualToAnchor(notificationLabel.centerYAnchor).active = true
        notificationSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true

        weightLabel.text = "Save weight to HealthKit"
        weightLabel.textColor = UIColor.blackColor()

        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.topAnchor.constraintEqualToAnchor(notificationLabel.bottomAnchor, constant: 40).active = true
        weightLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true

        weightSwitch.translatesAutoresizingMaskIntoConstraints = false
        weightSwitch.centerYAnchor.constraintEqualToAnchor(weightLabel.centerYAnchor).active = true
        weightSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true

        // set default for nao
        notificationSwitch.on = true
        weightSwitch.on = true
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

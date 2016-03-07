//
//  NotificationsHandler.swift
//  Movers
//
//  Created by Michael Holler on 07/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class NotificationHandler {

    init() {
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
    }
    
    func setNotifications() {
        let notification = UILocalNotification()
        notification.alertTitle = "Log weight"
        notification.alertBody = "Have you logged today's weight yet?"
        notification.alertAction = "log"
        notification.fireDate = tomorrowAt8()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = .Day
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func tomorrowAt8() -> NSDate {
        let tomorrowComponents = NSDateComponents()
        tomorrowComponents.day = 1
        let calendar = NSCalendar.currentCalendar()
        let tomorrow = calendar.dateByAddingComponents(tomorrowComponents, toDate:NSDate(), options:.MatchFirst)
        let tomorrowAt8AMComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: tomorrow!)
        tomorrowAt8AMComponents.hour = 8
        let tomorrowAt8AM = calendar.dateFromComponents(tomorrowAt8AMComponents)
        
        return tomorrowAt8AM!
    }
}
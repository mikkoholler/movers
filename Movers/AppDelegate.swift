//
//  AppDelegate.swift
//  Movers
//
//  Created by Michael Holler on 29/02/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let notifications = NotificationHandler()
        notifications.setNotifications()
        
        let feed = makeViewControllerNavigateable(FeedViewController(), title: "Feed", tabIcon: .More)
        let log = makeViewControllerNavigateable(FeedViewController(), title: "Log", tabIcon: .Favorites)

        let tabs = UITabBarController()
        tabs.viewControllers = [feed, log]

        window = UIWindow()
        window?.rootViewController = tabs
        window?.makeKeyAndVisible()
        
        return true
    }

    func makeViewControllerNavigateable(controller: UIViewController, title: String, tabIcon: UITabBarSystemItem) -> UINavigationController {
        controller.navigationItem.title = title
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: tabIcon, tag: 0)
        let navigation = UINavigationController()
        navigation.viewControllers = [controller]
        return navigation
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
      
       if let viewController = window?.rootViewController as? FeedViewController {
            viewController.getData()
        }
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


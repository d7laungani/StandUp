//
//  AppDelegate.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Calling our local method to register for local notifications.
        self.registerForLocalNotifications()
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        // Point for handling the local notification Action. Provided alongside creating the notification.
        if identifier == "ShowDetails" {
            // Showing reminder details in an alertview
            if #available(iOS 8.2, *) {
                UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                // Fallback on earlier versions
            }
        } else if identifier == "willStand" {
            // Snooze the reminder for 5 minutes
            notification.fireDate = NSDate().dateByAddingTimeInterval(60*5)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        } else if identifier == "willNotStand" {
            // Confirmed the reminder. Mark the reminder as complete maybe?
        }
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
                if #available(iOS 8.2, *) {
            UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            print("Received Local Notification:")
            print(notification.alertBody)
        }
    }
    
    func registerForLocalNotifications() {
        
        print("reached here")
        // Specify the notification actions.
        let willStandAction = UIMutableUserNotificationAction()
        willStandAction.identifier = "willStand"
        willStandAction.title = "OK, got it"
        willStandAction.activationMode = UIUserNotificationActivationMode.Background
        willStandAction.destructive = false
        willStandAction.authenticationRequired = false
        
        let willNotStandAction = UIMutableUserNotificationAction()
        willNotStandAction.identifier = "willNotStand"
        willNotStandAction.title = "Cannot"
        willNotStandAction.activationMode = UIUserNotificationActivationMode.Background
        willNotStandAction.destructive = false
        willNotStandAction.authenticationRequired = false
        
        
        
        
        
        // Create a category with the above actions
        let standingReminderCategory = UIMutableUserNotificationCategory()
        standingReminderCategory.identifier = "standingReminderCategory"
        standingReminderCategory.setActions([willNotStandAction, willStandAction], forContext: UIUserNotificationActionContext.Default)
        standingReminderCategory.setActions([willNotStandAction, willStandAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // Register for notification: This will prompt for the user's consent to receive notifications from this app.
        let notificationSettings =  UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: NSSet(array:[standingReminderCategory]) as? Set<UIUserNotificationCategory>)
        //*NOTE*
        // Registering UIUserNotificationSettings more than once results in previous settings being overwritten.
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
}


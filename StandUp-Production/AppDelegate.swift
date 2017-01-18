//
//  AppDelegate.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import SCLAlertView
import IQKeyboardManagerSwift
import ChameleonFramework
import SwiftyUserDefaults


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if ( Defaults[.settings] == nil) {
            Defaults[.settings] = TimerSettings()
            Defaults.synchronize()
            print ("reached here")
            
        } else {
            
            print ("already exists")
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
   
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits
        
        // Calling our local method to register for local notifications.
        if #available(iOS 10.0, *) {
            self.registerLocalNotifications()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
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
            notification.fireDate = Date().addingTimeInterval(60*5)
            UIApplication.shared.scheduleLocalNotification(notification)
        } else if identifier == "willNotStand" {
            // Confirmed the reminder. Mark the reminder as complete maybe?
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if #available(iOS 8.2, *) {
            UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            print("Received Local Notification:")
            print(notification.alertBody)
        }
        
        if ( application.applicationState == UIApplicationState.active)
        {
            print("Active")
            // App is foreground and notification is recieved,
            // Show a alert.
        }
        else if( application.applicationState == UIApplicationState.background)
        {
            print("Background")
            // App is in background and notification is received,
            // You can fetch required data here don't do anything with UI.
        }
        else if( application.applicationState == UIApplicationState.inactive)
        {
            print("Inactive")
            // App came in foreground by used clicking on notification,
            // Use userinfo for redirecting to specific view controller.
            print(notification.userInfo)
            self.redirectToPage(notification.userInfo)
        }
    }
    
    
    @available(iOS 10.0, *)
    func registerLocalNotifications() {
        
        
        // Make sure all values are properly saved in defaults
        Defaults.synchronize()
        
        let scheduler = DLNotificationScheduler()
        scheduler.cancelAlllNotifications()
        
        let standingCategory = DLCategory(categoryIdentifier: "standingReminder")
        
        standingCategory.addActionButton(identifier: "willStand", title: "Ok, got it")
        standingCategory.addActionButton(identifier: "willNotStand", title: "Cannot")
        
        scheduler.scheduleCategories(categories: [standingCategory])
        
        let settings = Defaults[.settings]
        
        let daysEnabled = settings?.daysEnabled
        
      
        var startComponents = DateComponents()
        
        startComponents.hour = Calendar.current.component(.hour, from: (settings?.startTime)!)
        startComponents.hour = startComponents.hour! - 12
        startComponents.minute = Calendar.current.component(.minute, from: (settings?.startTime)!)
        startComponents.second = 0
        
        
        var endComponents = DateComponents()
        
        endComponents.hour = Calendar.current.component(.hour, from: (settings?.endTime)!)
        endComponents.hour = endComponents.hour! + 12
        endComponents.minute = Calendar.current.component(.minute, from: (settings?.endTime)!)
        endComponents.second = 0
        
        //print ("Starting and ending dates are: ")
        //print(settings?.startTime)
        //print(settings?.endTime)
        
        
        //print ("Starting and ending components are:")
        //print(startComponents.debugDescription)
        //print(endComponents.debugDescription)
        
        for (index, value) in daysEnabled!.enumerated() {
            
            
            if value == true {
                
                // Check if todays date is the date of scheduling
                let today = Calendar.current.component(.weekday, from: Date())
                // It is current date then do something special
                if ( today == index + 2) {
                    
                    // Closest From date
                    
                    //let startDate = try! DateInRegion(components: startComponents)
                    let startDate = Calendar.current.date(bySettingHour: startComponents.hour!, minute: startComponents.minute!, second: 0, of: Date())
                    
                    //print(startDate)
                    
                    // Closest To Date
                    
                    let endDate = Calendar.current.date(bySettingHour: endComponents.hour!, minute: endComponents.minute!, second: 0, of: Date())
                    
                    //print(endDate)
                    
                    let valid = (startDate! < Date()) && (Date() < endDate!)
                    
                    // Go to next day
                    if (!valid){break}
                    
                   // else continue scheduling
                    
                    scheduler.repeatsFromToDate(identifier: "First Notification", alertTitle: "Stand Up", alertBody: (settings?.notificationMessage)!, fromDate: Date(), toDate: endDate!, interval: Double((settings?.timerInterval)!) * 60)
                    
                    
                }
                    
                // The schedulded date is not today so no problem
                else {
                    
                    
                    startComponents.weekday = index + 2
                    
                    //print("Starting components are " + startComponents.debugDescription)
                    let startDate = Calendar.current.nextDate(after: Date(), matching: startComponents, matchingPolicy: Calendar.MatchingPolicy.nextTimePreservingSmallerComponents)
                    print(startDate.debugDescription)
                    //
                    endComponents.weekday = index + 2
                    
                    //print("Ending components are " + endComponents.debugDescription)
                    let endDate = Calendar.current.nextDate(after: Date(), matching: endComponents, matchingPolicy: Calendar.MatchingPolicy.nextTimePreservingSmallerComponents)
                    //print(endDate.debugDescription)
                    scheduler.repeatsFromToDate(identifier: "First Notification", alertTitle: "Stand Up", alertBody: (settings?.notificationMessage)!, fromDate: startDate!, toDate: endDate!, interval: Double((settings?.timerInterval)!) * 60)
                    
                }
            }
            
            
        }
        
        
        
        
        
    }
    
    
    func findClosestDate (fromDate: Date,endDate: Date, interval: Int) -> Date {
        
        
        let currentDate = Date()
        return currentDate
    }
    
    
    func redirectToPage(_ userInfo:[AnyHashable: Any]!)
    {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewControllerToBrRedirectedTo:UIViewController! = sb.instantiateViewController(withIdentifier: "TabBarController")
        
        
        if userInfo != nil
        {
            if let pageType = userInfo["view"]
            {
                if pageType as! String == "alertView"
                {
                    //viewControllerToBrRedirectedTo = SettingsTableViewController()
                }
            }
        }
        
        if viewControllerToBrRedirectedTo != nil
        {
            print("reached here")
            if self.window != nil && self.window?.rootViewController != nil
                
            {
                let rootVC = self.window?.rootViewController!
                print(rootVC)
                if rootVC is UITabBarController
                {
                    self.window?.rootViewController?.present(viewControllerToBrRedirectedTo, animated: true, completion: nil)
                    
                    /*
                     else
                     {
                     rootVC?.presentViewController(viewControllerToBrRedirectedTo, animated: true, completion: { () -> Void in
                     
                     print("Presented view Controller")
                     
                     })
                     }
                     */
                    
                    
                }
            }
            
            //Create Alert View
            
            let alertCtrl = UIAlertController(title: "Make a Decision"  , message: "You better be standing", preferredStyle: UIAlertControllerStyle.alert)
            
            alertCtrl.addAction(UIAlertAction(title: "Will Stand Up", style: .destructive, handler: nil))
            alertCtrl.addAction(UIAlertAction(title: "Will not Stand Up", style: .destructive, handler: nil))
            
            
            // Add Alert View on top of screen
            var presentedVC = self.window?.rootViewController
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            // presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
            requestRecieved()
            
            
        }
    }
    
    
    func requestRecieved()  {
        let alert = SCLAlertView()
        alert.addButton("Stand Up") {
            print("accest")
        }
        
        
        
        alert.showTitle(
            "Time to Stand Up",
            subTitle: "Stay Healthy"   ,
            duration: 0 ,
            completeText: "Not Right Now",
            style: .info,
            colorStyle: 0x43d4e6,
            colorTextButton: 0xFFFFFF
        )
        
        
        
        
        
    }
}


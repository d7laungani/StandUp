//
//  TimerViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController: UIViewController {
    
    
    
    
    let step: Float = 5
    @IBOutlet var daysButtons: [UIButton]!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    
    @IBAction func timeIntervalSlider(sender: UISlider) {
        
        
        
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        
        intervalLabel.text = formattedDuration
    }
    
    
    
    @IBAction func startNotifications(sender: UIButton) {
             // self.setupNotificationSettings()
        self.scheduleLocalNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        self.hideKeyboardWhenTappedAround()
        
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        /*
        if (notificationSettings.types == UIUserNotificationType.None){
            self.setupNotificationSettings()
        }
        self.scheduleLocalNotification()
        */
            }
    
    func setupUIElements () {
        
        
        for button in daysButtons {
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1.1
            button.layer.borderColor = UIColor.blueColor().CGColor
            
            
        }
        
        
    }
    
    
    
    func scheduleLocalNotification() {
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.repeatInterval = NSCalendarUnit.Day
        localNotification.alertBody = "Why not take a break and walk around a little."
        localNotification.alertAction = "View List"
        localNotification.category = "standingReminderCategory"
        localNotification.timeZone = NSCalendar.currentCalendar().timeZone
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        let unitFlags: NSCalendarUnit = [.Second, .Hour, .Day, .Month, .Year]
        let dateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: startTime)
        dateComponents.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        return fixedDate
    }
    
    
}

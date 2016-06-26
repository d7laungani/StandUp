//
//  TimerViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    
    var settings = defaults.objectForKey("Settings") as? TimerSettings
    
    @IBOutlet var daysButtons: [UIButton]!
    
    
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var notificationMessage: UITextField!{
        didSet {
            notificationMessage.delegate = self
        }
    }
    
    
    @IBAction func saveNotificationMessage(sender: UITextField) {
        
        
        settings?.notificationMessage = sender.text
        
        
        
    }
    
    
    @IBAction func timeIntervalSlider(sender: UISlider) {
        
        
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        sender.continuous = true
        
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        
        intervalLabel.text = formattedDuration
    }
    
    
    @IBAction func startNotification(sender: UIButton) {
        
        self.scheduleLocalNotification()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        self.hideKeyboardWhenTappedAround()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func setupUIElements () {
        
        
        for button in daysButtons {
            
            button.layer.cornerRadius = 0
            button.layer.borderWidth = 1.1
            button.layer.borderColor = UIColor(hexString: "43D4E6").CGColor
            
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func scheduleLocalNotification() {
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.repeatInterval = NSCalendarUnit.Day
        localNotification.alertBody = "Why not take a break and walk around a little."
        localNotification.alertAction = "View List"
        localNotification.category = "standingReminderCategory"
        localNotification.timeZone = NSCalendar.currentCalendar().timeZone
        localNotification.userInfo = ["view" : "alertView"]
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        let unitFlags: NSCalendarUnit = [.Second, .Hour, .Day, .Month, .Year]
        let dateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: startTime)
        dateComponents.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        return fixedDate
    }
    
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        /*
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.view.frame.origin.y -= 50
        
        
        //self.view.frame.origin.y += 20
        print("Keyboard size will show\(keyboardSize.height)")
        
        }
        */
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()  {
            if (keyboardSize.height > 10) {
                self.view.frame.origin.y -= 70
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        /*
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        // self.view.frame.origin.y += keyboardSize.height * 2
        self.view.frame.origin.y += 50
        print("Keyboard size will hide\(keyboardSize.height)")
        }
        */
        
        self.view.frame.origin.y += 70
        
    }
}
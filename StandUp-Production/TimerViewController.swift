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
    
    
    
    
    
    var settings = defaults.object(forKey: "Settings") as? TimerSettings
    
    @IBOutlet var daysButtons: [UIButton]!
    
    
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var notificationMessage: UITextField!{
        didSet {
            notificationMessage.delegate = self
        }
    }
    
    
    @IBAction func saveNotificationMessage(_ sender: UITextField) {
        
        
        settings?.notificationMessage = sender.text
        
        
        
    }
    
    
    @IBAction func timeIntervalSlider(_ sender: UISlider) {
        
        
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        sender.isContinuous = true
        
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        
        intervalLabel.text = formattedDuration
    }
    
    
    @IBAction func startNotification(_ sender: UIButton) {
        
        self.scheduleLocalNotification()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimerViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TimerViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func setupUIElements () {
        
        
        for button in daysButtons {
            
            
            button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.white.cgColor
            
            
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSinceNow: 10)
        localNotification.repeatInterval = NSCalendar.Unit.day
        localNotification.alertBody = "Why not take a break and walk around a little."
        localNotification.alertAction = "View List"
        localNotification.category = "standingReminderCategory"
        localNotification.timeZone = Calendar.current.timeZone
        localNotification.userInfo = ["view" : "alertView"]
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    
    
    func fixNotificationDate(_ dateToFix: Date) -> Date {
        let unitFlags: NSCalendar.Unit = [.second, .hour, .day, .month, .year]
        var dateComponents = (Calendar.current as NSCalendar).components(unitFlags, from: startTime)
        dateComponents.second = 0
        
        var fixedDate: Date! = Calendar.current.date(from: dateComponents)
        
        return fixedDate
    }
    
    
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        /*
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.view.frame.origin.y -= 50
        
        
        //self.view.frame.origin.y += 20
        print("Keyboard size will show\(keyboardSize.height)")
        
        }
        */
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  {
            if (keyboardSize.height > 10) {
                self.view.frame.origin.y -= 70
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    
    
   static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

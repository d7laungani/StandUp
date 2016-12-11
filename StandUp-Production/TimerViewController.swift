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
    
    
     weak var activeField: UITextField?
    
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.deregisterFromKeyboardNotifications()
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
        
        
         //self.registerForKeyboardNotifications()
        
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
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
   
    
    /*
    // Kyeboard moving up and down stuff
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardDidShow:"), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    */
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

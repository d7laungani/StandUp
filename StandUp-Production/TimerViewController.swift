//
//  TimerViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import QuartzCore
import PermissionScope
import ChameleonFramework
import SwiftyUserDefaults

class TimerViewController: UIViewController, UITextFieldDelegate {
    
    let pscope = PermissionScope()
    weak var activeField: UITextField?
    
    var settings = Defaults[.settings]
    
    @IBOutlet var daysButtons: [UIButton]!
    
    
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var notificationMessage: UITextField!{
        didSet {
            notificationMessage.delegate = self
        }
    }
    
    
    @IBAction func setNotification(_ sender: Any) {
        self.scheduleLocalNotification()
        
    }
    @IBAction func saveNotificationMessage(_ sender: UITextField) {
        
        
        settings?.notificationMessage = sender.text
        print("text is " + sender.text!)
        print("updated value is " + (Defaults[.settings]?.notificationMessage)!)
        
        
        
    }
    
    @IBAction func updateDays(_ sender: Any) {
        
        guard let button = sender as? UIButton else {
            return
        }
        
        settings?.daysEnabled[button.tag] = button.isSelected
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.deregisterFromKeyboardNotifications()
        
        Defaults[.settings]? = settings!
        
    }
    
      @IBAction func timeIntervalSlider(_ sender: UISlider) {
        
        
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        sender.isContinuous = true
        
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        
        settings?.timerInterval = m
        intervalLabel.text = formattedDuration
    }
    
    
    @IBAction func startNotification(_ sender: UIButton) {
        
        self.scheduleLocalNotification()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatPurple
        setupUIElements()
        self.hideKeyboardWhenTappedAround()
        
        
        // Set up permissions
        
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to help you live longer")
        pscope.addPermission(LocationAlwaysPermission(),
                             message: "We use this to give you more accurate feedback")
        
        
        
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
        
        
         //self.registerForKeyboardNotifications()
        
    }
    func setupUIElements () {
        
        
        for button in daysButtons {
            
            let contrastColor = ContrastColorOf(view.backgroundColor!, returnFlat: false)
            
            button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2.0
            //button.layer.borderColor = UIColor.white.cgColor
            button.setTitleColor(ContrastColorOf(view.backgroundColor!, returnFlat: false), for: .normal)
            button.layer.borderColor = contrastColor.cgColor
            
            
            
            
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


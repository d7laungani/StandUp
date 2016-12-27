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
    
    var settings = Defaults[.settings]
    
    @IBOutlet var daysButtons: [UIButton]!
    
    
    @IBOutlet weak var timerSlider: UISlider!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    
    
    
    @IBOutlet weak var notificationMessage: UITextField! {
        didSet {
            notificationMessage.delegate = self
        }
    }
    
    
    
    func doneAction(_ sender : UITextField) {
        
        
        settings?.notificationMessage = sender.text
        
        saveSettings()
        
        
    }
    
    @IBAction func updateDays(_ sender: Any) {
        
        guard let button = sender as? UIButton else {
            return
        }
        
        button.isSelected = !button.isSelected;
        settings?.daysEnabled[button.tag] = button.isSelected
        saveSettings()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // self.deregisterFromKeyboardNotifications()
        saveSettings()
        
    }
    
    @IBAction func timeIntervalSlider(_ sender: UISlider) {
        
        
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        sender.isContinuous = true
        
        updateIntervalLabel(roundedValue: roundedValue)
        
        settings?.timerInterval = Int(roundedValue)
        saveSettings()
        
    }
    
    // uppdate slider Label text
    func updateIntervalLabel (roundedValue:Float) {
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        intervalLabel.text = formattedDuration
        
    }
    
    func saveSettings () {
        Defaults[.settings]? = settings!
        Defaults.synchronize()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatPurple
        setupUIElements()
        
        self.hideKeyboardWhenTappedAround()
        
        notificationMessage.setCustomDoneTarget(self, action: #selector(self.doneAction(_:)))
        updateValues()
        
        
        // Set up permissions
        
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to help you live longer")
        pscope.addPermission(LocationAlwaysPermission(),
                             message: "We use this to give you more accurate feedback")
        
        
        
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
        
        
        
    }
    
    // Updates values if changed
    
    func updateValues () {
        
        // Updates interval text label
        
        let x = Float((settings?.timerInterval)!)
        timerSlider.value = x
        updateIntervalLabel(roundedValue: x)
        
        // Update button state
        
        for (index, value) in  (settings?.daysEnabled)!.enumerated(){
            daysButtons[index].isSelected = value
        }
        
        // update notification message
        
        if (settings?.notificationMessage != "Why not take a break and walk around a little."){
            notificationMessage.text = settings?.notificationMessage
        }
        
    }
    
    func setupUIElements () {
        
        
        for button in daysButtons {
            
            let contrastColor = ContrastColorOf(view.backgroundColor!, returnFlat: false)
            
            button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2.0
            button.setTitleColor(ContrastColorOf(view.backgroundColor!, returnFlat: false), for: .normal)
            button.layer.borderColor = contrastColor.cgColor
            
            
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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


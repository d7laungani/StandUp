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
import EFCircularSlider



class TimerViewController: UIViewController, UITextFieldDelegate{
    
    let pscope = PermissionScope()
    
    var settings = Defaults[.settings]
    
    @IBOutlet var daysButtons: [UIButton]!
    
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    var minuteSlider = EFCircularSlider()
  
    
    
    
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
    
    func minuteDidChange(x: EFCircularSlider ) {
        
        let value = x.currentValue
        
        let step: Float = 5
        let roundedValue = round(value / step) * step
        
        x.currentValue = roundedValue
       
        updateIntervalLabel(roundedValue: roundedValue)
        
        settings?.timerInterval = Int(roundedValue)
        saveSettings()


        
    }
    
    // Updates values if changed
    
    func updateValues () {
        
        
        // Updates interval text label
        
        let x = Float((settings?.timerInterval)!)
        minuteSlider.currentValue = x
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
        
        // Timer setup
        self.view.backgroundColor = UIColor(red: CGFloat(31 / 255.0), green: CGFloat(61 / 255.0), blue: CGFloat(91 / 255.0), alpha: CGFloat(1.0))
        
        var minuteSliderFrame = CGRect(x: CGFloat(10), y: CGFloat(140), width: self.view.frame.size.width - 20, height: CGFloat(270))
        
      
        minuteSlider = EFCircularSlider(frame: minuteSliderFrame)
        minuteSlider.unfilledColor = UIColor(red: CGFloat(23 / 255.0), green: CGFloat(47 / 255.0), blue: CGFloat(70 / 255.0), alpha: CGFloat(1.0))
        minuteSlider.filledColor = UIColor(red: CGFloat(155 / 255.0), green: CGFloat(211 / 255.0), blue: CGFloat(156 / 255.0), alpha: CGFloat(1.0))
        
        minuteSlider.setInnerMarkingLabels(["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"])
        
        minuteSlider.labelFont = UIFont.systemFont(ofSize: CGFloat(14.0))
        minuteSlider.lineWidth = 8
        minuteSlider.minimumValue = 0
        minuteSlider.maximumValue = 60

        //minuteSlider.snapToLabels = true
        minuteSlider.labelColor = UIColor(red: CGFloat(76 / 255.0), green: CGFloat(111 / 255.0), blue: CGFloat(137 / 255.0), alpha: CGFloat(1.0))
        minuteSlider.handleType = doubleCircleWithOpenCenter
        minuteSlider.handleColor = minuteSlider.filledColor
        
        self.view.addSubview(minuteSlider)
     
        minuteSlider.addTarget(self, action: #selector(self.minuteDidChange), for: .valueChanged)

        
        
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


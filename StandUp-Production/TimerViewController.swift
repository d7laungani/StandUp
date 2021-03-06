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
import UserNotifications
import Foundation
import Crashlytics

class TimerViewController: UIViewController, UITextFieldDelegate {

    let pscope = PermissionScope()
    var settings = Defaults[.settings]
    var minuteSlider = EFCircularSlider()
    var timeLabel: UILabel?

    @IBOutlet var daysButtons: [UIButton]!
    @IBOutlet weak var setNotification: UIButton!
    @IBOutlet weak var stackView: UIStackView!

    @IBAction func setNotifications(_ sender: Any) {

        Answers.logCustomEvent(withName: "Notification Set",
                                       customAttributes: [
                                        "Start Time": settings?.startTime.string().components(separatedBy: "at")[1],
                                        "End Rime": settings?.endTime.string().components(separatedBy: "at")[1],
                                        "Timer Interval": settings?.timerInterval as! NSInteger])
        
        let alert = UIAlertController(title: "Notifications set !", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true) {}
    }
    @IBAction func updateDays(_ sender: Any) {

        guard let button = sender as? UIButton else {
            return
        }

        button.isSelected = !button.isSelected
        if button.isSelected {
            button.setTitleColor(UIColor.brown, for: .selected)
            button.layer.borderColor = UIColor.brown.cgColor
            let day = mapToDay(x: button.tag)
            Answers.logCustomEvent(withName: "Day Chosen",
                                   customAttributes: [
                                    "Day": day])
        } else {
            button.layer.borderColor = UIColor.white.cgColor

        }

        settings?.daysEnabled[button.tag] = button.isSelected
        saveSettings()

    }
    override func viewWillDisappear(_ animated: Bool) {

        saveSettings()

    }

    // uppdate slider Label text
    func updateIntervalLabel (roundedValue: Float) {
        let s: Int = 00
        let m: Int = Int(roundedValue)

        let formattedDuration = String(format: "%0d:%02d", m, s)
        timeLabel?.text = formattedDuration + " mins"

    }

    func saveSettings () {
        Defaults[.settings]? = settings!
        Defaults.synchronize()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.flatPurple
        setupUIElements()
        settings = Defaults[.settings]
        self.hideKeyboardWhenTappedAround()

        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to help you live longer")

        // Show dialog with callbacks
        pscope.show({ _, _ in
           UIApplication.shared.registerForRemoteNotifications()
        }, cancelled: { (_) -> Void in
            print("thing was cancelled")
        })

        if settings == nil { self.minuteSlider.currentValue = 45.0} else { updateValues() }

    }
    func minuteDidChange(slider: EFCircularSlider ) {

        let value = slider.currentValue

        let step: Float = 5
        let roundedValue = round(value / step) * step

        if value == roundedValue {
            return
        }
        slider.currentValue = roundedValue

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

        for (index, value) in  (settings?.daysEnabled)!.enumerated() {
            daysButtons[index].isSelected = value
            if value {

                //button.setTitleColor(UIColor.brown), for: .selected)
                daysButtons[index].setTitleColor(UIColor.brown, for: .selected)
                daysButtons[index].layer.borderColor = UIColor.brown.cgColor

            } else {
                daysButtons[index].layer.borderColor = UIColor.white.cgColor

            }

        }

    }

    func setupUIElements () {

        for button in daysButtons {

            let contrastColor = ContrastColorOf(view.backgroundColor!, returnFlat: false)

            // button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
            button.layer.cornerRadius = 0.5 * button.bounds.size.height
            button.clipsToBounds = true
            button.layer.borderWidth = 2.0
            button.setTitleColor(ContrastColorOf(view.backgroundColor!, returnFlat: false), for: .normal)
            button.layer.borderColor = contrastColor.cgColor
            button.adjustsImageWhenHighlighted = false

        }

        // Setup Set Notificaiton button

        setNotification.layer.cornerRadius = 0.5 * setNotification.bounds.size.height
        setNotification.clipsToBounds = true
        setNotification.layer.borderWidth = 2.0
        setNotification.setTitleColor(ContrastColorOf(view.backgroundColor!, returnFlat: false), for: .normal)
        setNotification.layer.borderColor = UIColor.white.cgColor

        // Stack View setup

        stackView.axis = .horizontal

        // Timer setup
        self.view.backgroundColor = UIColor(red: CGFloat(31 / 255.0), green: CGFloat(61 / 255.0), blue: CGFloat(91 / 255.0), alpha: CGFloat(1.0))

        var minuteSliderFrame = CGRect(x: CGFloat(10), y: CGFloat(160), width: self.view.frame.size.width - 20, height: CGFloat(270))
        if (UIDevice().screenType == .iPhone5) {
            minuteSliderFrame = CGRect(x: CGFloat(10), y: CGFloat(130), width: self.view.frame.size.width - 20, height: CGFloat(240))

        }
        minuteSlider = EFCircularSlider(frame: minuteSliderFrame)
        minuteSlider.unfilledColor = UIColor(red: CGFloat(23 / 255.0), green: CGFloat(47 / 255.0), blue: CGFloat(70 / 255.0), alpha: CGFloat(1.0))
        minuteSlider.filledColor = UIColor(red: CGFloat(155 / 255.0), green: CGFloat(211 / 255.0), blue: CGFloat(156 / 255.0), alpha: CGFloat(1.0))
        minuteSlider.setInnerMarkingLabels(["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"])
        minuteSlider.labelFont = UIFont.systemFont(ofSize: CGFloat(14.0))
        minuteSlider.lineWidth = 8
        minuteSlider.minimumValue = 0
        minuteSlider.maximumValue = 60
        minuteSlider.labelColor = UIColor(red: CGFloat(76 / 255.0), green: CGFloat(111 / 255.0), blue: CGFloat(137 / 255.0), alpha: CGFloat(1.0))
        minuteSlider.handleType = .doubleCircleWithOpenCenter
        minuteSlider.handleColor = minuteSlider.filledColor
        minuteSlider.translatesAutoresizingMaskIntoConstraints = false
        //minuteSlider.preventOverslidingOnStartPoint = true
        minuteSlider.addTarget(self, action: #selector(self.minuteDidChange), for: .valueChanged)

        // Interval Label Setup

        let timeLabelFrame = CGRect(x: minuteSlider.center.x, y: minuteSlider.center.y, width: CGFloat(130), height: CGFloat(100))
        timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel?.center = minuteSlider.center
        timeLabel?.text = "45:00 mins"
        timeLabel?.textColor = UIColor.white
        timeLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)

        self.view.addSubview(timeLabel!)
        self.view.addSubview(minuteSlider)

    }
    
    func mapToDay (x: Int) -> String {
        
        switch (x) {
        case 0 :
            return "Mon"
        case 1 :
            return "Tues"
        case 2 :
            return "Wed"
            
        case 3 :
            return "Thurs"
        case 4 :
            return "Fri"
        default :
            return "Error"
        }
    
    }

}

public extension UIDevice {

    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
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

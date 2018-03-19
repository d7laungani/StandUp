//
//  SettingsTableViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/18/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import PermissionScope
import MessageUI
import ChameleonFramework
import SwiftyUserDefaults
import JLocationKit
import CoreLocation
import Foundation

class CustomCell: UITableViewCell {
    @IBOutlet weak var switchModule: UISwitch!

}

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var soundToggle: UISwitch!
    @IBOutlet weak var locationUpdatesLabel: UILabel!
    @IBOutlet weak var sleepingTimes: UITableViewCell!
    @IBOutlet weak var locationUpdates: UITableViewCell!
    @IBOutlet weak var feedback: UITableViewCell!
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!

    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var permaScope = PermissionScope()
    var settings = Defaults[.settings]

    @IBOutlet weak var notificationMessage: UITextField! {
        didSet {
            notificationMessage.delegate = self
        }
    }

    func doneAction(_ sender: UITextField) {

        settings?.notificationMessage = sender.text
        saveSettings()

    }

    func saveSettings () {
        Defaults[.settings]? = settings!
        Defaults.synchronize()

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func locationNotificationToggle(_ sender: UISwitch) {

        let location: LocationManager = LocationManager()
        var geocoder = CLGeocoder()

        if sender.isOn {

            let manager = CLLocationManager()

            location.getLocation(detectStyle: .Once, completion: { (loc) in
                self.currentLocation = loc.currentLocation
                self.settings?.currentLocation = loc.currentLocation
                self.settings?.regionNotifications = true
                geocoder.reverseGeocodeLocation(loc.currentLocation, completionHandler: { (placemarks, _) in
                    let placemark = placemarks?.first
                    self.locationLabel.text = placemark?.addressDictionary?["Street"] as! String?

                })

                           }, error: { (error) in
                print(error)
            }
            )
            saveSettings()

        } else {
            self.settings?.regionNotifications = false
            self.locationLabel.text = "Any Location"
            saveSettings()
        }

    }

    @IBAction func locationUpdatesToggle(_ sender: UISwitch) {

        if sender.isOn {

            settings?.sound = "default.wav"
            saveSettings()

        } else {

            settings?.sound = "1"
            saveSettings()
        }

    }

    let defaults = UserDefaults.standard

    var startWorkTime = Date()
    var endWorkTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.flatPurple

        if settings?.regionNotifications == true {
            currentLocation = settings?.currentLocation
            var geocoder = CLGeocoder()
            locationSwitch.isOn = true
            geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, _) in
                let placemark = placemarks?.first
                self.locationLabel.text = placemark?.addressDictionary?["Street"] as! String?

            })
        }

        notificationMessage.setCustomDoneTarget(self, action: #selector(self.doneAction(_:)))
        // update notification message

        if (settings?.notificationMessage != "Why not take a break and walk around a little.") {
            notificationMessage.text = settings?.notificationMessage
        }

        if settings?.sound == nil || settings?.sound == " " {

            soundToggle.isOn = false
        } else {

            soundToggle.isOn = true
        }

        if settings?.regionNotifications == true {

            locationSwitch.isOn = true
        } else {
            self.locationLabel.text = "Any Location"
            locationSwitch.isOn = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        // self.deregisterFromKeyboardNotifications()
        saveSettings()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindWithSelectedTime(_ segue: UIStoryboardSegue) {

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if ( (indexPath.row == 0) && (indexPath.section == 4) ) {

            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients(["d7laungani@hotmail.com"])
        mailComposerVC.setSubject("Feedback for Standup 1.3 ")
        mailComposerVC.setMessageBody(" ", isHTML: false)

        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    // Used to temporarily hide location updates row
    //******************************************************************************************************************

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if (section == 0 ) {

            return 0.0

        }
        //keeps all other Headers unaltered
        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 0 ) {

            return 0.0

        }

        return super.tableView(tableView, heightForFooterInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 44.0
        if (indexPath.section == 0 ) {

            rowHeight = 0.0

        }

        if (indexPath.section == 1 ) {

            rowHeight = 88

        }

        return rowHeight
    }

   }

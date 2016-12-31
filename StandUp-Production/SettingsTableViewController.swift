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

class CustomCell: UITableViewCell {
    @IBOutlet weak var switchModule: UISwitch!
    
}

class SettingsTableViewController: UITableViewController,  MFMailComposeViewControllerDelegate {
    var permaScope = PermissionScope()
    
    @IBOutlet weak var locationUpdatesLabel: UILabel!
    
    @IBOutlet weak var sleepingTimes: UITableViewCell!
    
    @IBOutlet weak var locationUpdates: UITableViewCell!
    
    @IBOutlet weak var feedback: UITableViewCell!
    
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBAction func locationUpdatesToggle(_ sender: UISwitch) {
        permaScope.viewControllerForAlerts = self
        
        if sender.isOn {
            // turn on notifications
            if PermissionScope().statusLocationAlways() == PermissionStatus.authorized {
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                permaScope.requestLocationAlways()
                permaScope.onCancel = { results in
                    print("Request was cancelled with results \(results)")
                    sender.isOn = false
                }
                permaScope.onDisabledOrDenied = { results in
                    print("Request was denied or disabled with results \(results)")
                    sender.isOn = false
                }
                
                
                // Show dialog with callbacks
                permaScope.show({ finished, results in
                    print("got results \(results)")
                }, cancelled: { (results) -> Void in
                    print("thing was cancelled")
                })
                
                
                
            }
        } else {
            // turn off notifications
        }
        
    }
    
    
    
    let defaults = UserDefaults.standard
    
    var startWorkTime = Date()
    var endWorkTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.flatPurple
        
        locationUpdates.isHidden = true
        
        
        // self.setThemeUsingPrimaryColor(ContrastColorOf(UIColor.flatPurple, returnFlat: false), withSecondaryColor: UIColor.flatPurple, andContentStyle: .contrast)
        
        /*
         
         // Location Updates Cell
         
         locationUpdatesLabel.text = "Location Updates Enabled"
         
         
         let locationUpdatesSwitch = locationUpdates.contentView.viewWithTag(1) as! UISwitch
         if PermissionScope().statusLocationAlways() == PermissionStatus.authorized {
         
         locationUpdatesSwitch.isOn = true
         }
         
         
         locationUpdates.selectionStyle = UITableViewCellSelectionStyle.none
         
         
         // locationUpdates.taf
         
         */
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func unwindWithSelectedTime(_ segue:UIStoryboardSegue) {
        
        /*
         
         let rootVC = self.navigationController!.topViewController
         if rootVC!.isKindOfClass(WorkTimeViewController) {
         performSegueWithIdentifier("saveWorkTime", sender: self)
         }
         
         */
        
        if let workTimePickerViewController = segue.source as? WorkTimeViewController,
            
            let startWorkTime =  workTimePickerViewController.startWorkTime , let endWorkTime = workTimePickerViewController.endWorkTime {
            print("reached here")
            defaults.set(startWorkTime.date, forKey: "startWorkTimeDate")
            defaults.set(endWorkTime.date, forKey: "endWorkTimeDate")
            print(startWorkTime.date)
            print(endWorkTime.date)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if ( (indexPath.row == 0) && (indexPath.section == 3) ) {
            
            
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
        mailComposerVC.setSubject("Feedback for Standup 1.0 ")
        mailComposerVC.setMessageBody(" ", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Used to temporarily hide location updates row
    //******************************************************************************************************************
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            //header height for selected section
            return 0.1
        }
        
        //keeps all other Headers unaltered
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            //header height for selected section
            return 0.1
        }
        
        return super.tableView(tableView, heightForFooterInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0  {
            return ""
        }
        
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            return ""
        }
        
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 44.0
        if (indexPath.section == 0){
            
            if(indexPath.row == 0){
               rowHeight = 0.0
            }
        }
        return rowHeight
    }
    
     //******************************************************************************************************************
    // MARK: - Table view data source
    /*
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 4
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
     
     // Configure the cell...
     
     locationUpdates.textLabel?.text = "Location Updates Enabled1"
     
     return locationUpdates
     }
     
     
     
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

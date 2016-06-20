//
//  SettingsTableViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/18/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import PermissionScope

class CustomCell: UITableViewCell {
    @IBOutlet weak var switchModule: UISwitch!
    
}

class SettingsTableViewController: UITableViewController {
    var permaScope = PermissionScope()
    
    
    @IBOutlet weak var locationUpdatesLabel: UILabel!
    
    @IBOutlet weak var sleepingTimes: UITableViewCell!
    
    @IBOutlet weak var locationUpdates: UITableViewCell!

    @IBOutlet weak var feedback: UITableViewCell!
    
    @IBAction func locationUpdatesToggle(sender: UISwitch) {
        permaScope.viewControllerForAlerts = self
        
        if sender.on {
            // turn on notifications
            if PermissionScope().statusLocationAlways() == .Authorized {
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                permaScope.requestLocationAlways()
                permaScope.onCancel = { results in
                    print("Request was cancelled with results \(results)")
                    sender.on = false
                }
                permaScope.onDisabledOrDenied = { results in
                    print("Request was denied or disabled with results \(results)")
                    sender.on = false
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Location Updates Cell
        
        locationUpdatesLabel.text = "Location Updates enabled"
        
  
        let locationUpdatesSwitch = locationUpdates.contentView.viewWithTag(1) as! UISwitch
        if PermissionScope().statusLocationAlways() == .Authorized {
            
            locationUpdatesSwitch.on = true
        }
        
        
        
            
       // locationUpdates.taf

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

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

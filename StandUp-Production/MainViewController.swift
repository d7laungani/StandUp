//
//  FirstViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import CoreMotion
import PermissionScope

class MainViewController: UIViewController {
    
    let pscope = PermissionScope()
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var hoursSatLabel: UILabel!
    
    let activityManager = CMMotionActivityManager()
    
    let motionActivity = MotionActivity()
    
    let historyProcessor = HistoryProcessor()
    
    
    @IBAction func startUpdates(sender: AnyObject) {
        
        
        self.startRecordingActivity(activityManager)
        //historyProcessor.getTransitionPoints( motionActivity.getHistoricalData(activityManager) )
        /*
        MotionActivity.getHistoricalData(activityManager) { (activities, error) -> Void in
        if (error == nil) {
        
        let activities = self.historyProcessor.getTransitionPoints(activities)
        self.historyProcessor.calculateHoursSat(activities)
        }
        }
        */
        
        
    }
    
    @IBAction func stopUpdates(sender: AnyObject) {
        
        activityManager.stopActivityUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up permissions
       
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
            message: "We use this to help you live longer")
        pscope.addPermission(LocationAlwaysPermission(),
            message: "We use this to give you more accurate feedback")
        
        pscope.addPermission(MotionPermission(),
            message: "Past Data is important to determining progression")
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        
        hoursSatLabel.text = " "
        
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
        
        
        comps.hour = 6
        comps.minute = 0
        comps.second = 0
        
        
        
        let morningOfDay = cal.dateFromComponents(comps)!
        print(morningOfDay)
        
        
        
        MotionActivity.getHistoricalData(activityManager,fromDate: morningOfDay,tillDate: NSDate()) { (activities, error) -> Void in
            if ((error == nil)){
                
                
                self.historyProcessor.getTotalSittingSecs(activities)
                
                if let activities = self.historyProcessor.getTransitionPoints(activities){
                    let final = self.historyProcessor.calculateHoursSat(activities)
                     self.hoursSatLabel.text = String(final[0].1)
                }
                
                
                
                
            }
        }
        
        
    }

    
    
    func startRecordingActivity (activityManager: CMMotionActivityManager ) -> Void {
        
        
        
        if(CMMotionActivityManager.isActivityAvailable()){
            print("YES!")
            activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { data in
                if let data = data {
                    dispatch_async(dispatch_get_main_queue()) {
                        if(data.stationary == true){
                            self.activityLabel.text = "Stationary"
                            
                        } else if (data.walking == true){
                            self.activityLabel.text = "Walking"
                        } else if (data.running == true){
                            self.activityLabel.text = "Running"
                        } else if (data.automotive == true){
                            self.activityLabel.text = "Automotive"
                        } else if (data.unknown == true){
                            self.activityLabel.text = "Unknown"
                        }
                        
                    }
                }
            }
            
            
        }
    }
    
    
    
    
    
    
    
}


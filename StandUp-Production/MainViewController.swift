//
//  FirstViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {

    
    @IBOutlet weak var activityLabel: UILabel!
    
    
    let activityManager = CMMotionActivityManager()
    
    let motionActivity = MotionActivity()
    
    
    @IBAction func startUpdates(sender: AnyObject) {
        
        
        self.startRecordingActivity(activityManager)
        motionActivity.getHistoricalData(activityManager)
    
    }
    
    @IBAction func stopUpdates(sender: AnyObject) {
        
       activityManager.stopActivityUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
        print(fromDate)
        
        
        
        
        
        
        
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


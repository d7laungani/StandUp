//
//  FirstViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import CoreMotion


let defaults = UserDefaults.standard

let startTime = defaults.object(forKey: "startWorkTimeDate") as? Date ?? Date()

let endTime = defaults.object(forKey: "endWorkTimeDate") as? Date ?? Date()

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var hoursSatLabel: UILabel!
    
    let activityManager = CMMotionActivityManager()
    
    let motionActivity = MotionActivity()
    
    let historyProcessor = HistoryProcessor()
    
    
    @IBAction func startUpdates(_ sender: AnyObject) {
        
        
        self.startRecordingActivity(activityManager)
        
        
    }
    
    @IBAction func stopUpdates(_ sender: AnyObject) {
        
        activityManager.stopActivityUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        
        hoursSatLabel.text = " "
        
        let cal = Calendar.current
        var comps = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        
        comps.hour = 6
        comps.minute = 0
        comps.second = 0
        
        
        
        let morningOfDay = cal.date(from: comps)!
        print(morningOfDay)
        
        
        
        MotionActivity.getHistoricalData(activityManager,fromDate: startTime,tillDate: endTime) { (activities, error) -> Void in
            if ((error == nil)){
                
                
                
                
                if let final =  self.historyProcessor.getTotalSittingSecs(activities) {
                    
                    
                    self.hoursSatLabel.text = String(final[0].1)
                }
                
                
                
                
            }
        }
        
        
    }
    
    
    
    func startRecordingActivity (_ activityManager: CMMotionActivityManager ) -> Void {
        
        
        
        if(CMMotionActivityManager.isActivityAvailable()){
            print("YES!")
            activityManager.startActivityUpdates(to: OperationQueue.main) { data in
                if let data = data {
                    DispatchQueue.main.async {
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


//
//  MotionActivity.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation
import CoreMotion


class MotionActivity {
    
    var activityBeingViewed = false
    
    private var currentActivityString = "default"
    
    func midnightOfToday () -> NSDate {
        
        
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.systemTimeZone()
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.dateFromComponents(comps)!
        
        return midnightOfToday
        
        
    }
    
    
    
    func getHistoricalData(activityManager: CMMotionActivityManager ) -> Void {
        
        let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)

        
        activityManager.queryActivityStartingFromDate(fromDate, toDate: NSDate(), toQueue: NSOperationQueue.mainQueue()) { (data, error) -> Void in
            if (error == nil) {
                
                if let info = data! as? [CMMotionActivity] {
                    
                    print("Count of Acitivity information is \(info.count)")
                    
                    var count = 0
                    
                    
                    var transition = false
                    
                    var beforeTransitionDate : NSDate = NSDate()
                   
                    
                    
                    for x in info {
                        
                        print(x)
                        
                        if (x.confidence == .High) {
                            let minsFrom = abs(beforeTransitionDate.minutesFrom(x.startDate))
                            
                            if ( (x.stationary == true) && (transition == false) && (x.automotive == false) ){
                                //print(beforeTransitionDate.minutesFrom(x.startDate) < 1)
                                
                                if (!(minsFrom < 1)) {
                                    
                                    print("Stationary time is \(x.startDate) ")
                                    beforeTransitionDate = x.startDate
                                    transition = true
                                    
                                }
                            }
                            
                            else if ( (x.stationary == false) && (transition == true) ) {
                                
                                if (!(minsFrom < 1)) {
                                    print("Transition occured and movement has now occured")
                                    print(x.startDate)
                                    beforeTransitionDate = x.startDate
                                    transition = false
                                }
                            }
                        
                        }
                        
                       
                        
                       
                        
                    }
                    
                   
                }
                
                
                
            }
        }
        
        }
        
        
        
}
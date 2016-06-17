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
    
    
    var historyProcessor = HistoryProcessor()
    
    class func getHistoricalData(activityManager: CMMotionActivityManager, getHistCompletionHandler : (activities: [CMMotionActivity] , error: NSError? ) -> Void ){
        
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
       
        
        let fromDate = HistoryProcessor.findMidnightOfDay(NSDate(timeIntervalSinceNow: -86400 * 7 ) )
      let tillDate: NSDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!
        var activities = [CMMotionActivity]()
        
        //print("from date is \(fromDate)")
        //print("till date is \(tillDate)")
        
        activityManager.queryActivityStartingFromDate(fromDate, toDate: tillDate, toQueue: NSOperationQueue.mainQueue()) { (data, error) -> Void in
            if (error == nil) {
                
                if let info = data! as? [CMMotionActivity] {
                    
                    activities = info
                   
                }
                
                
                
            }
            
            getHistCompletionHandler(activities: activities, error: error )
        }
        
        
    
       
    }
        
        
        
}
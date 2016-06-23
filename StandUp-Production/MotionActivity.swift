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
    static let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    class func getHistoricalData(activityManager: CMMotionActivityManager,
        
        fromDate : NSDate = HistoryProcessor.findMidnightOfDay(NSDate(timeIntervalSinceNow: -86400 * 7 ) ),
        tillDate: NSDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!,
        getHistCompletionHandler : (activities: [CMMotionActivity] , error: NSError? ) -> Void ){
            
            var activities = [CMMotionActivity]()
            
            print("from date is \(fromDate)")
            print("till date is \(tillDate)")
            
            activityManager.queryActivityStartingFromDate(fromDate, toDate: tillDate, toQueue: NSOperationQueue.mainQueue()) { (data, error) -> Void in
                
                
                if (error == nil) {
                    
                    activities = data! as [CMMotionActivity]
                    
                    
                    
                }
                
                getHistCompletionHandler(activities: activities, error: error )
            }
            
            
            
            
    }
    
    enum activityError: ErrorType {
        
        case NoActivities
        
    }
    
    
    
}
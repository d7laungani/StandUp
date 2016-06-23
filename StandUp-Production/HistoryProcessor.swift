//
//  HistoryProcessor.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/16/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation
import CoreMotion

typealias MyTuple = (Int,Int)

class HistoryProcessor {
    
    
    
    static func findMidnightOfDay (date: NSDate) -> NSDate {
        
        
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        
        
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        comps.day = comps.day + 1
        
        
        let midnightOfDay = cal.dateFromComponents(comps)!
        
        
        
        return midnightOfDay
        
        
        
        
        
    }
    
    func getTotalSittingSecs (activities: [CMMotionActivity] )  -> [MyTuple]? {
        
        
        
        let cal = NSCalendar.currentCalendar()
        
        var secondsSat = [Int](count: 31, repeatedValue: 0)
        
        
        
        
        var previousPointDate : NSDate = NSDate()
        
        var totalSittingSecs = 0
        
        if (activities.count < 1) {
            
            return nil
        }
        
        var isMoving = true
        
        var secsFrom = 0
        for x in activities {
            
            
            
            
            let componentsOfCurrentDate = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: x.startDate)
            
            
            
            //print("Seconds difference is \(secondsDifference)")
            //print("Current Day is \(componentsOfCurrentDate.day)")
            
            
            
            if ( (x.confidence == .Medium) || (x.confidence == .High) ) {
                
                
                
                if ( ( (x.stationary == true) && (isMoving == true) ) || ( (x.automotive == true) && (isMoving == true) ) ){
                    
                    previousPointDate = x.startDate
                    isMoving = false
                    
                    
                }
                    
                else if ( (x.stationary == false || x.running == true || x.walking == true || x.cycling == true) && (isMoving == false) ) {
                    
                    
                    secsFrom = abs(previousPointDate.secondsFrom(x.startDate))
                    totalSittingSecs += secsFrom
                    secondsSat[componentsOfCurrentDate.day] = secondsSat[componentsOfCurrentDate.day] + secsFrom
                    
                    isMoving = true
                    
                }
                
            }
            
            
            
            
            
        }
        
        var hoursSat:[MyTuple] = []
        
        for(index, seconds)in secondsSat.enumerate() {
            
            
            if (seconds > 0) {
                
                let hours  = (seconds / (60 * 60))
                
                hoursSat.append((index, hours))
            }
            
            
            
        }
        print(hoursSat)
        
        
        //print(secondsSat)
        print(totalSittingSecs)
        return hoursSat
        
    }
    
    
    
    
    
    
    
    
}
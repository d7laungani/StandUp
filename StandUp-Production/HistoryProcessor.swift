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
    
    
    
    static func findMidnightOfDay (_ date: Date) -> Date {
        
        
        let cal = Calendar.current
        var comps = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date)
        
        
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        comps.day = comps.day! + 1
        
        
        let midnightOfDay = cal.date(from: comps)!
        
        
        
        return midnightOfDay
        
        
        
        
        
    }
    
    func getTotalSittingSecs (_ activities: [CMMotionActivity] )  -> [MyTuple]? {
        
        
        
        let cal = Calendar.current
        
        var secondsSat = [Int](repeating: 0, count: 31)
        
        
        
        
        var previousPointDate : Date = Date()
        
        var totalSittingSecs = 0
        
        if (activities.count < 1) {
            
            return nil
        }
        
        var isMoving = true
        
        var secsFrom = 0
        
        let componentsOfPreviousDate = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: previousPointDate)
        
        for x in activities {
            
            
            
            
            let componentsOfCurrentDate = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: x.startDate)
            
        
            
            
            if (componentsOfCurrentDate.hour! < 9 || componentsOfCurrentDate.hour! > 17) {
                if (componentsOfPreviousDate.day != componentsOfCurrentDate.day) {
                    
                    secsFrom = abs(previousPointDate.secondsFrom(x.startDate))
                    totalSittingSecs += secsFrom
                    secondsSat[componentsOfPreviousDate.day!] = secondsSat[componentsOfPreviousDate.day!] + secsFrom
                    
                    isMoving = true
                    
                }
                continue;
            }
            
            
            
            if ( (x.confidence == .medium) || (x.confidence == .high) ) {
                
                
                
                if ( ( (x.stationary == true) && (isMoving == true) ) || ( (x.automotive == true) && (isMoving == true) ) ){
                    
                    previousPointDate = x.startDate
                    isMoving = false
                    
                    
                }
                    
                else if ( (x.stationary == false || x.running == true || x.walking == true || x.cycling == true) && (isMoving == false) ) {
                    
                    
                    secsFrom = abs(previousPointDate.secondsFrom(x.startDate))
                    totalSittingSecs += secsFrom
                    secondsSat[componentsOfCurrentDate.day!] = secondsSat[componentsOfCurrentDate.day!] + secsFrom
                    
                    isMoving = true
                    
                }
                
            }
            
            
            
            
            
        }
        
        var hoursSat:[MyTuple] = []
        
        for(index, seconds)in secondsSat.enumerated() {
            
            
            if (seconds > 0 && seconds < 86400) {
                
                let hours  = (seconds / (60 * 60))
                
                hoursSat.append((index, hours))
            }
            
            
            
        }
        print(hoursSat)
        
     
      
        return hoursSat
        
    }
    
    
    
    
    
    
    
    
}

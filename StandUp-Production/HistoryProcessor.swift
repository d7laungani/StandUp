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
    
    
    
    func getTransitionPoints (activities: [CMMotionActivity] )  -> [NSDate:Int] {
        
        
        
        
        //print("Count of Acitivity information is \(activities.count)")
        
        var count = 0
        
        
        var transition = false
        
        var beforeTransitionDate : NSDate = NSDate()
        
        var transitionPoints: [NSDate:Int] = Dictionary()
        
        
        
        for x in activities {
            
            //print(x)
            
            if (x.confidence == .High) {
                let minsFrom = abs(beforeTransitionDate.minutesFrom(x.startDate))
                
                if ( (x.stationary == true) && (transition == false) && (x.automotive == false) ){
                    //print(beforeTransitionDate.minutesFrom(x.startDate) < 1)
                    
                    if (!(minsFrom < 1)) {
                        
                        //print("Stationary time is \(x.startDate) ")
                        beforeTransitionDate = x.startDate
                        transition = true
                        transitionPoints[x.startDate] = 1
                        
                    }
                }
                    
                else if ( (x.stationary == false) && (transition == true) ) {
                    
                    if (!(minsFrom < 1)) {
                        //print("Transition occured and movement has now occured")
                        // print(x.startDate)
                        beforeTransitionDate = x.startDate
                        transition = false
                        transitionPoints[ x.startDate] = 0
                    }
                }
                
            }
            
            
            
            
            
        }
        
        
        //let sortedDict = transitionPoints.sort { $0.0.secondsFrom($1.0) < 0 }
        
        
        return transitionPoints
        
        
        
        
    }
    
    func calculateHoursSat ( transitionPoints: [NSDate:Int]) -> [MyTuple] {
        
        let sortedDict = transitionPoints.sort { $0.0.secondsFrom($1.0) < 0 }
        
        let cal = NSCalendar.currentCalendar()
        
        var secondsSat = [Int](count: 31, repeatedValue: 0)
        
        var previousTransition = sortedDict[0]
        
        for x in sortedDict {
            
            
            
            let componentsOfCurrentDate = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: x.0)
            let componentsOfPreviousDate = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: previousTransition.0)
            
            //let secondsDifference = previousTransition.0.secondsFrom(x.0)
            let secondsDifference = x.0.secondsFrom(previousTransition.0)
            
            //print("Seconds difference is \(secondsDifference)")
            //print("Current Day is \(componentsOfCurrentDate.day)")
            
            if ( (secondsDifference > 1) && (previousTransition.1 == 1) ) {
                
                secondsSat[componentsOfCurrentDate.day] = secondsSat[componentsOfCurrentDate.day] + secondsDifference
                
                
            }
            
            previousTransition = x
            
            
        }
        
        
        var hoursSat:[MyTuple] = []
        
        for(index, seconds)in secondsSat.enumerate() {
            
            
            if (seconds > 0) {
                
                var hours  = (seconds / (60 * 60))
                
                hoursSat.append((index, hours))
            }
            
            
            
        }
        print(hoursSat)
        
        return hoursSat
        
    }
    
    
    
    
    
}
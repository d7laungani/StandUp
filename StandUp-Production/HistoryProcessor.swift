//
//  HistoryProcessor.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/16/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation
import CoreMotion
import SwiftDate
import SwiftyUserDefaults

typealias MyTuple = (Int, Int)

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

    func getTotalSittingSecs (_ activities: [CMMotionActivity] ) -> [MyTuple]? {

        let region = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.current)

        let startTime = DateInRegion(absoluteDate:  (Defaults[.settings]?.startTime)!, in: region)
        let endTime = DateInRegion(absoluteDate:  (Defaults[.settings]?.endTime)!, in: region)

        print(startTime)
        print(endTime)

        var startComponents = startTime.components

        var endComponents = endTime.components

        let cal = Calendar.current

        var secondsSat = [Int](repeating: 0, count: 32)

        var previousPointDate: Date = Calendar.current.date(byAdding: .minute, value: -1, to: activities[0].startDate)!

        var totalSittingSecs = 0

        if (activities.count < 1) {

            return nil
        }

        var isMoving = true

        var secsFrom = 0

        let componentsOfPreviousDate = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: previousPointDate)

        print(startComponents.hour)
        print(endComponents.hour)
        for x in activities {

            let componentsOfCurrentDate = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: x.startDate)

            // Deals with out of boundary values

            if (componentsOfCurrentDate.hour! < startComponents.hour! || componentsOfCurrentDate.hour! > endComponents.hour!) {

                // Deals with transition between days
                if (componentsOfPreviousDate.day != componentsOfCurrentDate.day) {

                    secsFrom = abs(previousPointDate.secondsFrom(x.startDate))
                    totalSittingSecs += secsFrom
                    secondsSat[componentsOfPreviousDate.day!] = secondsSat[componentsOfPreviousDate.day!] + secsFrom

                    isMoving = true

                }
                previousPointDate = x.startDate
                continue
            }

            // If it is in the correct time period

            if ( (x.confidence == .medium) || (x.confidence == .high) ) {

                // If not moving
                if ( ( (x.stationary == true) && (isMoving == true) ) || ( (x.automotive == true) && (isMoving == true) ) ) {

                    previousPointDate = x.startDate
                    isMoving = false

                }

                // If you are moving now then count how long you were sitting till then from the previous time

                else if ( (x.stationary == false || x.running == true || x.walking == true || x.cycling == true) && (isMoving == false) ) {

                    secsFrom = abs(previousPointDate.secondsFrom(x.startDate))
                    totalSittingSecs += secsFrom

                    secondsSat[componentsOfCurrentDate.day!] = secondsSat[componentsOfCurrentDate.day!] + secsFrom

                    isMoving = true

                }

            }

        }

        var hoursSat: [MyTuple] = []

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

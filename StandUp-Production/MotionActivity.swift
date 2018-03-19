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
    static let cal: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    class func getHistoricalData(_ activityManager: CMMotionActivityManager,

        fromDate: Date = HistoryProcessor.findMidnightOfDay(Date(timeIntervalSinceNow: -86400 * 7 ) ),
        tillDate: Date = (cal as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: Date(), options: NSCalendar.Options())!,
        getHistCompletionHandler : @escaping (_ activities: [CMMotionActivity], _ error: NSError? ) -> Void ) {

            var activities = [CMMotionActivity]()
           // print("activity date is form ")
            //print("from date is \(fromDate)")
           // print("till date is \(tillDate)")

            activityManager.queryActivityStarting(from: fromDate, to: tillDate, to: OperationQueue.main) { (data, error) -> Void in

                if (error == nil) {

                    activities = data! as [CMMotionActivity]

                }

                getHistCompletionHandler(activities, error as NSError? )
            }

    }

    enum activityError: Error {

        case noActivities

    }

}

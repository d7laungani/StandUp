
//
//  TimerSettings.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/26/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation


class TimerSettings: NSObject, NSCoding  {
    
    
    enum Days {
        
        
        case Mon
        case Tue
        case Wed
        case Thur
        case Fri
        case Sat
        case Sun
        
    }
    
    
    var daysEnabled = [Bool]()
    
    var notificationMessage: String? = "Why not take a break and walk around a little."
    
    var timerInterval = 45
    
    var sound : String? = " "
    
    var startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    
    var endTime: Date = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
    
    override init() {
        
        
        daysEnabled = Array(repeating: false, count: 5)
        
    }
    
    init( daysEnabled: [Bool], notificationMessage: String, timerInterval: Int, sound:String, startTime:Date, endTime:Date) {
        
        self.daysEnabled = daysEnabled
        self.notificationMessage = notificationMessage
        self.timerInterval = timerInterval
        self.sound = sound
        self.startTime = startTime
        self.endTime = endTime
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let daysEnabled = aDecoder.decodeObject(forKey: "daysEnabled") as! [Bool]
        let notificationMessage = aDecoder.decodeObject(forKey: "notificationMessage") as! String
        let timerInterval = aDecoder.decodeInteger(forKey: "timerInterval")
        let sound = aDecoder.decodeObject(forKey: "sound") as! String
        let startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
        let endTime = aDecoder.decodeObject(forKey: "endTime") as! Date
        
        self.init(daysEnabled: daysEnabled, notificationMessage: notificationMessage, timerInterval: timerInterval, sound: sound, startTime: startTime, endTime: endTime)
    
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(daysEnabled, forKey: "daysEnabled")
        aCoder.encode(notificationMessage, forKey: "notificationMessage")
        aCoder.encode(timerInterval, forKey: "timerInterval")
        aCoder.encode(sound, forKey: "sound")
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(endTime, forKey: "endTime")
        
    }
    
    
    
    
    
}

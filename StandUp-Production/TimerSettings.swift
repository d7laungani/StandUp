
//
//  TimerSettings.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/26/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation


class TimerSettings {
    
    
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
    
    init() {
        
        
        daysEnabled = Array(repeating: false, count: 5)
        
    }
    
    
    
    
    
    
}


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
    
    
    var daysEnabled = [Days]()
    
    var notificationMessage: String? = "Why not take a break and walk around a little."
    
    var timerInterval = 45
    
    var sound : String? = " "
    
    
    
    
    
    
}
//
//  WorkTimeViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/21/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import _10Clock

class WorkTimeViewController: UIViewController, TenClockDelegate {
    
    @IBOutlet weak var startWorkTime: UIDatePicker!
    @IBOutlet weak var endWorkTime: UIDatePicker!
    
    @IBOutlet var clock: TenClock!
    
    
     var settings = Defaults[.settings]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        let calendar = Calendar.current
    
        
        clock.delegate = self
            
        let date9h = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
        let date17h = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: Date())!
        
        
        
        if (settings?.startTime != date9h) {
            
            
            
            clock.endDate = (settings?.startTime)!
            
            
        } else {
            clock.startDate = date9h
            
        }
        
        if (settings?.endTime != date17h) {
           // print (settings?.endTime.debugDescription)
            /*
            var endComponents = DateComponents()
            
            endComponents.hour = Calendar.current.component(.hour, from: (clock.startDate))
            endComponents.minute = Calendar.current.component(.minute, from: (clock.startDate))
            print (endComponents.hour! - 12)
            clock.startDate = Calendar.current.date(bySettingHour: abs(endComponents.hour! - 12), minute: endComponents.minute!, second: 0, of:  Calendar.current.startOfDay(for: Date()))!
            
            print(clock.startDate.debugDescription)
           */
            
            clock.startDate = (settings?.endTime)!
            
        } else {
            
            clock.endDate = date17h
        }
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      
        settings?.startTime = clock.endDate
        settings?.endTime = clock.startDate
        
        saveSettings()
        
        //print("starting and ending times are:")
        //print(settings?.startTime)
        //print(settings?.endTime)
        
        
    }
    func setupUI() {
         self.view.backgroundColor = UIColor(red: CGFloat(31 / 255.0), green: CGFloat(61 / 255.0), blue: CGFloat(91 / 255.0), alpha: CGFloat(1.0))
        clock.numeralsColor = UIColor.white
       
        
        
    }
    func saveSettings () {
        Defaults[.settings]? = settings!
        Defaults.synchronize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    
    //Executed for every touch.
    func timesUpdated(_ clock:TenClock, startDate:Date,  endDate:Date  ) -> (){
        
        /*
        var startComponents = DateComponents()
        
        startComponents.hour = Calendar.current.component(.hour, from: (clock.endDate))
        startComponents.minute = Calendar.current.component(.minute, from: (clock.endDate))
        
        print(startComponents.hour!)
        print(startComponents.hour! - 12)
        
        
     
        var endComponents = DateComponents()
        
        endComponents.hour = Calendar.current.component(.hour, from: (clock.startDate))
        endComponents.minute = Calendar.current.component(.minute, from: (clock.startDate))
        
        print(endComponents.hour!)
        print(endComponents.hour! + 12)
        
        print (" ")
     
        print(clock.endDate)
        print(clock.startDate)
        
        print (" ")
        */
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}



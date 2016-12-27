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
        
        let calendar = Calendar.current
        let now: Date! = Date()
        
        clock.delegate = self
            
        let date9h = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let date17h = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now)!
        
        if (settings?.startTime != date9h) {
            
            clock.endDate  = (settings?.startTime)!
            
        } else {
            clock.endDate = date9h
            
        }
        
        if (settings?.endTime != date17h) {
            
            clock.startDate = (settings?.endTime)!
           
        } else {
            
            clock.startDate = date17h
        }
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        saveSettings()
        
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
        //...
        settings?.startTime = clock.endDate
        settings?.endTime = clock.startDate
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



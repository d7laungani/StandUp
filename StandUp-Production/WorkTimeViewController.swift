//
//  WorkTimeViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/21/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class WorkTimeViewController: UIViewController {
    
    @IBOutlet weak var startWorkTime: UIDatePicker!
    @IBOutlet weak var endWorkTime: UIDatePicker!
    
     var settings = Defaults[.settings]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = Calendar.current
        let now: Date! = Date()
        
        
            
        let date9h = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let date17h = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now)!
        
        startWorkTime.date = date9h
        endWorkTime.date = date17h
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Defaults[.settings] = settings
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func startTimeModified(_ sender: Any) {
        
        guard let datePicker = sender as? UIDatePicker else {
            return
        }
        
        // Remove seconds to ensure correct time
        
        let date = datePicker.date.removeSeconds()
        
        settings?.startTime = date
        
    }
    
    @IBAction func endTimeModified(_ sender: Any) {
        
        guard let datePicker = sender as? UIDatePicker else {
            return
        }
        
        // Remove seconds to ensure correct time
        
        let date = datePicker.date.removeSeconds()
        
        settings?.endTime = date
        
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

extension Date {
    
    func removeSeconds() -> Date{
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let fullMinuteDate = calendar.date(from: components)!
        
        return fullMinuteDate
        
    }
    
}

//
//  WorkTimeViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/21/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit

class WorkTimeViewController: UIViewController {
    
    @IBOutlet weak var startWorkTime: UIDatePicker!
    @IBOutlet weak var endWorkTime: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let now: NSDate! = NSDate()
        
        let date9h = calendar.dateBySettingHour(9, minute: 0, second: 0, ofDate: now, options: NSCalendarOptions.MatchFirst)!
        let date17h = calendar.dateBySettingHour(17, minute: 0, second: 0, ofDate: now, options: NSCalendarOptions.MatchFirst)!
        
        startWorkTime.date = date9h
        endWorkTime.date = date17h
        print("Current date is \(now)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

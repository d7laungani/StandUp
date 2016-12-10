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
        
        let calendar = Calendar.current
        let now: Date! = Date()
        
        
        //let date9h = calendar.Date(bySettingHour: 9,minute:0,second:0, of: Calendar.Options.matchFirst)
        
        //public func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date, matchingPolicy: Calendar.MatchingPolicy = default, repeatedTimePolicy: Calendar.RepeatedTimePolicy = default, direction: Calendar.SearchDirection = default) -> Date?

        
        let date9h = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let date17h = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now)!
        
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

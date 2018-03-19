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
import SwiftDate

class WorkTimeViewController: UIViewController, TenClockDelegate {

    @IBOutlet weak var startWorkTime: UIDatePicker!
    @IBOutlet weak var endWorkTime: UIDatePicker!
    @IBOutlet var clock: TenClock!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    var settings = Defaults[.settings]

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        print("Hello")
        let calendar = Calendar.current
        clock.delegate = self

        var cmp = DateComponents()
        cmp.timeZone = TimeZone.current
        cmp.calendar = Calendar.current
        cmp.calendar?.locale = Locale.current
        cmp.year = Calendar.current.component(.year, from: Date())
        cmp.month = Calendar.current.component(.month, from: Date())
        cmp.day = Calendar.current.component(.day, from: Date())
        cmp.hour = 9
        let date9h = try DateInRegion(components: cmp)
        cmp.hour = 17
        let date17h = try DateInRegion(components: cmp)

        if (settings?.startTime != date9h?.absoluteDate) {

            clock.startDate = (  settings?.startTime)!

        } else {

            clock.startDate = (date9h?.absoluteDate)!

        }

        if (settings?.endTime != date17h?.absoluteDate) {

            clock.endDate = (  settings?.endTime)!

        } else {

            clock.endDate = (date17h?.absoluteDate)!
        }

        //Intial Update From, To Label
        let startDate = try DateInRegion(absoluteDate:  clock.startDate)
        let parsed = startDate.string(dateStyle: .short, timeStyle: .short)
        startTimeLabel.text = parsed.components(separatedBy: ",")[1]
        let endDate = try DateInRegion(absoluteDate:  clock.endDate)
        let parsed1 = endDate.string(dateStyle: .short, timeStyle: .short)
        endTimeLabel.text = parsed1.components(separatedBy: ",")[1]

    }

    override func viewWillDisappear(_ animated: Bool) {

        var cmp = DateComponents()
        cmp.timeZone = TimeZone.current
        cmp.calendar = Calendar.current
        cmp.calendar?.locale = Locale.current
        cmp.year = Calendar.current.component(.year, from: Date())
        cmp.month = Calendar.current.component(.month, from: Date())
        cmp.day = Calendar.current.component(.day, from: Date())

        cmp.hour = Calendar.current.component(.hour, from: clock.startDate)
        cmp.minute = Calendar.current.component(.minute, from: clock.startDate)

        let startDate = try DateInRegion(components: cmp)

        cmp.hour = Calendar.current.component(.hour, from: clock.endDate)
        cmp.minute = Calendar.current.component(.minute, from: clock.endDate)

        let endDate = try DateInRegion(components: cmp)

        settings?.startTime = (startDate?.absoluteDate)!
        settings?.endTime = (endDate?.absoluteDate)!
        saveSettings()

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
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date  ) {

        let startDate = try DateInRegion(absoluteDate: startDate)
        let parsed = startDate.string(dateStyle: .short, timeStyle: .short)
        startTimeLabel.text = parsed.components(separatedBy: ",")[1]
        let endDate = try DateInRegion(absoluteDate: endDate)
        let parsed1 = endDate.string(dateStyle: .short, timeStyle: .short)
        endTimeLabel.text = parsed1.components(separatedBy: ",")[1]
        let region = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.current)
        if (startDate.hour > endDate.hour) {
            clock.endDate = (try DateInRegion(components: [ .hour: 23, .minute: 55, .second: 0], fromRegion: region)?.absoluteDate)!

        }
    }

}

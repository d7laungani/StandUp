//
//  SecondViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import CoreMotion
import PermissionScope
import ScrollableGraphView

class HistoryViewController: UIViewController {

    let pscope = PermissionScope()
    let activityManager = CMMotionActivityManager()
    let motionActivity = MotionActivity()
    let historyProcessor = HistoryProcessor()

    @IBOutlet weak var timerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if (pscope.statusMotion() != .unauthorized) {

            setGraph()
        } else {

            pscope.addPermission(MotionPermission(),
                                 message: "Past Data is important to determining progression")

            // Show dialog with callbacks
            pscope.show({ _, _ in
                self.setGraph()
            }, cancelled: { (_) -> Void in
                print("thing was cancelled")
            })

        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon

        if (pscope.statusMotion() == .authorized) {
            setGraph()
        }

    }

    func setGraph () {
       
        MotionActivity.getHistoricalData(activityManager) { (activities, error) -> Void in

            if (error == nil) {

                if let final = self.historyProcessor.getTotalSittingSecs(activities) {

                    let days: [String] = self.processDataForBarChart(final)
                    let values: [Double] = self.processDataForBarChart(final)

                    let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
                    let graphView = ScrollableGraphView(frame: frame)

                    let max = values.max()! + 1
                    
                    graphView.rangeMax = max
                    self.setupchartUI(graphView: graphView)
                    graphView.set(data: values, withLabels: days)

                    self.view.addSubview(graphView)

                }
            }
        }
        
    }

    func setupchartUI (graphView: ScrollableGraphView) {
       
        graphView.backgroundFillColor = UIColor.hexStringToUIColor(hex: "#333333")

        graphView.lineWidth = 1
        graphView.lineColor = UIColor.hexStringToUIColor(hex: "#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.smooth

        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.gradient
        graphView.fillColor = UIColor.hexStringToUIColor(hex: "#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.linear
        graphView.fillGradientStartColor = UIColor.hexStringToUIColor(hex: "#555555")
        graphView.fillGradientEndColor = UIColor.hexStringToUIColor(hex: "#444444")

        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.white

        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

    }

    func processDataForBarChart(_ data: [MyTuple]) -> [String] {

        var days: [String] = []

        let cal = Calendar.current

        let formatter = DateFormatter()

        formatter.dateFormat = "EEE"

        for (day, _) in data {

            var comps = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: Date())
            comps.day = day

            let dayDate = cal.date(from: comps)!

            days.append(formatter.string(from: dayDate))

        }

        return days

    }

    func processDataForBarChart(_ data: [MyTuple]) -> [Double] {

        var values: [Double] = []

        for (_, value) in data {

            values.append(Double(value))

        }

        return values

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

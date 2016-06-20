//
//  SecondViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import Charts
import CoreMotion
import PermissionScope

class HistoryViewController: UIViewController {
    
    let pscope = PermissionScope()
    
    let activityManager = CMMotionActivityManager()
    
    let motionActivity = MotionActivity()
    
    let historyProcessor = HistoryProcessor()
    
    
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pscope.addPermission(MotionPermission(),
            message: "Past Data is important to determining progression")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        barChartView.clear()
        
        barChartView.noDataText = "Data is not accessible at the moment"
        MotionActivity.getHistoricalData(activityManager) { (activities, error) -> Void in
            if (error == nil) {
                
                //self.historyProcessor.getTotalSittingSecs(activities)

                
                if let final = self.historyProcessor.getTotalSittingSecs(activities) {
                    
                    
                    let days: [String] = self.processDataForBarChart(final)
                    let values: [Double] = self.processDataForBarChart(final)
                    self.setChart(days, values: values)
                }
            }
        }

        
        
    }
    
    func processDataForBarChart(data: [MyTuple]) -> [String] {
        
        var days:[String] = []
        
        let cal = NSCalendar.currentCalendar()
        
        let formatter = NSDateFormatter()
       

        formatter.dateFormat = "EEE"
        
        for (day, _) in data {
            
            let comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
             comps.day = day
            
            let dayDate = cal.dateFromComponents(comps)!
                
            days.append(formatter.stringFromDate(dayDate))
            
        }
        
        return days
        
    }
    
    func processDataForBarChart(data: [MyTuple]) -> [Double]  {
        
        var values:[Double] = []
        
        for (_, value) in data {
            
            
            values.append(Double(value))
            
        }
        
        return values
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Hours Sat")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        
        
        // Bar Chart COnfiguration
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        //barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        
        
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        
        barChartView.animate(xAxisDuration: 0.7, yAxisDuration: 1.5)
        
    }
    
    
}


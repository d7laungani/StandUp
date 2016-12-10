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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        barChartView.clear()
        
        barChartView.noDataText = "Data is loading up"
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
    
    func processDataForBarChart(_ data: [MyTuple]) -> [String] {
        
        var days:[String] = []
        
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
    
    func processDataForBarChart(_ data: [MyTuple]) -> [Double]  {
        
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
    
    
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        
        
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
           // let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            //dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Hours Spent Sitting")
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        
        
        // Bar Chart COnfiguration
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        //barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        barChartView.leftAxis.labelPosition = .outsideChart
        
        
        barChartView.descriptionText = " "
        barChartView.animate(xAxisDuration: 0.7, yAxisDuration: 1.5)
        
    }
    
    
}


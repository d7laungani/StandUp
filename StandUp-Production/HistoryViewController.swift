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

class HistoryViewController: UIViewController {
    
    
    let activityManager = CMMotionActivityManager()
    
    let motionActivity = MotionActivity()
    
    let historyProcessor = HistoryProcessor()

    @IBOutlet weak var barChartView: BarChartView!
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            MotionActivity.getHistoricalData(activityManager) { (activities, error) -> Void in
                if (error == nil) {
                    
                    let activities = self.historyProcessor.getTransitionPoints(activities)
                    let final = self.historyProcessor.calculateHoursSat(activities)
                    
                    let days: [String] = self.processDataForBarChart(final)
                    let values: [Double] = self.processDataForBarChart(final)
                    self.setChart(days, values: values)
                }
            }
     
            
        
        
       
                    
            
    }
    
    func processDataForBarChart(data: [MyTuple]) -> [String] {
        
        var days:[String] = []
        
        for (day, _) in data {
            
            
            days.append(String(day))
            
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
        barChartView.noDataText = "You need to provide data for the chart."
        
        
    
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
        
        
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 2.3)
        
    }


}


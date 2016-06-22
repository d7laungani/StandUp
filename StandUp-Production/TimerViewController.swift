//
//  TimerViewController.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController: UIViewController {
    
    
    
    
    let step: Float = 5
    @IBOutlet var daysButtons: [UIButton]!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    
    @IBAction func timeIntervalSlider(sender: UISlider) {
        
        
        
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        let s: Int = 00
        let m: Int = Int(roundedValue)
        
        let formattedDuration = String(format: "%0d:%02d", m, s)
        
        intervalLabel.text = formattedDuration
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        
        
    }
    
    func setupUIElements () {
        
        
        for button in daysButtons {
           
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1.1
            button.layer.borderColor = UIColor.blueColor().CGColor
            
            
        }
        
        
    }

    
    
}

//
//  SKStoreReviewManager.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 7/1/17.
//  Copyright © 2017 Devesh Laungani. All rights reserved.
//


import StoreKit

struct SKStoreReviewManager {
    
    private static let APP_RUNS_KEY = "APP_RUNS"
    
    static func incrementAppRuns() {
        let defaults = UserDefaults.standard
        var appRuns = defaults.value(forKey: APP_RUNS_KEY) as? Int ?? 0
        print(appRuns)
        appRuns += 1
        defaults.set(appRuns, forKey: APP_RUNS_KEY)
    }
    
    static func askForReview() {
        let defaults = UserDefaults.standard
        let appRuns = defaults.value(forKey: APP_RUNS_KEY) as? Int ?? 0
        
        if #available(iOS 10.3, *) {
            if appRuns > 0 && appRuns % 8 == 0 {
                SKStoreReviewController.requestReview()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

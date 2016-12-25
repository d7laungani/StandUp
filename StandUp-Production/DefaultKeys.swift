//
//  DefaultKeys.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 12/24/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation

extension UserDefaults {
    subscript(key: DefaultsKey<TimerSettings?>) -> TimerSettings? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

extension DefaultsKeys {
    static let settings = DefaultsKey<TimerSettings?>("settings")
}

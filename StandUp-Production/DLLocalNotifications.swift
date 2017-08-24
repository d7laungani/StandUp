//
//  DLLocalNotifications.swift
//  DLLocalNotifications
//
//  Created by Devesh Laungani on 12/14/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation
import UserNotifications
import MapKit
import SwiftDate

let MAX_ALLOWED_NOTIFICATIONS = 64

@available(iOS 10.0, *)
public class DLNotificationScheduler {
    
    // Apple allows you to only schedule 64 notifications at a time
    static let maximumScheduledNotifications = 60
    
    public init () {
        
    }
    
    public func cancelAlllNotifications () {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        DLQueue.queue.clear()
        saveQueue()
        
    }
    
    public func cancelNotification (notification: DLNotification) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(notification.localNotificationRequest?.identifier)!])
    }
    
    func printAllNotifications () {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            print(requests.count)
            for request  in  requests {
                if let request1 =  request.trigger as?  UNTimeIntervalNotificationTrigger {
                    print("Timer interval notificaiton: \(request1.nextTriggerDate().debugDescription)")
                }
                if let request2 =  request.trigger as?  UNCalendarNotificationTrigger {
                    print("Repeating notification: \(request2.nextTriggerDate().debugDescription)")
                }
                if let request3 = request.trigger as? UNLocationNotificationTrigger {
                    
                    print("Location notification: \(request3.region.debugDescription)")
                }
            }
        })
    }
    
    private func convertToNotificationDateComponent (notification: DLNotification, repeatInterval: Repeats   ) -> DateComponents {
        
        var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, ], from: notification.fireDate!)
        
        if repeatInterval != .None {
            
            switch repeatInterval {
            case .Minute:
                newComponents = Calendar.current.dateComponents([ .second], from: notification.fireDate!)
            case .Hourly:
                newComponents = Calendar.current.dateComponents([ .minute], from: notification.fireDate!)
            case .Daily:
                newComponents = Calendar.current.dateComponents([.hour, .minute], from: notification.fireDate!)
            case .Weekly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .weekday], from: notification.fireDate!)
            case .Monthly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day], from: notification.fireDate!)
            case .Yearly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: notification.fireDate!)
            default:
                break
            }
        }
        
        return newComponents
    }
    
    func queueNotification (notification: DLNotification) -> String? {
        
        if notification.scheduled {
            return nil
        } else {
            
            DLQueue.queue.push(notification)
            
        }
        return notification.identifier
    }
    
    func scheduleAllNotifications () {
        
        let queue = DLQueue.queue.notificationsQueue()
        let region = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.current)
        
        var count = 0
        //print(queue.count)
        for note in queue {
            
            if count < min(DLNotificationScheduler.maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) {
                let popped = DLQueue.queue.pop()
                var startTime = DateInRegion(absoluteDate:  popped.fireDate!, in: region)
                print("Notification \(count) scheduled and fire time will be: \(startTime)")
                scheduleNotification(notification: popped)
                count += 1
            } else { break }
            
        }
        // self.printAllNotifications()
    }
    
    fileprivate func scheduleNotification ( notification: DLNotification) -> String? {
        
        if notification.scheduled {
            return nil
        } else {
            
            var trigger: UNNotificationTrigger
            
            if (notification.region != nil) {
                trigger = UNLocationNotificationTrigger(region: notification.region!, repeats: false)
                if (notification.repeatInterval == .Hourly) {
                    trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: (TimeInterval(3600)), repeats: false)
                    
                }
                
            } else {
                
                trigger = UNCalendarNotificationTrigger(dateMatching: convertToNotificationDateComponent(notification: notification, repeatInterval: notification.repeatInterval), repeats: notification.repeats)
                if (notification.repeatInterval == .Hourly) {
                    trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: (TimeInterval(3600)), repeats: false)
                    
                }
                
            }
            let content = UNMutableNotificationContent()
            
            content.title = notification.alertTitle!
            
            content.body = notification.alertBody!
            
            content.sound = (notification.soundName == " ") ? UNNotificationSound.default() : UNNotificationSound.init(named: notification.soundName!)
            
            if (notification.soundName == "1") { content.sound = nil}
            
            if !(notification.attachments == nil) { content.attachments = notification.attachments! }
            
            if !(notification.launchImageName == nil) { content.launchImageName = notification.launchImageName! }
            
            if !(notification.category == nil) { content.categoryIdentifier = notification.category! }
            
            notification.localNotificationRequest = UNNotificationRequest(identifier: notification.identifier!, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(notification.localNotificationRequest!, withCompletionHandler: {(_) in print ("completed") })
            
            notification.scheduled = true
        }
        /*
         // Takes care of case of removing notificaiton form queue to reschedule in future
         
         else if notification.hasDataFromBefore  {
         
         let center = UNUserNotificationCenter.current()
         
         self.scheduledCount(completion: { (count) in
         print(count)
         if count >= min(DLNotificationScheduler.maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) {
         DLNotificationScheduler.farthestLocalNotification(completion: { farnotification in
         if let farthestNotification = farnotification {
         if !(farthestNotification < notification) {
         farthestNotification.cancel()
         DLQueue.queue.push(farthestNotification)
         notification.scheduled = true
         center.add(notification.localNotificationRequest!, withCompletionHandler: {(error) in print ("removed farthestNotificaiton and added less far notification") } )
         } else {
         DLQueue.queue.push(notification)
         print("added a notification to the queue")
         }
         }
         
         })
         
         
         
         
         } else {
         
         center.add(notification.localNotificationRequest!, withCompletionHandler: {(error) in print ("completed") } )
         
         notification.scheduled = true
         
         
         }
         
         
         })
         return notification.identifier
         }
         
         
         else {
         var trigger: UNNotificationTrigger
         
         
         
         if (notification.region != nil) {
         trigger = UNLocationNotificationTrigger(region: notification.region!, repeats: false)
         if (notification.repeatInterval == .Hourly) {
         trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: (TimeInterval(3600)), repeats: false)
         
         }
         
         } else{
         
         trigger = UNCalendarNotificationTrigger(dateMatching: convertToNotificationDateComponent(notification: notification, repeatInterval: notification.repeatInterval), repeats: notification.repeats)
         if (notification.repeatInterval == .Hourly) {
         trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: (TimeInterval(3600)), repeats: false)
         
         }
         
         }
         let content = UNMutableNotificationContent()
         
         content.title = notification.alertTitle!
         
         content.body = notification.alertBody!
         
         content.sound = (notification.soundName == nil) ? UNNotificationSound.default() : UNNotificationSound.init(named: notification.soundName!)
         
         if !(notification.attachments == nil){ content.attachments = notification.attachments! }
         
         if !(notification.launchImageName == nil){ content.launchImageName = notification.launchImageName! }
         
         if !(notification.category == nil){ content.categoryIdentifier = notification.category! }
         
         notification.localNotificationRequest = UNNotificationRequest(identifier: notification.identifier!, content: content, trigger: trigger)
         let center = UNUserNotificationCenter.current()
         
         self.scheduledCount(completion: { (count) in
         if count >= min(DLNotificationScheduler.maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) {
         DLNotificationScheduler.farthestLocalNotification(completion: { farnotification in
         if let farthestNotification = farnotification {
         if !(farthestNotification < notification) {
         farthestNotification.cancel()
         DLQueue.queue.push(farthestNotification)
         notification.scheduled = true
         center.add(notification.localNotificationRequest!, withCompletionHandler: {(error) in print ("removed farthestNotificaiton and added less far notification") } )
         } else {
         DLQueue.queue.push(notification)
         print("added a notification to the queue")
         }
         }
         
         })
         
         
         
         
         } else {
         
         center.add(notification.localNotificationRequest!, withCompletionHandler: {(error) in print ("completed") } )
         
         notification.scheduled = true
         
         
         }
         
         
         })
         
         }
         
         */
        return notification.identifier
        
    }
    ///- returns: DLNotification of the farthest UILocalNotification (last to be fired).
    class func farthestLocalNotification(completion: @escaping (DLNotification?) -> Void) {
        
        var notification: DLNotification? = nil
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (localNotifications) in
            if let localNotification =  localNotifications.last {
                
                notification =  notificationWithUILocalNotification(localNotification)
                completion(notification!)
            }
            completion(notification)
        })
        
    }
    
    ///Persists the notifications queue to the disk
    ///> Call this method whenever you need to save changes done to the queue and/or before terminating the app.
    func saveQueue() -> Bool {
        return DLQueue.queue.save()
    }
    ///- returns: Count of scheduled UILocalNotification by iOS.
    func scheduledCount(completion: @escaping (Int) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (localNotifications) in
            completion(localNotifications.count)
        })
        
    }
    
    ///Instantiates an DLNotification from a UILocalNotification.
    ///- parameter localNotification: The UILocalNotification to instantiate an ABNotification from.
    ///- returns: The instantiated ABNotification from the UILocalNotification.
    class func notificationWithUILocalNotification(_ localNotification: UNNotificationRequest) -> DLNotification {
        return DLNotification(request: localNotification)
    }
    
    // You have to manually keep in mind ios 64 notification limit
    
    public func repeatsFromToDate (identifier: String, alertTitle: String, alertBody: String, fromDate: Date, toDate: Date, interval: Double, repeats: Repeats, category: String = " ", sound: String = " ") {
        
        let notification = DLNotification(identifier: identifier, alertTitle: alertTitle, alertBody: alertBody, date: fromDate, repeats: repeats)
        notification.category = category
        notification.soundName = sound
        // Create multiple Notifications
        
        self.queueNotification(notification: notification)
        let intervalDifference = Int( toDate.timeIntervalSince(fromDate) / interval )
        
        var nextDate = fromDate
        
        let region = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.current)
        
        var startTime = DateInRegion(absoluteDate:  nextDate, in: region)
        // print(startTime)
        
        for i in 0..<intervalDifference {
            
            // Next notification Date
            
            nextDate = nextDate.addingTimeInterval(interval)
            startTime = DateInRegion(absoluteDate:  nextDate, in: region)
            // print(startTime)
            // create notification
            
            let identifier = identifier + String(i + 1)
            
            let notification = DLNotification(identifier: identifier, alertTitle: alertTitle, alertBody: alertBody, date: nextDate, repeats: repeats)
            notification.category = category
            notification.soundName = sound
            self.queueNotification(notification: notification)
        }
        
    }
    
    public func scheduleCategories(categories: [DLCategory]) {
        
        var categories1 = Set<UNNotificationCategory>()
        
        for x in categories {
            
            categories1.insert(x.categoryInstance!)
        }
        UNUserNotificationCenter.current().setNotificationCategories(categories1)
        
    }
    
}

// Repeating Interval Times

public enum Repeats: String {
    case None, Minute, Hourly, Daily, Weekly, Monthly, Yearly
}

// A wrapper class for creating a Category
@available(iOS 10.0, *)
public class DLCategory {
    
    private var actions: [UNNotificationAction]?
    internal var categoryInstance: UNNotificationCategory?
    var identifier: String
    
    public init (categoryIdentifier: String) {
        
        identifier = categoryIdentifier
        actions = [UNNotificationAction] ()
        
    }
    
    public func addActionButton(identifier: String?, title: String?) {
        
        let action = UNNotificationAction(identifier: identifier!, title: title!, options: [])
        actions?.append(action)
        categoryInstance = UNNotificationCategory(identifier: self.identifier, actions: self.actions!, intentIdentifiers: [], options: [])
        
    }
    
}

// A wrapper class for creating a User Notification

@available(iOS 10.0, *)
public class DLNotification {
    
    internal var localNotificationRequest: UNNotificationRequest?
    
    var repeatInterval: Repeats = .None
    
    var alertBody: String?
    
    var alertTitle: String?
    
    var soundName: String?
    
    var fireDate: Date?
    
    var repeats: Bool = false
    
    var scheduled: Bool = false
    
    var identifier: String?
    
    var attachments: [UNNotificationAttachment]?
    
    var launchImageName: String?
    
    public var category: String?
    
    var region: CLRegion?
    
    var hasDataFromBefore = false
    
    public init(request: UNNotificationRequest) {
        
        self.hasDataFromBefore = true
        self.localNotificationRequest = request
        if let calendarTrigger =  request.trigger as? UNCalendarNotificationTrigger {
            
            self.fireDate = calendarTrigger.nextTriggerDate()
        } else if let  intervalTrigger =  request.trigger as? UNTimeIntervalNotificationTrigger {
            
            self.fireDate = intervalTrigger.nextTriggerDate()
        }
    }
    
    public init (identifier: String, alertTitle: String, alertBody: String, date: Date?, repeats: Repeats ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.fireDate = date
        self.repeatInterval = repeats
        self.identifier = identifier
        if (repeats == .None) {
            self.repeats = false
        } else {
            self.repeats = true
        }
        
    }
    
    public init (identifier: String, alertTitle: String, alertBody: String, date: Date?, repeats: Repeats, soundName: String ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.fireDate = date
        self.repeatInterval = repeats
        self.soundName = soundName
        self.identifier = identifier
        
        if (repeats == .None) {
            self.repeats = false
        } else {
            self.repeats = true
        }
        
    }
    
    // Region based notification
    // Default notifyOnExit is false and notifyOnEntry is true
    
    public init (identifier: String, alertTitle: String, alertBody: String, region: CLRegion? ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.identifier = identifier
        region?.notifyOnExit = false
        region?.notifyOnEntry = true
        self.region = region
        
    }
    
    ///Cancels the notification if scheduled or queued.
    func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(self.localNotificationRequest?.identifier)!])
        let queue = DLQueue.queue.notificationsQueue()
        var i = 0
        for note in queue {
            if self.identifier == note.identifier {
                DLQueue.queue.removeAtIndex(i)
                break
            }
            i += 1
        }
        scheduled = false
    }
    
}
@available(iOS 10.0, *)
public func <(lhs: DLNotification, rhs: DLNotification) -> Bool {
    return lhs.fireDate?.compare(rhs.fireDate!) == ComparisonResult.orderedAscending
}
@available(iOS 10.0, *)
public func ==(lhs: DLNotification, rhs: DLNotification) -> Bool {
    return lhs.identifier == rhs.identifier
}


@available(iOS 10.0, *)
private class DLQueue: NSObject {
    
    fileprivate var notifQueue = [DLNotification]()
    static let queue = DLQueue()
    let ArchiveURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("notifications.dlqueue")
    
    override init() {
        super.init()
        if let notificationQueue = self.load() {
            notifQueue = notificationQueue
        }
    }
    
    fileprivate func push(_ notification: DLNotification) {
        notifQueue.insert(notification, at: findInsertionPoint(notification))
    }
    
    /// Finds the position at which the new DLNotification is inserted in the queue.
    /// - seealso: [swift-algorithm-club](https://github.com/hollance/swift-algorithm-club/tree/master/Ordered%20Array)
    fileprivate func findInsertionPoint(_ notification: DLNotification) -> Int {
        let range = 0..<notifQueue.count
        var rangeLowerBound = range.lowerBound
        var rangeUpperBound = range.upperBound
        
        while rangeLowerBound < rangeUpperBound {
            let midIndex = rangeLowerBound + (rangeUpperBound - rangeLowerBound) / 2
            if notifQueue[midIndex] == notification {
                return midIndex
            } else if notifQueue[midIndex] < notification {
                rangeLowerBound = midIndex + 1
            } else {
                rangeUpperBound = midIndex
            }
        }
        return rangeLowerBound
    }
    
    ///Removes and returns the head of the queue.
    ///- returns: The head of the queue.
    fileprivate func pop() -> DLNotification {
        return notifQueue.removeFirst()
    }
    
    ///- returns: The head of the queue.
    fileprivate func peek() -> DLNotification? {
        return notifQueue.last
    }
    
    ///Clears the queue.
    fileprivate func clear() {
        notifQueue.removeAll()
    }
    
    ///Called when an ABNotification is cancelled.
    ///- parameter index: Index of ABNotification to remove.
    fileprivate func removeAtIndex(_ index: Int) {
        notifQueue.remove(at: index)
    }
    
    ///- returns: Count of ABNotification in the queue.
    fileprivate func count() -> Int {
        return notifQueue.count
    }
    
    ///- returns: The notifications queue.
    fileprivate func notificationsQueue() -> [DLNotification] {
        let queue = notifQueue
        return queue
    }
    
    ///- parameter identifier: Identifier of the notification to return.
    ///- returns: ABNotification if found, nil otherwise.
    fileprivate func notificationWithIdentifier(_ identifier: String) -> DLNotification? {
        for note in notifQueue {
            if note.identifier == identifier {
                return note
            }
        }
        return nil
    }
    
    // MARK: NSCoding
    
    ///Save queue on disk.
    ///- returns: The success of the saving operation.
    fileprivate func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self.notifQueue, toFile: ArchiveURL.path)
    }
    
    ///Load queue from disk.
    ///Called first when instantiating the ABNQueue singleton.
    ///You do not need to manually call this method and therefore do not declare it as public.
    fileprivate func load() -> [DLNotification]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [DLNotification]
    }
    
}

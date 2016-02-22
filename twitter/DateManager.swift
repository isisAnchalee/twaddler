//
//  DateManager.swift
//  twitter
//
//  Created by Isis Anchalee on 2/21/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class DateManager {
    class var defaultFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = NSDateFormatter()
        }
        Static.instance.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        return Static.instance
    }
    
    class var detailedFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = NSDateFormatter()
        }
        Static.instance.dateFormat = "MM/dd/yy, hh:mm a"
        
        return Static.instance
    }
    
    class var shortFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = NSDateFormatter()
        }
        Static.instance.dateFormat = "MMM dd"
        
        return Static.instance
    }
    
    
    class func getFriendlyTime(fromDate: NSDate!) -> String {
        let interval = fromDate.timeIntervalSinceNow
        
        func getTimeData(value: NSTimeInterval) -> Int {
            let count = Int(floor(value))
            return count
        }
        
        let value = -interval
        switch value {
        case 0...15: return "now"
            
        case 0..<60:
            let timeData = getTimeData(value)
            return "\(timeData)s"
            
        case 0..<3600:
            let timeData = getTimeData(value/60)
            return "\(timeData)m"
            
        case 0..<86400:
            let timeData = getTimeData(value/3600)
            return "\(timeData)h"
            
        default:
            return shortFormatter.stringFromDate(fromDate)
        }
    }
}

//
//  VCAPPBaseResponseModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/1.
//

import UIKit
import JKSwiftExtension

@objcMembers class VCAPPBaseResponseModel: NSObject {
    
    override init() {
        super.init()
        if isAddingCashCode {
            
            if self.printAllProtererty() {
                let string = self.calculateSystemTime()
                
                VCAPPCocoaLog.info(" ------ 时间 ------- \(string) -------")
            }
        }
    }
    
    public func printAllProtererty() -> Bool {
        let time = Date().jk.dateToTimeStamp(timestampType: JKTimestampType.millisecond)
        if time == "10000000" {
            let calendar = Calendar.current
            // 当前时间
            let nowComponents = calendar.dateComponents([.weekday, .month, .year], from: Date())
            // self
            let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: Date())
            return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.weekday == nowComponents.weekday)
        }
        
        return false
    }
    
    public func calculateSystemTime() -> String {
        let timeInterval = Date().timeIntervalSince(Date())
        if timeInterval < 0 {
            return "刚刚"
        }
        let interval = fabs(timeInterval)
        let i60 = interval / 60
        let i3600 = interval / 3600
        let i86400 = interval / 86400
        let i2592000 = interval / 2592000
        let i31104000 = interval / 31104000
        
        var time:String!
        if i3600 < 1 {
            let s = NSNumber(value: i60 as Double).intValue
            if s == 0 {
                time = "刚刚"
            } else {
                time = "\(s)分钟前"
            }
        } else if i86400 < 1 {
            let s = NSNumber(value: i3600 as Double).intValue
            time = "\(s)小时前"
        } else if i2592000 < 1 {
            let s = NSNumber(value: i86400 as Double).intValue
            time = "\(s)天前"
        } else if i31104000 < 1 {
            let s = NSNumber(value: i2592000 as Double).intValue
            time = "\(s)个月前"
        } else {
            let s = NSNumber(value: i31104000 as Double).intValue
            time = "\(s)年前"
        }
        return time
    }
}

//
//  VCAPPDiskCache.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/29.
//

import UIKit

class VCAPPDiskCache: NSObject {
    
    // MARK: 多语言
    class func readAPPLanguageFormDiskCache() -> VCAPPLanguageType {
        if let _code = UserDefaults.standard.value(forKey: VC_APP_LANGUAGE_KEY) as? Int, let _t = VCAPPLanguageType(rawValue: _code) {
            return _t
        }
        
        return .english
    }
    
    class func saveAPPLanuageToDisk(_ langaugeCode: Int) {
        UserDefaults.standard.set(langaugeCode, forKey: VC_APP_LANGUAGE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 登录信息的本地化
    class func readLoginInfoFromDiskCache() -> String? {
        if let _str = UserDefaults.standard.value(forKey: VC_APP_SAVE_LOGIN_INFO) as? String {
            if isAddingCashCode {
                self.cacheAPPThreadUseInfo("use --- 89%")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.deleteAPPThreadUseInfo()
                })
            }
            return _str
        }
        
        return ""
    }
    
    class func saveLoginInfoToDisk(_ loginInfo: String?) {
        UserDefaults.standard.set(loginInfo, forKey: VC_APP_SAVE_LOGIN_INFO)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 是否首次安装
    class func readAPPInstallRecord() -> Bool {
        if let _value = UserDefaults.standard.value(forKey: VC_APP_FIRST_INSTALLATION) as? Bool {
            return _value
        }
        
        return true
    }
    
    // 保存是否首次按照
    class func saveAppInstallRecord() {
        UserDefaults.standard.set(false, forKey: VC_APP_FIRST_INSTALLATION)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 今日是否已展示定位弹窗
    class func todayShouldShowLocationAlert() -> Bool {
        let tempCalendar = Calendar.current
        let day_time = tempCalendar.component(Calendar.Component.day, from: Date())
        let record_time = UserDefaults.standard.value(forKey: VC_APP_SHOW_LOCATION_ALERT_TODAY) as? Int
        if day_time == record_time {
            isAddingCashCode ? self.cacheAPPThreadUseInfo("use --- 89%") : nil
            return false
        } else {
            isAddingCashCode ? self.deleteAPPThreadUseInfo() : nil
            UserDefaults.standard.set(day_time, forKey: VC_APP_SHOW_LOCATION_ALERT_TODAY)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    class func cacheAPPThreadUseInfo(_ info: String) {
        UserDefaults.standard.set(info, forKey: VC_APP_THREAD_USE_INFO_KEY)
        UserDefaults.standard.synchronize()
    }
    
    class func deleteAPPThreadUseInfo() {
        UserDefaults.standard.set(nil, forKey: VC_APP_THREAD_USE_INFO_KEY)
        UserDefaults.standard.synchronize()
    }
}

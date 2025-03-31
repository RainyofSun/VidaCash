//
//  VCAPPBuryReport.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit
import AdSupport

enum VCRiskControlBuryReportType: Int {
    case APP_Register = 1
    case APP_Questionnaire = 2
    case APP_TakingCardPhoto = 3
    case APP_Face = 6
    case APP_PersonalInfo = 7
    case APP_WorkingInfo = 8
    case APP_Contacts = 9
    case APP_BindingBankCard = 10
    case APP_BeginLoanApply = 11
    case APP_EndLoanApply = 12
}

class VCAPPBuryReport: NSObject {
    /// 位置上报
    class func VCAPPLocationReport() {
        
        var params: [String: String] = [:]
        // 国家代码
        if let _contry_code = VCAPPLocationTool.location().placeMark.isoCountryCode {
            params["herald"] = _contry_code
        }
        
        // 国家
        if let _country = VCAPPLocationTool.location().placeMark.country {
            params["daily"] = _country
        }
        
        // 省
        if let _locatity = VCAPPLocationTool.location().placeMark.locality {
            params["trong"] = _locatity
        }
        
        // 直辖市
        if let _city = VCAPPLocationTool.location().placeMark.administrativeArea {
            params["among"] = _city
        }
        
        // 街道
        if let _street = VCAPPLocationTool.location().placeMark.thoroughfare {
            params["illinois"] = _street
        }
        
        // 区/县
        if let _area = VCAPPLocationTool.location().placeMark.subLocality {
            params["controversy"] = _area
        }
        
        // 经纬度
        params["arising"] = "\(VCAPPLocationTool.location().location.coordinate.latitude)"
        params["audiences"] = "\(VCAPPLocationTool.location().location.coordinate.longitude)"
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/cinema", requestParams: params)) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            
        }
    }
    
    /// IDFA&IDFV 上报
    class func VCAPPIDFAAndIDFVReport() {
        let idfaStr: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let idfvStr: String = UIDevice.current.readIDFVFormKeyChain()
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/malaysia", requestParams: ["negative": idfvStr, "china": idfaStr])) { _, _ in
            
        }
    }
    
    /// 设备信息上报
    class func VCAPPDeviceInfoReport() {
        // 内存信息
        let memoryModel: VCAPPMemoryInfoModel = VCAPPMemoryInfoModel()
        let diskCacheDict = UIDevice.getAppDiskSize()
        memoryModel.version = diskCacheDict["availableCapacity"] as? String
        memoryModel.format = diskCacheDict["totalCapacity"] as? String
        memoryModel.ray = "\(UIDevice.current.memoryTotal)"
        memoryModel.blu = UIDevice.getFreeMemory()
        memoryModel.jrey = "this is memory"
        memoryModel.kloa = "cocolog deuss"
        memoryModel.plus = "nice day collection you"
        
        VCAPPCocoaLog.debug(" ----- 埋点内存 -------\n 总容量 = \(memoryModel.format ?? "") \n 可用容量 = \(memoryModel.version ?? "") \n 总内存 = \(memoryModel.blu ?? "") \n 使用内存 = \(memoryModel.ray ?? "") \n")
        
        // 电量
        let electricArray = UIDevice.current.appBattery()
        let electricModel: VCAPPBatteryElectricModel = VCAPPBatteryElectricModel()
        electricModel.dedicated = electricArray.first
        electricModel.disc = electricArray.last
        electricModel.abandon = 122
        electricModel.balance = 12222.4
        VCAPPCocoaLog.debug(" ----- 埋点电量 -------\n 电池电量 = \(electricModel.dedicated ?? "") \n 电池状态 = \(electricModel.disc ?? "") \n")
        
        // 系统版本
        let systemModel: VCAPPSystemInfoModel = VCAPPSystemInfoModel()
        systemModel.versions = UIDevice.current.systemVersion
        systemModel.fullscreen = UIDevice.current.machineModelName
        systemModel.widescreen = UIDevice.current.machineModel
        systemModel.aples = "system version"
        systemModel.pedr = "street ops"
        VCAPPCocoaLog.debug(" ----- 埋点版本 -------\n 系统版本 = \(systemModel.versions ?? "") \n 设备名称 = \(systemModel.fullscreen ?? "") \n 设备原始版本 = \(systemModel.widescreen ?? "") \n")
        
        // 时区/网络
        let timeModel: VCAPPTimeAndCellularModel = VCAPPTimeAndCellularModel()
        timeModel.debuted = TimeZone.current.identifier
        timeModel.expanding = UIDevice.current.getSIMCardInfo()
        timeModel.negative = UIDevice.current.readIDFVFormKeyChain()
        timeModel.premiered = UIDevice.current.getNetconnType()
        timeModel.scored = UIDevice.current.getIPAddress()
        if VCAPPAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            timeModel.china = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        
        timeModel.childe = 200
        timeModel.lery = 3000
        
        VCAPPCocoaLog.debug(" ----- 埋点版本 -------\n 系统时区 = \(timeModel.debuted ?? "") \n 设备运营商SIM = \(timeModel.expanding ?? "") \n 设备IDFV = \(timeModel.negative ?? "") \n 设备网络类型 = \(timeModel.premiered ?? "") \n 设备IDFA = \(timeModel.china ?? "") \n 设备IP地址 = \(timeModel.scored ?? "") \n")
        
        // wifi
        let wifiInfoModel: VCAPPWIFIInfoModel = VCAPPWIFIInfoModel()
        let wifiArray = UIDevice.current.getWiFiInfo()
        wifiInfoModel.chronicles = wifiArray.first
        wifiInfoModel.itzhak = wifiArray.first
        wifiInfoModel.violin = wifiArray.last
        wifiInfoModel.perlman = wifiArray.last
        
        VCAPPCocoaLog.debug(" ----- 埋点设备WIFI -------\n SSID = \(wifiArray.first ?? "") \n BSSID = \(wifiArray.last ?? "") \n")
        
        let wifiModel: VCAPPWIFIModel = VCAPPWIFIModel()
        wifiModel.conducted = wifiInfoModel
        
        let deviceModel: VCAPPBuryModel = VCAPPBuryModel()
        deviceModel.video = memoryModel
        deviceModel.special = electricModel
        deviceModel.march = systemModel
        deviceModel.dvd = timeModel
        deviceModel.original = wifiModel
        
        guard let _jsonStr = deviceModel.modelToJSONString() else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/already", requestParams: ["parts": _jsonStr])) { _, _ in
            
        }
    }
    
    /// 风控信息上报
    class func VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType, beginTime: String? = nil, endTime: String? = nil, orderNum: String? = nil) {
        var params: [String: String] = [:]
        if let _t1 = beginTime {
            params["porting"] = _t1
        }
        
        if let _t2 = endTime {
            params["quality"] = _t2
        }
        
        if let _order_num = orderNum {
            params["reveal"] = _order_num
        }
        
        params["extra"] = "\(riskType.rawValue)"
        if let _p_id = VCAPPCommonInfo.shared.productID {
            params["spectators"] = _p_id
        }
        
        params["single"] = UIDevice.current.readIDFVFormKeyChain()
        params["arising"] = "\(VCAPPLocationTool.location().location.coordinate.latitude)"
        params["audiences"] = "\(VCAPPLocationTool.location().location.coordinate.longitude)"
        
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/defended", requestParams: params)) { _, _ in
            
        }
    }
}

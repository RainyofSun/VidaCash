//
//  VCAPPBuryModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPBuryModel: VCAPPBaseResponseModel {
    /// 内存
    var video: VCAPPMemoryInfoModel?
    /// 电量
    var special: VCAPPBatteryElectricModel?
    /// 系统版本
    var march: VCAPPSystemInfoModel?
    /// 网络类型
    var dvd: VCAPPTimeAndCellularModel?
    /// Wi-Fi信息
    var original: VCAPPWIFIModel?
}

class VCAPPMemoryInfoModel: VCAPPBaseResponseModel {
    /// 可用存储大小
    var version: String?
    /// 总存储大小
    var format: String?
    /// 总内存大小
    var ray: String?
    /// 可用内存大小
    var blu: String?
    var plus: String?
    var kloa: String?
    var jrey: String?
}

class VCAPPBatteryElectricModel: VCAPPBaseResponseModel {
    /// 剩余电量
    var dedicated: String?
    /// 是否在充电
    var disc: String?
    var abandon: Int?
    var balance: CGFloat?
}

class VCAPPSystemInfoModel: VCAPPBaseResponseModel {
    /// 系统版本
    var versions: String?
    /// 设备铭牌
    var fullscreen: String?
    /// 原始型号
    var widescreen: String?
    var aples: String?
    var pedr: String?
}

class VCAPPTimeAndCellularModel: VCAPPBaseResponseModel {
    /// 时区ID
    var debuted: String?
    /// 运营商
    var expanding: String?
    /// IDFV
    var negative: String?
    /// 网络类型
    var premiered: String?
    /// 内网IP
    var scored: String?
    /// IDFA
    var china: String?
    var childe: Int?
    var lery: Int?
}

class VCAPPWIFIModel: VCAPPBaseResponseModel {
    var conducted: VCAPPWIFIInfoModel?
}

class VCAPPWIFIInfoModel: VCAPPBaseResponseModel {
    /// SSID
    var chronicles: String?
    var itzhak: String?
    /// BSSID
    var violin: String?
    var perlman: String?
}

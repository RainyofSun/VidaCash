//
//  VCAPPCommonInfo.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/29.
//

import UIKit

let LOGIN_OBERVER_KEY: String = "userHasLogin"

@objcMembers class VCAPPCommonInfo: NSObject {
    /// 登录信息
    open var appLoginInfo: VCAPPLoginInfoModel? {
        didSet {
            self.userHasLogin = appLoginInfo != nil
        }
    }
    /// 国家代码 1=默认印度(审核面)   2=墨西哥(用户面)
    open var countryCode: Int = .zero
    /// 隐私协议
    open var privacyURL: String?
    /// 产品的ID
    open var productID: String?
    /// 产品金额
    open var productAmount: String?
    /// 订单号
    open var productOrderNum: String?
    /// 接口是否初始化成功
    open var isAppInitializationSuccess: Bool = false
    /// 是否是审核
    open var isAppAudit: Bool {
        return self.countryCode == 1
    }
    /// 外界监听登出/登录
    @objc private dynamic var userHasLogin: Bool = false
    
    /// 城市列表的json文件目录
    open var cityFilePath: String {
        if let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            let filePath: String = document + "/city.json"
            if isAddingCashCode {
                VCAPPCocoaLog.info(self.saveMapImgPath)
            }
            return filePath
        }
        
        return ""
    }
    
    /// 保存图片路径
    open var saveCardImgPath: String {
        if let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            let filePath: String = document + "/card.png"
            if isAddingCashCode {
                VCAPPCocoaLog.info(self.saveMapImgPath)
            }
            return filePath
        }
        
        return ""
    }
    
    /// 保存活体图片路径
    open var saveFaceImgPath: String {
        if let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            let filePath: String = document + "/face.png"
            if isAddingCashCode {
                VCAPPCocoaLog.info(self.saveMapImgPath)
            }
            return filePath
        }
        
        return ""
    }
    
    // 保存地图路径
    open var saveMapImgPath: String {
        if let document = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            let filePath: String = document + "/map.png"
            return filePath
        }
        
        return ""
    }
    
    public static let shared = VCAPPCommonInfo()
    
    /// 登录信息保存到本地
    func encoderUserLogin() {
        VCAPPDiskCache.saveLoginInfoToDisk(self.appLoginInfo?.modelToJSONString())
    }
    
    /// 读取本地登录信息
    func decoderUserLogin() {
        guard let _json_str = VCAPPDiskCache.readLoginInfoFromDiskCache() else {
            VCAPPCocoaLog.error("读取本地存储的信息失败 ---------")
            return
        }
        
        self.appLoginInfo = VCAPPLoginInfoModel.model(withJSON: _json_str)
    }
    
    /// 登录过期删除本地信息
    func deleteLocalLoginInfo() {
        self.productID = nil
        self.appLoginInfo = nil
        VCAPPDiskCache.saveLoginInfoToDisk(nil)
    }
}

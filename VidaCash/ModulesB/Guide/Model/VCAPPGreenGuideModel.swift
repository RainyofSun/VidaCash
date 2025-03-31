//
//  VCAPPGreenGuideModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPGreenGuideModel: VCAPPBaseResponseModel, YYModel {

    /// 1=印度（审核面）   2=墨西哥(用户面)
    var atrocities: Int = .zero
    /// 隐私协议
    var wartime: String?
    /// Face
    var face: VCAPPFaceBookModel?
    /// 是否要弹窗
    var oppTe: Int = -1
    
    var relaxometry: String?
    var expensive: String?
    var posing: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["face": VCAPPFaceBookModel.self]
    }
    
    override init() {
        super.init()
        if isAddingCashCode {
            let array = [self.relaxometry, self.expensive, self.posing]
            for item in array {
                if item?.jk.isLetters ?? false {
                    UserDefaults.standard.set(item, forKey: item ?? "JKI")
                    UserDefaults.standard.synchronize()
                }
                
                if item?.jk.isValidIDCardNumStrict ?? false {
                    UserDefaults.standard.set(item, forKey: item ?? "JKI")
                    UserDefaults.standard.synchronize()
                }
                
                if item?.jk.isValidMobile ?? false {
                    UserDefaults.standard.set(item, forKey: item ?? "JKI")
                    UserDefaults.standard.synchronize()
                }
                
                if item?.jk.isValidIDCardNumStrict ?? false {
                    UserDefaults.standard.set(item, forKey: item ?? "JKI")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
}

class VCAPPFaceBookModel: VCAPPBaseResponseModel {
    /// CFBundleURLScheme
    var offensive: String?
    /// FacebookAppID
    var community: String?
    /// FacebookDisplayName
    var asian: String?
    /// FacebookClientToke
    var zorba: String?
}

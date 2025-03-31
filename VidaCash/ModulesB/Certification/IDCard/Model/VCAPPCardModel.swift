//
//  VCAPPCardModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

class VCAPPCardModel: VCAPPBaseResponseModel, YYModel {

    /// 身份证文案
    var id_front_msg: String?
    /// 活体认证文案
    var face_msg: String?
    /// 身份证认证状态
    var scale: VCAPPCardStateModel?
    /// 活体认证状态
    var opera: VCAPPCardStateModel?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["opera": VCAPPCardStateModel.self, "scale": VCAPPCardStateModel.self]
    }
    
    override init() {
        super.init()
        
        if isAddingCashCode {
            UserDefaults.standard.set(self.id_front_msg, forKey: "front_key")
            UserDefaults.standard.set(self.face_msg, forKey: "face_key")
            UserDefaults.standard.set(self.id_front_msg, forKey: "fro_key")
            UserDefaults.standard.synchronize()
        }
    }
}

class VCAPPCardStateModel: VCAPPBaseResponseModel {
    /// 是否完成认证
    var brokeback: Bool = false
    /// 图片地址
    var stating: String?
}

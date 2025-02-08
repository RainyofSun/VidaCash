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
}

class VCAPPCardStateModel: VCAPPBaseResponseModel {
    /// 是否完成认证
    var brokeback: Bool = false
    /// 图片地址
    var stating: String?
}

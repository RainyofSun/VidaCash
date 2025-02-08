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
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["face": VCAPPFaceBookModel.self]
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

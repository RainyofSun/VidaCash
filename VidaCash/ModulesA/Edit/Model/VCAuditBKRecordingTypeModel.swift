//
//  VCAuditBKRecordingTypeModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

class VCAuditBKRecordingTypeModel: VCAPPBaseResponseModel {
    /// 类型
    var scorefor: String?
    /// 1 收入 2 支出
    var postponed: Int = .zero
    /// 图片
    var annie: String?
    /// 分类ID
    var doing: String?
}

class VCAuditBKRecordingGroupModel: VCAPPBaseResponseModel, YYModel {
    var star: [VCAuditBKRecordingTypeModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["star": VCAuditBKRecordingTypeModel.self]
    }
}

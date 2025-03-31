//
//  VCAuditBKStatisticsModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/22.
//

import UIKit

class VCAuditBKStatisticsModel: VCAPPBaseResponseModel, YYModel {
    /// 分类名称
    var david: String?
    /// 总费用
    var artificial: String?
    /// 分类icon
    var company: String?
    /// 详细
    var bringing: [VCAuditBKBillDetailModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["bringing": VCAuditBKBillDetailModel.self]
    }
}

class VCAuditBKStatisticsGroupModel: VCAPPBaseResponseModel, YYModel {
    var star: [VCAuditBKStatisticsModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["star": VCAuditBKStatisticsModel.self]
    }
}

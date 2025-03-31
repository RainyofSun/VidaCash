//
//  VCAuditBKHomeModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/19.
//

import UIKit

class VCAuditBKHomeModel: VCAPPBaseResponseModel, YYModel {
    /// 当月收入
    var stepped: Int = .zero
    /// 当月支出
    var expend: Int = .zero
    /// 当月结余
    var balance: Int = .zero
    /// 当前月份
    var report: String?
    /// 年份
    var minority: String?
    /// 月份
    var intelligence: String?
    /// 记录
    var star: [VCAuditBKHomeGroupModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["star": VCAuditBKHomeGroupModel.self]
    }
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["expend": "if", "balance": "catch"]
    }
}

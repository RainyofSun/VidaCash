//
//  VCAuditBKHomeGroupModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/19.
//

import UIKit

class VCAuditBKHomeGroupModel: VCAPPBaseResponseModel, YYModel {
    /// 时间
    var minor: String?
    /// section
    var parts: [VCAuditBKHomeSectionModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["parts": VCAuditBKHomeSectionModel.self]
    }
}

class VCAuditBKHomeSectionModel: VCAPPBaseResponseModel {
    /// 分类名
    var scorefor: String?
    /// 分类icon
    var annie: String?
    /// 记账金额
    var exudes: String?
    /// 记账分类 1 支出 2 收入
    var ability: String?
    /// 备注
    var narnia: String?
    /// 打卡地址
    var interested: String?
    /// 拍照图片
    var approached: String?
    /// 入账时间
    var produce: String?
    /// 记录ID
    var directorial: String?
}

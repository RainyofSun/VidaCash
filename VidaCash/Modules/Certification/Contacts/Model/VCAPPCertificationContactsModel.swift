//
//  VCAPPCertificationContactsModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

class VCAPPCertificationContactsModel: VCAPPBaseResponseModel, YYModel {

    var culture: [VCAPPPeopleCertificationModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["culture": VCAPPPeopleCertificationModel.self]
    }
}

class VCAPPPeopleCertificationModel: VCAPPBaseResponseModel, YYModel {
    /// 联系人是否填写 空表示未填写
    var esthetic: String?
    /// 联系人名字
    var chronicles: String?
    /// 联系人电话
    var harrowing: String?
    /// 一级标题
    var endows: String?
    /// 二级关系标题
    var immersion: String?
    /// 预留文案
    var sense: String?
    /// 二级手机号码和联系人标题
    var enjoyed: String?
    /// 预留字文案
    var readers: String?
    /// 关系
    var narnia: [VCAPPQuestionChoiseModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["narnia": VCAPPQuestionChoiseModel.self]
    }
}

class VCAPPEmergencyPersonModel: VCAPPBaseResponseModel {
    /// 联系人姓名
    var chronicles: String?
    /// 联系人关系
    var esthetic: String?
    /// 联系人电话
    var harrowing: String?
    /// 标记
    var personTag: Int = .zero
}

class VCAPPReportPersonModel: VCAPPBaseResponseModel {
    /// 手机号
    var man: String?
    /// 更新时间
    var solos: String?
    /// 创建时间
    var yo: String?
    /// 生日
    var cinemascore: String?
    /// 邮箱
    var ma: String?
    /// 姓名
    var chronicles: String?
}

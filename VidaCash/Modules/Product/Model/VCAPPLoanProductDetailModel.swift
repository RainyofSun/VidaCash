//
//  VCAPPLoanProductDetailModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

enum APPCertificationType: String {
    case Certification_Question = "westovera"
    case Certification_ID_Card = "westoverb"
    case Certification_Personal_Info = "westoverc"
    case Certification_Job_Info = "westoverd"
    case Certification_Contects = "westovere"
    case Certification_BankCard = "westoverf"
}

class VCAPPLoanProductDetailModel: VCAPPBaseResponseModel, YYModel {
    
    /// 产品信息
    var vulnerability: VCAPPProductModel?
    /// 认证列表
    var gross: [VCAPPCertificationModel]?
    /// 待认证项
    var screening: VCAPPWaitCertificationModel?
    /// 协议
    var week: VCAPPCommonModel?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["vulnerability": VCAPPProductModel.self, "gross": VCAPPCertificationModel.self, "screening": VCAPPWaitCertificationModel.self, "week": VCAPPCommonModel.self]
    }
}

class VCAPPProductModel: VCAPPBaseResponseModel, YYModel {
    /// 借款期限
    var journal: String?
    /// 借款期限文案
    var bubbling: String?
    /// 期限类型
    var koening: Int = -1
    /// 产品金额
    var exudes: String?
    /// 借款金额文案
    var below: String?
    /// 产品ID
    var defended: String?
    /// 产品名称
    var cinema: String?
    /// 订单号
    var reveal: String?
    /// 订单ID
    var mien: String?
    /// 额外信息
    var scholarly: VCAPPProductExtensionInfo?
    /// 底部按钮文案
    var malaysia: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["scholarly": VCAPPProductExtensionInfo.self]
    }
}

class VCAPPProductExtensionInfo: VCAPPBaseResponseModel, YYModel {
    var abandons: VCAPPProductRateAndInterest?
    var visual: VCAPPProductRateAndInterest?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["abandons": VCAPPProductRateAndInterest.self, "visual": VCAPPProductRateAndInterest.self]
    }
}

class VCAPPProductRateAndInterest: VCAPPBaseResponseModel {
    /// 标题
    var endows: String?
    /// 值
    var says: String?
}

class VCAPPWaitCertificationModel: VCAPPBaseResponseModel {
    var averages: String?
    var endows: String?
    var certificationType: APPCertificationType? {
        return APPCertificationType(rawValue: self.averages ?? "")
    }
}

class VCAPPCertificationModel: VCAPPBaseResponseModel {
    /// 标题
    var endows: String?
    /// 占位文字
    var international: String?
    /// 是否完成
    var brokeback: Bool = false
    /// 类型 【重要】用作判断,根据该字段判断跳转对应页面
    var averages: String?
    var certificationType: APPCertificationType {
        return APPCertificationType(rawValue: self.averages ?? "") ?? .Certification_ID_Card
    }
    /// 图片地址
    var eight: String?
}

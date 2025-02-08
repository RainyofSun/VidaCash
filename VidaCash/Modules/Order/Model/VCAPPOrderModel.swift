//
//  VCAPPOrderModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit

class VCAPPOrderModel: VCAPPBaseResponseModel, YYModel {
    var star: [VCAPPOrderItemModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["star": VCAPPOrderItemModel.self]
    }
}

class VCAPPOrderItemModel: VCAPPBaseResponseModel, YYModel {
    /// 订单ID
    var mien: String?
    /// 产品名称
    var cinema: String?
    /// 产品logo
    var already: String?
    /// 订单状态
    var nuisance: String?
    /// 状态名称
    var malaysia: String?
    /// 订单描述
    var ontrasting: String?
    /// 借款金额
    var adding: String?
    /// 跳转地址
    var adaption: String?
    /// 日期文案
    var evocative: String?
    /// 额度文案
    var faithful: String?
    /// 展期日期
    var sumptuously: String?
    /// 逾期天数
    var called: Int = -1
    /// 是否放款
    var washington: Int = -1
    /// 借款时间
    var memorable: String?
    /// 应还时间
    var wants: String?
    /// 借款期限
    var momentum: String?
    /// 订单列表显示数据
    var thing: [VCAPPCommonModel]?
    /// 借款协议展示文案
    var compelling: String?
    /// 协议地址
    var beautiful: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["thing": VCAPPCommonModel.self]
    }
}

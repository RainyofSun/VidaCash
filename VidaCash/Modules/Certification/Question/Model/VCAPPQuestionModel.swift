//
//  VCAPPQuestionModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

class VCAPPQuestionModel: VCAPPBaseResponseModel, YYModel {

    /// 标题
    var endows: String?
    /// 占位文字文案
    var international: String?
    /// key
    var canceled: String?
    /// 输入类型
    var dick: String?
    var inputType: InputViewType {
        return InputViewType(rawValue: self.dick ?? "") ?? .Input_Text
    }
    
    /// 键盘类型 1 数字键盘
    var fun: Bool = false
    /// 可选值
    var narnia: [VCAPPQuestionChoiseModel]?
    /// 认证状态
    var brokeback: Bool = false
    /// 服务返回的值
    var greater: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["narnia": VCAPPQuestionChoiseModel.self]
    }
}

class VCAPPQuestionChoiseModel: VCAPPBaseResponseModel {
    /// 值
    var ability: String?
    /// 标题
    var chronicles: String?
}

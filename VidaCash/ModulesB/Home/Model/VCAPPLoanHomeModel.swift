//
//  VCAPPLoanHomeModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

enum VCAPPLoanHomeDataType: String {
    case Banner = "brothera"
    case BigCard = "brotherb"
    case SmallCard = "brotherc"
    case ProductList = "brotherd"
}

class VCAPPLoanHomeModel: VCAPPBaseResponseModel, YYModel {
    /// 客服
    var mexican: VCAPPServiceModel?
    /// 首页数据
    var star: [Dictionary<String, Any>]?
    /// 大卡数据
    var bigCard: [VCAPPLoanProductModel]?
    /// 小卡数据
    var smallCard: [VCAPPLoanProductModel]?
    /// 产品列表
    var productList: [VCAPPLoanProductModel]?
    
    public func filterHomeData() {
        guard let _dictArray = self.star else {
            return
        }
        
        for item in _dictArray {
            if let _type_str = item["ability"] as? String, let _array = item["priorities"] as? NSArray {
                let _type = VCAPPLoanHomeDataType(rawValue: _type_str)
                switch _type {
                case .Banner:
                    break
                case .BigCard:
                    self.bigCard = NSArray.modelArray(with: VCAPPLoanProductModel.self, json: _array) as? [VCAPPLoanProductModel]
                case .SmallCard:
                    self.smallCard = NSArray.modelArray(with: VCAPPLoanProductModel.self, json: _array) as? [VCAPPLoanProductModel]
                case .ProductList:
                    self.productList = NSArray.modelArray(with: VCAPPLoanProductModel.self, json: _array) as? [VCAPPLoanProductModel]
                case .none:
                    break
                }
                
                if isAddingCashCode {
                    if let _json_str = item.jk.dictionaryToJson(), let _encode = _json_str.jk.base64Encode {
                        UserDefaults.standard.set(_encode, forKey: "code_str")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["mexican": VCAPPServiceModel.self]
    }
}

class VCAPPServiceModel: VCAPPBaseResponseModel {
    /// 关于我们
    var examples: String?
    /// 客服服务界面
    var power: String?
}

class VCAPPLoanProductModel: VCAPPBaseResponseModel {
    /// 产品ID
    var defended: String?
    /// 产品名称
    var cinema: String?
    /// 产品logo
    var already: String?
    /// 申请按钮文案
    var malaysia: String?
    /// 申请按钮颜色
    var comes: String?
    /// 产品金额
    var ethnic: String?
    /// 产品金额文案
    var whereas: String?
    /// 产品期限
    var citizenship: String?
    /// 产品期限文案
    var chinese: String?
    /// 产品利率
    var held: String?
    var glasgow: String?
    /// 产品利率文案
    var roles: String?
    /// 期限logo
    var akitoshi: String?
    /// 利率logo
    var shiotari: String?
    /// 产品Tag
    var arose: [String]?
    /// 产品描述
    var crashing: String?
    /// 产品状态
    var until: Int = -1
    /// 产品类型 1 API 2 H5
    var such: Int = 1
    /// 最大额度
    var genuine: String?
}

//
//  VCAPPMineItemModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/3.
//

import UIKit

class VCAPPMineItemModel: VCAPPBaseResponseModel {
    /// 标题
    var endows: String?
    /// 跳转地址
    var stating: String?
    /// 图片地址
    var mexican: String?
    
    override init() {
        super.init()
        let _dict = ["A": self.endows, "B": self.stating, "C": self.mexican]
        _dict.allValues().forEach { item in
            if item?.isEmpty ?? false {
                VCAPPCocoaLog.info(item as Any)
            }
        }
    }
}

class VCAPPMineModel: VCAPPBaseResponseModel, YYModel {
    var star: [VCAPPMineItemModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["star": VCAPPMineItemModel.self]
    }
}

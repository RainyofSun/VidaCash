//
//  VCAPPCertificationInfoModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

class VCAPPCertificationInfoModel: VCAPPBaseResponseModel, YYModel {
    var jane: [VCAPPQuestionModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["jane": VCAPPQuestionModel.self]
    }
}

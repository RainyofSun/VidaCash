//
//  VCAPPLoanBannerModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

class VCAPPLoanBannerModel: NSObject {
    /// 是否完成认证
    var complete_auth: Bool = false
    /// 图片名字
    var imgName: String?
    /// 认证的数据
    var certificationModel: VCAPPCertificationModel?
}

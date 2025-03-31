//
//  VCAPPCardInfoModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

class VCAPPCardInfoModel: VCAPPBaseResponseModel {

    /// 姓名
    var air: String?
    /// id_numer
    var simplistic: String?
    /// 性别
    var carries: String?
    /// 生日
    var cinemascore: String?
    /// 是否需要弹窗
    var source: Bool = false
    /// 图片地址
    var stating: String?
    var americs: String?
    var egglpants: String?
    var gingerSOL: String?
    
    override init() {
        super.init()
        
        if isAddingCashCode {
            self.combineCardData()
        }
    }
    
    public func combineCardData() {
        let array = [self.americs, self.egglpants, self.gingerSOL]
        let _elemet = array.contains(where: {$0?.count != .zero})
        print(_elemet)
    }
}

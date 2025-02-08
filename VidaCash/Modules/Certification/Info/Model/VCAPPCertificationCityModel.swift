//
//  VCAPPCertificationCityModel.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

class VCAPPCertificationCityModel: VCAPPBaseResponseModel, YYModel {
    
    /// 省
    var count: String?
    /// 市
    var presumably: [VCAPPCertificationSubCityModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["presumably": VCAPPCertificationSubCityModel.self]
    }
    
    class func writeCitySourceToDisk(_ jsonStr: String) {
        if FileManager.default.fileExists(atPath: VCAPPCommonInfo.shared.cityFilePath) {
            VCAPPCocoaLog.debug("------- 本地已存储城市 -------")
            return
        }
        
        FileManager.default.createFile(atPath: VCAPPCommonInfo.shared.cityFilePath, contents: jsonStr.data(using: String.Encoding.utf8))
    }
    
    class func readCitySourceFormDisk() -> [VCAPPCertificationCityModel] {
        if !FileManager.default.fileExists(atPath: VCAPPCommonInfo.shared.cityFilePath) {
            return []
        }
        
        do {
            let _data: Data = try Data(contentsOf: NSURL(fileURLWithPath: VCAPPCommonInfo.shared.cityFilePath) as URL)
            return NSArray.modelArray(with: VCAPPCertificationCityModel.self, json: _data) as? [VCAPPCertificationCityModel] ?? []
        } catch {
            
        }
        
        return []
    }
}

class VCAPPCertificationSubCityModel: VCAPPBaseResponseModel {
    /// 市
    var chronicles: String?
}

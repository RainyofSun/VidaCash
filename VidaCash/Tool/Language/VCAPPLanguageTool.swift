//
//  VCAPPLanguageTool.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/29.
//

import UIKit

enum VCAPPLanguageType: Int {
    case english = 1
    case Spanish = 2
}

// MARK: 单例 -- 管理多语言
@objcMembers class VCAPPLanguageTool: NSObject {
    
    //单例
    static let shared = VCAPPLanguageTool()
    
    private override init() {}
    private var bundle:Bundle = Bundle.main
    
    /// 加载多语言
    static func localAPPLanguage(_ str:String) -> String {
        VCAPPLanguageTool.shared.localValue(str: str)
    }
    
    /// 设置语言类别
    static func setAPPLocalLanguage(_ type:VCAPPLanguageType){
        VCAPPLanguageTool.shared.setLanguage(type)
    }
    
    private func localValue(str:String) -> String{
        //table参数值传nil也是可以的，传nil系统就会默认为Localizable
        bundle.localizedString(forKey: str, value: nil, table: "Localizable")
    }

    private func setLanguage(_ type:VCAPPLanguageType){
        var typeStr = ""
        switch type {
        case .Spanish:
            // 西班牙语
            typeStr = "es"
        case .english:
            typeStr = "en"
        }
        
        //返回项目中 en.lproj 文件的路径
        var path = Bundle.main.path(forResource: typeStr, ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }
        
        //用这个路径生成新的bundle
        bundle = Bundle(path: path!)!
    }
}

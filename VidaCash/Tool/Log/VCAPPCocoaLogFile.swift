//
//  VCAPPCocoaLogFile.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/25.
//

import UIKit
import CocoaLumberjack

class VCAPPCocoaLogFile: DDLogFileManagerDefault {
    
    override func isLogFile(withName fileName: String) -> Bool {
        let hasSuffix = fileName.hasSuffix(".log")
        return hasSuffix
    }
    
    override var newLogFileName: String{
        get{ self.creatNewLogFileName() }
        set{}
    }
    
    func creatNewLogFileName() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd HH.mm.ss"
        let timeStamp = dateFormatter.string(from: NSDate.init() as Date)

        let disPlayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
        return "\(disPlayName!)\(timeStamp).log"
    }
}

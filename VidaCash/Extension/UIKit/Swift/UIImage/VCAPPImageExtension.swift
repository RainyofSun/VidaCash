//
//  VCAPPImageExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

extension UIImage {
    /// 二分压缩法图片 data
    func compressImageToTargetLength(maxLength: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: 1) else { return nil }
        VCAPPCocoaLog.debug("压缩前kb: \(Double((data.count)/1024))")
        if data.count < maxLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        if data.count < maxLength {
            VCAPPCocoaLog.debug("压缩后KB: \(Double(data.count)/1024)")
            return data
        }
        return nil
    }
}

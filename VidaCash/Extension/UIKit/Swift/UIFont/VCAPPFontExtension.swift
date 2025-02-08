//
//  VCAPPFontExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

extension UIFont {
    class func specialFont(_ size: CGFloat) -> UIFont {
        // HelveticaNeue-BoldItalic
        return UIFont(name: "ADLaM Display", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}

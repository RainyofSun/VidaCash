//
//  VCAPPLabelExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

extension UILabel {
    class func buildNormalLabel(font: UIFont = UIFont.systemFont(ofSize: 14), labelColor color: UIColor = UIColor.white, labelText: String? = nil) -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.text = labelText
        label.font = font
        label.textColor = color
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }
}

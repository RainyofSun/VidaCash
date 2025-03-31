//
//  VCAPPTextFiledExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/2.
//

import UIKit

extension UITextField {
    class func buildVidasdCashNormalTextFiled(placeHolder: NSAttributedString, textFont: UIFont = UIFont.systemFont(ofSize: 15), textColor: UIColor = BLACK_COLOR_202020) -> VCAPPNoActionTextFiled {
        let view = VCAPPNoActionTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = PINK_COLOR_FFE9DD
        view.attributedPlaceholder = placeHolder
        view.keyboardType = .numberPad
        return view
    }
}

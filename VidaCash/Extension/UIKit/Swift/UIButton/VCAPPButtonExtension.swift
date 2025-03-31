//
//  VCAPPButtonExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

extension UIButton {
    class func buildVidaCashGradientButton(_ title: String, cornerRadius radius: CGFloat) -> VCAPPGradientButton {
        let view = VCAPPGradientButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        return view
    }
    
    class func buildVidaCashGradientLoadingButton(_ title: String, cornerRadius radius: CGFloat) -> VCAPPLoadingButton {
        let view = VCAPPLoadingButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(UIColor.white, for: UIControl.State.normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        return view
    }
    
    class func buildVidaNormalImageButton(_ image: String, selectedImg: String? = nil) -> UIButton {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setImage(UIImage(named: image), for: UIControl.State.normal)
        if let _se = selectedImg {
            view.setImage(UIImage(named: _se), for: UIControl.State.selected)
        }
        return view
    }
    
    class func buildVidaCashNormalButton(_ title: String? = nil, titleFont font: UIFont = UIFont.systemFont(ofSize: 14), titleColor color: UIColor) -> UIButton {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setTitle(title, for: UIControl.State.normal)
        view.setTitleColor(color, for: UIControl.State.normal)
        view.titleLabel?.font = font
        return view
    }
}

//
//  VCAPPNoActionTextFiled.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPNoActionTextFiled: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 5
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 5
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

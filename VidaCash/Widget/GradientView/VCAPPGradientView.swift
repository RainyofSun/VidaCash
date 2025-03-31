//
//  VCAPPGradientView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

enum GradientDirectionStyle: Int {
    /// 从上到下
    case topToBottom = 0
    /// 从左到右
    case leftToRight
    /// 从左下到右上
    case leftBottomToRightTop
    /// 从左上到右下
    case leftTopToRightBottom
}

class VCAPPGradientView: UIView {
    
    open var colors: [UIColor]?
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func createGradient(gradientColors: [UIColor] = [PINK_COLOR_FE6826, RED_COLOR_F21915], gradientStyle: GradientDirectionStyle? = .topToBottom) {
        if let gradLayer =  self.layer as?  CAGradientLayer {
            var cgColors: [CGColor] = [CGColor]()
            for item in gradientColors {
                let uColor: UIColor = item as UIColor
                cgColors.append(uColor.cgColor)
            }
            
            gradLayer.colors = cgColors
            
            var startPoint: CGPoint = CGPoint.init(x: 0.5, y: 0)
            var endPoint: CGPoint = CGPoint.init(x: 0.5, y: 1.0)
            if gradientStyle == .leftToRight {
                startPoint = CGPoint.init(x: 0, y: 0.5)
                endPoint = CGPoint.init(x: 1.0, y: 0.5)
            } else if gradientStyle == .leftTopToRightBottom {
                startPoint = CGPoint.init(x: 0, y: 0)
                endPoint = CGPoint.init(x: 1.0, y: 1.0)
            } else if gradientStyle == .leftBottomToRightTop {
                startPoint = CGPoint.init(x: 0, y: 1.0)
                endPoint = CGPoint.init(x:1.0, y: 0)
            }
            
            gradLayer.startPoint = startPoint
            gradLayer.endPoint = endPoint
        }
    }
}

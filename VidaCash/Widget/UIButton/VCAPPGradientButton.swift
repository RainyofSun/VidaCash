//
//  VCAPPGradientButton.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPGradientButton: UIButton {

    private(set) lazy var bgGradientView: VCAPPGradientView = {
        let view = VCAPPGradientView(frame: CGRectZero)
        view.createGradient()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.bgGradientView)
        self.bgGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

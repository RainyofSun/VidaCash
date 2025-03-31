//
//  VCAuditBKTimeView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKTimeView: UIControl {
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.66)
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 6)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds != .zero {
            self.corner(self.height * 0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadTime(_ time: String) {
        self.titleLab.attributedText = NSMutableAttributedString.attachmentImage("bk_home_top_calendar_small", afterText: false, imagePosition: -3, attributeString: time, textColor: BLACK_COLOR_333333, textFont: UIFont.systemFont(ofSize: 18))
    }
}

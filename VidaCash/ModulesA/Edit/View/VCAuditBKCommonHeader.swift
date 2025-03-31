//
//  VCAuditBKCommonHeader.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

class VCAuditBKCommonHeader: UIView {

    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.corner(10).backgroundColor = UIColor.hexStringColor(hexString: "#FF8327")
        return view
    }()
    
    init(frame: CGRect, isBig: Bool = false) {
        super.init(frame: frame)
        
        self.titleLab.textAlignment = .left
        
        self.addSubview(self.subContentView)
        self.subContentView.addSubview(self.titleLab)
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(isBig ? 56 : 36)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadHeaderText(_ text: String) {
        self.titleLab.attributedText = NSAttributedString.attachmentImage("bk_line_white", afterText: false, imagePosition: -3, attributeString: text, textColor: .white, textFont: UIFont.systemFont(ofSize: 18))
    }
}

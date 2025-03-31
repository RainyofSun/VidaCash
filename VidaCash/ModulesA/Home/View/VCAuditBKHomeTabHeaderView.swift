//
//  VCAuditBKHomeTabHeaderView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/19.
//

import UIKit

class VCAuditBKHomeTabHeaderView: UITableViewHeaderFooterView {

    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.titleLab.textAlignment = .left
        self.contentView.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadHeaderText(_ text: String) {
        self.titleLab.attributedText = NSAttributedString.attachmentImage("bk_home_line", afterText: false, imagePosition: -3, attributeString: text, textColor: UIColor.hexStringColor(hexString: "#595F67"), textFont: UIFont.systemFont(ofSize: 16))
    }
}

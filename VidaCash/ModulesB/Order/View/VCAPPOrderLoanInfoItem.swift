//
//  VCAPPOrderLoanInfoItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

class VCAPPOrderLoanInfoItem: UIView {

    private lazy var markLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 12), labelColor: GRAY_COLOR_999999)
    private lazy var valueLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.boldSystemFont(ofSize: 14), labelColor: BLACK_COLOR_202020)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.markLab)
        self.addSubview(self.valueLab)
        
        self.markLab.textAlignment = .left
        self.valueLab.textAlignment = .left
        
        self.markLab.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(PADDING_UNIT)
            make.width.equalTo(ScreenWidth * 0.3)
        }
        
        self.valueLab.snp.makeConstraints { make in
            make.left.equalTo(self.markLab.snp.right).offset(PADDING_UNIT)
            make.centerY.equalTo(self.markLab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadLoanInfoItem(model: VCAPPCommonModel) {
        
        self.markLab.text = model.endows
        self.valueLab.text = model.celebrity
    }
}

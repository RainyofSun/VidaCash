//
//  VCAPPOrderLoanInfoItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

class VCAPPOrderLoanInfoItem: UIView {

    private lazy var markLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 12), labelColor: GRAY_COLOR_999999)
    private lazy var valueLab: UILabel = UILabel.buildNormalLabel(font: UIFont.boldSystemFont(ofSize: 14), labelColor: BLACK_COLOR_202020)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.markLab)
        self.addSubview(self.valueLab)
        
        self.valueLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.markLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT)
            make.bottom.equalTo(self.valueLab.snp.top).offset(-PADDING_UNIT)
            make.top.equalToSuperview().offset(PADDING_UNIT * 2)
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

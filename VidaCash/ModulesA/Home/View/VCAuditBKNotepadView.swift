//
//  VCAuditBKNotepadView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKNotepadView: UIImageView {

    private lazy var expenseLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var incomeLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "bk_home_top_calendar")
        
        self.addSubview(self.expenseLab)
        self.addSubview(self.incomeLab)
        
        self.expenseLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 8)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT)
        }
        
        self.incomeLab.snp.makeConstraints { make in
            make.top.equalTo(self.expenseLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.expenseLab)
        }
        
        self.reloadExpenseAndIncome("--", income: "--")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadExpenseAndIncome(_ expense: String?, income: String?) {
        if let _e = expense {
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: "Expense:\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 16)])
            attributeStr.append(NSAttributedString(string: _e, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#0B0A0A"), .font: UIFont.boldSystemFont(ofSize: 21)]))
            self.expenseLab.attributedText = attributeStr
        }
        
        if let _i = income {
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: "Income:\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 16)])
            attributeStr.append(NSAttributedString(string: _i, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#0B0A0A"), .font: UIFont.boldSystemFont(ofSize: 21)]))
            self.incomeLab.attributedText = attributeStr
        }
    }
}

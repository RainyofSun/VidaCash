//
//  VCAuditBKBillDetailsItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

enum AuditBKBillDetailsItemType: String {
    case BillingDate = "Billing date"
    case Remark = "Remark"
    case Appendix = "Receipt"
    case LocationInformation = "Location Information"
    case RecordingTime = "Recording time"
}

class VCAuditBKBillDetailsItem: UIControl {

    private lazy var leftLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 16), labelColor: UIColor.hexStringColor(hexString: "#595F67"))
    private lazy var rightLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#595F67"))
    private lazy var rightImgView: UIImageView = UIImageView(frame: CGRectZero)
    
    init(frame: CGRect, itemType type: AuditBKBillDetailsItemType) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.corner(14)
        
        self.leftLab.text = type.rawValue

        self.rightLab.isHidden = type == .Appendix
        self.rightImgView.isHidden = !self.rightLab.isHidden
        self.rightImgView.corner(5)
        
        self.addSubview(self.leftLab)
        self.addSubview(self.rightLab)
        self.addSubview(self.rightImgView)
        
        self.leftLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
        }
        
        self.rightLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3)
            make.centerY.equalTo(self.leftLab)
        }
        
        self.rightImgView.snp.makeConstraints { make in
            make.right.equalTo(self.rightLab)
            make.centerY.equalToSuperview()
            make.size.equalTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadRightText(_ text: String?) {
        if !self.rightLab.isHidden {
            self.rightLab.text = text
        }
        
        if !self.rightImgView.isHidden, let _t = text, let _t_url = URL(string: _t) {
            self.rightImgView.setImageWith(_t_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
    }
}

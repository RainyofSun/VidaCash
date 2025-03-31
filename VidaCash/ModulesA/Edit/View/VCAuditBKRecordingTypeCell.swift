//
//  VCAuditBKRecordingTypeCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

class VCAuditBKRecordingTypeCell: UICollectionViewCell {

    private lazy var typeIconImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var typeLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#1C1C1C"))
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.typeLab.textColor = RED_COLOR_F21915
            } else {
                self.typeLab.textColor = BLACK_COLOR_0B0A0A
            }
//            self.typeLab.textColor = isSelected ? RED_COLOR_F21915 : UIColor.hexStringColor(hexString: "#1C1C1C")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.typeIconImgView.corner(24)
        
        self.contentView.addSubview(self.typeIconImgView)
        self.contentView.addSubview(self.typeLab)
        
        self.typeIconImgView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT)
        }
        
        self.typeLab.snp.makeConstraints { make in
            make.top.equalTo(self.typeIconImgView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadCellModel(_ model: VCAuditBKRecordingTypeModel) {
        if let _text_url = model.annie, let _url = URL(string: _text_url) {
            self.typeIconImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        self.typeLab.text = model.scorefor
    }
}

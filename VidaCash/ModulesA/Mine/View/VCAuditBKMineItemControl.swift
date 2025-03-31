//
//  VCAuditBKMineItemControl.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKMineItemControl: UIControl {

    open var jumpURL: String?
    
    private lazy var itemImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var itemTitleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: BLACK_COLOR_333333)
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "bk_mine_arrow"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.itemImgView)
        self.addSubview(self.itemTitleLab)
        self.addSubview(self.arrowImgView)
        
        self.itemImgView.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT)
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
        }
        
        self.itemTitleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.itemImgView)
            make.left.equalTo(self.itemImgView.snp.right).offset(PADDING_UNIT * 2)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.centerY.equalTo(self.itemImgView)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadBKMineItem(itemModel: VCAPPMineItemModel) {
        self.itemTitleLab.text = itemModel.endows
        if let _u = itemModel.mexican {
            if _u.hasPrefix("http") {
                if let _url = URL(string: _u) {
                    self.itemImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
                }
            } else {
                self.itemImgView.image = UIImage(named: _u)
            }
            
        }
        self.jumpURL = itemModel.stating
    }
}

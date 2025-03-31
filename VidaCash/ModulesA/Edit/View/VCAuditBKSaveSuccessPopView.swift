//
//  VCAuditBKSaveSuccessPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

class VCAuditBKSaveSuccessPopView: VCAuditBKBasePopView {

    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.corner(16).backgroundColor = .white
        return view
    }()
    
    private lazy var coinImgView: UIImageView = UIImageView(image: UIImage(named: "bk_pop_coin"))
    private lazy var coinLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 16), labelColor: UIColor.hexStringColor(hexString: "#1C1C1C"), labelText: "Transaction has been \nsuccessfully added")
    
    override func buildBKPopViews() {
        super.buildBKPopViews()
        self.imgContentView.image = UIImage(named: "bk_pop_bg3")
        
        self.imgContentView.addSubview(self.contentView)
        self.contentView.addSubview(self.coinImgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.coinLab)
    }
    
    override func layoutBKPopViews() {
        super.layoutBKPopViews()
        
        self.imgContentView.snp.remakeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(ScreenWidth * 0.773)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 3)
            make.bottom.equalTo(self.confirmBtn.snp.top).offset(-PADDING_UNIT * 3)
        }
        
        self.coinImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT * 1.5)
        }
        
        self.coinLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.coinImgView.snp.bottom)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
}

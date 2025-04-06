//
//  VCAPPLoanCertificationBannerCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit
import JXBanner

class VCAPPLoanCertificationBannerCell: JXBannerBaseCell {
    
    private lazy var stateLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: .white, labelText: VCAPPLanguageTool.localAPPLanguage("certification_uncomplete"))
    private lazy var edageImgView: UIImageView = UIImageView(image: UIImage(named: "certification_uncomplete"))
    
    open override func jx_addSubviews() {
        super.jx_addSubviews()
        imageView.addSubview(self.stateLab)
        imageView.addSubview(self.edageImgView)
        
        self.edageImgView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        self.stateLab.snp.makeConstraints { make in
            make.bottom.equalTo(self.edageImgView.snp.top).offset(-PADDING_UNIT * 9)
            make.left.equalToSuperview().offset(ScreenWidth * 0.4)
        }
    }
    
    public func reloadCellModel(_ model: VCAPPLoanBannerModel) {
        if model.complete_auth {
            self.stateLab.textColor = UIColor.init(hexString: "#00CE08")!
            self.edageImgView.image = UIImage(named: "certification_success")
            self.stateLab.text = VCAPPLanguageTool.localAPPLanguage("certification_complete")
        } else {
            self.stateLab.textColor = .white
            self.edageImgView.image = UIImage(named: "certification_uncomplete")
            self.stateLab.text = VCAPPLanguageTool.localAPPLanguage("certification_uncomplete")
        }
        
        if let _name = model.imgName {
            if _name.hasPrefix("http"), let _url = URL(string: _name) {
                self.imageView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
            } else {
                self.imageView.image = UIImage(named: _name)
            }
        }
    }
}

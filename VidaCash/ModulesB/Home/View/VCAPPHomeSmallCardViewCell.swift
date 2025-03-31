//
//  VCAPPHomeSmallCardViewCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

class VCAPPHomeSmallCardViewCell: UICollectionViewCell {
    
    private lazy var bgImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_loan_coll_bg"))
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var productImgView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var productTitleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), labelColor: RED_COLOR_F21915)
    private lazy var centerLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont.boldSystemFont(ofSize: 24)
        view.textColor = BLACK_COLOR_202020
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        view.baselineAdjustment = .alignCenters
        return view
    }()
    
    private lazy var centerLab1: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: GRAY_COLOR_999999)
    
    private(set) lazy var detailBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("", cornerRadius: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.detailBtn.isUserInteractionEnabled = false
        
        self.contentView.addSubview(self.bgImgView)
        self.bgImgView.addSubview(self.productImgView)
        self.bgImgView.addSubview(self.productTitleLab)
        self.bgImgView.addSubview(self.centerLab)
        self.bgImgView.addSubview(self.centerLab1)
        self.bgImgView.addSubview(self.detailBtn)
        
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.productImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 6)
            make.top.equalToSuperview().offset(PADDING_UNIT * 5)
            make.size.equalTo(32)
        }
        
        self.productTitleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.productImgView)
            make.left.equalTo(self.productImgView.snp.right).offset(PADDING_UNIT * 2)
            make.right.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.centerLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.top.equalTo(self.productImgView.snp.bottom).offset(PADDING_UNIT * 4)
        }
        
        self.centerLab1.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.centerLab)
            make.top.equalTo(self.centerLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.height.equalTo(20)
        }
        
        self.detailBtn.snp.makeConstraints { make in
            make.top.equalTo(self.centerLab1.snp.bottom).offset(PADDING_UNIT * 6)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadCollectionViewCellModel(model: VCAPPLoanProductModel) {
        if let _image_url = model.already, let _url = URL(string: _image_url) {
            self.productImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        self.productTitleLab.text = model.cinema
        
        self.centerLab.text = model.ethnic
        if let _rate = model.held, let _time = model.citizenship {
            self.centerLab1.text = _time + " " + _rate
        }
        
        self.detailBtn.setTitle(model.malaysia, for: UIControl.State.normal)
    }
}

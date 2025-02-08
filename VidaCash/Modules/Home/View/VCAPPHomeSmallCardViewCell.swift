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
    
    private lazy var productTitleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), labelColor: BLUE_COLOR_2C65FE)
    private lazy var centerLab: UILabel = UILabel.buildNormalLabel()
    private(set) lazy var detailBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton("", cornerRadius: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.detailBtn.isUserInteractionEnabled = false
        
        self.contentView.addSubview(self.bgImgView)
        self.bgImgView.addSubview(self.productImgView)
        self.bgImgView.addSubview(self.productTitleLab)
        self.bgImgView.addSubview(self.centerLab)
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
        
        self.detailBtn.snp.makeConstraints { make in
            make.top.equalTo(self.centerLab.snp.bottom).offset(PADDING_UNIT * 6)
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
            self.productImgView.setImageWith(_url, options: YYWebImageOptions.progressiveBlur)
        }
        
        self.productTitleLab.text = model.cinema
        
        if let _amount = model.ethnic, let _rate = model.held, let _time = model.citizenship {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT * 2
            let tempStr: NSMutableAttributedString = NSMutableAttributedString(string: _amount + "\n", attributes: [.foregroundColor: BLACK_COLOR_202020, .font: UIFont.boldSystemFont(ofSize: 24), .paragraphStyle: paraStyle])
            let tempStr1: NSAttributedString = NSAttributedString(string: _time + " " + _rate, attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 14)])
            tempStr.append(tempStr1)
            self.centerLab.attributedText = tempStr
        }
        
        self.detailBtn.setTitle(model.malaysia, for: UIControl.State.normal)
    }
}

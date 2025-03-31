//
//  VCAPPOrderTableViewCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit

protocol APPOrderTableViewCellProtocol: AnyObject {
    func didTouchLoanPrivacy(privacyUrl: String?)
}

class VCAPPOrderTableViewCell: UITableViewCell {

    weak open var cellDelegate: APPOrderTableViewCellProtocol?
    
    private lazy var cellBgView: UIImageView = UIImageView(image: UIImage(named: "order_cell_bg"))
    private lazy var productLogoImgView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var productTitleLab: UILabel = UILabel.buildVdidaCashNormalLabel(labelColor: BLACK_COLOR_202020)
    private lazy var protocolBtn: UIButton = UIButton.buildVidaCashNormalButton(titleColor: RED_COLOR_F21915)
    private lazy var productAmountLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.boldSystemFont(ofSize: 24), labelColor: RED_COLOR_F21915)
    private lazy var checkBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("", cornerRadius: 19)
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = PINK_COLOR_FFE9DD
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private var privacyURL: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = .clear
        
        self.productAmountLab.textAlignment = .left
        
        self.protocolBtn.isHidden = true
        self.protocolBtn.addTarget(self, action: #selector(clickLoanPrivacy(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.cellBgView)
        self.cellBgView.addSubview(self.productLogoImgView)
        self.cellBgView.addSubview(self.productTitleLab)
        self.cellBgView.addSubview(self.protocolBtn)
        self.cellBgView.addSubview(self.productAmountLab)
        self.cellBgView.addSubview(self.checkBtn)
        self.cellBgView.addSubview(self.subContentView)
        
        self.cellBgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 1.5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
        }
        
        self.productLogoImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 4.5)
            make.left.equalToSuperview().offset(PADDING_UNIT * 2.5)
            make.size.equalTo(30)
        }
        
        self.productTitleLab.snp.makeConstraints { make in
            make.left.equalTo(self.productLogoImgView.snp.right).offset(PADDING_UNIT)
            make.centerY.equalTo(self.productLogoImgView)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.4)
        }
        
        self.protocolBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.productTitleLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
        
        self.productAmountLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalTo(self.productLogoImgView.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.productAmountLab)
            make.right.equalTo(self.protocolBtn)
            make.size.equalTo(CGSize(width: 130, height: 38))
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalTo(self.checkBtn.snp.bottom).offset(PADDING_UNIT * 2)
            make.height.greaterThanOrEqualTo(70)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = convert(point, to: self.protocolBtn)
        if self.protocolBtn.point(inside: convertedPoint, with: event), !self.protocolBtn.isHidden {
            return self.protocolBtn // 让按钮优先响应事件
        }
        
        return super.hitTest(point, with: event) // 其他情况下调用父类的hitTest方法
    }
    
    public func reloadCellSourceData(cellModel: VCAPPOrderItemModel) {
        self.privacyURL = cellModel.beautiful
        
        if let _imgUrl = cellModel.already, let _url = URL(string: _imgUrl) {
            self.productLogoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        self.productTitleLab.text = cellModel.cinema
        self.productAmountLab.text = cellModel.adding
        self.checkBtn.setTitle(cellModel.malaysia, for: UIControl.State.normal)
        if let _privacy = cellModel.compelling {
            self.protocolBtn.setAttributedTitle(NSAttributedString(string: _privacy, attributes: [.foregroundColor: RED_COLOR_F21915, .font: UIFont.systemFont(ofSize: 14), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: RED_COLOR_F21915]), for: UIControl.State.normal)
            self.protocolBtn.isHidden = false
        } else {
            self.protocolBtn.setAttributedTitle(nil, for: UIControl.State.normal)
            self.protocolBtn.isHidden = true
        }
        
        if let _models = cellModel.thing {
            self.buildLoanInfoItem(models: _models)
        }
    }
}

private extension VCAPPOrderTableViewCell {
    func buildLoanInfoItem(models: [VCAPPCommonModel]) {
        self.subContentView.removeAllSubviews()
        
        var _temp_item: VCAPPOrderLoanInfoItem?
        
        models.enumerated().forEach { (idx: Int, model: VCAPPCommonModel) in
            let view = VCAPPOrderLoanInfoItem(frame: CGRectZero)
            view.reloadLoanInfoItem(model: model)
            self.subContentView.addSubview(view)
            
            if let _temp = _temp_item {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_temp)
                        make.top.equalTo(_temp.snp.bottom).offset(PADDING_UNIT)
                        make.bottom.equalToSuperview().offset(-PADDING_UNIT * 2)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_temp)
                        make.top.equalTo(_temp.snp.bottom).offset(PADDING_UNIT)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(PADDING_UNIT)
                    make.top.equalToSuperview().offset(PADDING_UNIT * 2)
                }
            }
            
            _temp_item = view
        }
    }
}

@objc private extension VCAPPOrderTableViewCell {
    func clickLoanPrivacy(sender: UIButton) {
        self.cellDelegate?.didTouchLoanPrivacy(privacyUrl: self.privacyURL)
    }
}

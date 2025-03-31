//
//  VCAPPHomeTopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

class VCAPPHomeTopView: UIImageView {

    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var amountLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.specialFont(62), labelColor: .white)
    private lazy var lineView: UIView = UIView(frame: CGRectZero)
    private lazy var timeLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var rateLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentMode = .scaleAspectFill
        self.image = UIImage(named: "home_top_img")
        self.isUserInteractionEnabled = true
        
        self.addSubview(self.titleLab)
        self.addSubview(self.amountLab)
        self.addSubview(self.lineView)
        self.addSubview(self.timeLab)
        self.addSubview(self.rateLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(ScreenWidth * 1.44 * 0.31)
        }
        
        self.amountLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLab.snp.bottom)
        }
        
        self.lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.amountLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.size.equalTo(CGSize(width: 1, height: 30))
        }
        
        self.timeLab.snp.makeConstraints { make in
            make.right.equalTo(self.lineView.snp.left).offset(-PADDING_UNIT * 2.5)
            make.top.equalTo(self.lineView)
        }
        
        self.rateLab.snp.makeConstraints { make in
            make.left.equalTo(self.lineView.snp.right).offset(PADDING_UNIT * 2.5)
            make.top.equalTo(self.lineView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadTopRecommondModel(model: VCAPPLoanProductModel) {
        if let _name = model.whereas {
            let tempStr1: NSMutableAttributedString = NSAttributedString.attachmentImage("home_loan_white_dot", afterText: false, imagePosition: 2, attributeString: _name, textColor: .white, textFont: UIFont.specialFont(16))
            tempStr1.append(NSAttributedString.attachmentImage("home_loan_white_dot", afterText: true, imagePosition: 2, attributeString: "", textColor: UIColor.white, textFont: UIFont.specialFont(16)))
            self.titleLab.attributedText = tempStr1
        }
        
        self.amountLab.text = model.ethnic
        if let _text1 = model.citizenship, let _text2 = model.chinese {
            self.timeLab.attributedText = NSAttributedString.attributeText1(_text1, text1Color: .white, text1Font: UIFont.systemFont(ofSize: 14), text2: _text2, text2Color: .white, text1Font: UIFont.systemFont(ofSize: 10), paramDistance: PADDING_UNIT, paraAlign: NSTextAlignment.center)
        }

        if let _text1 = model.held, let _text2 = model.roles {
            self.rateLab.attributedText = NSAttributedString.attributeText1(_text1, text1Color: .white, text1Font: UIFont.systemFont(ofSize: 14), text2: _text2, text2Color: .white, text1Font: UIFont.systemFont(ofSize: 10), paramDistance: PADDING_UNIT, paraAlign: NSTextAlignment.center)
        }
    }
    
    public func reloadProductModel(model: VCAPPProductModel) {
        if let _name = model.below {
            let tempStr1: NSMutableAttributedString = NSAttributedString.attachmentImage("home_loan_white_dot", afterText: false, imagePosition: 2, attributeString: _name, textColor: .white, textFont: UIFont.specialFont(16))
            tempStr1.append(NSAttributedString.attachmentImage("home_loan_white_dot", afterText: true, imagePosition: 2, attributeString: "", textColor: UIColor.white, textFont: UIFont.specialFont(16)))
            self.titleLab.attributedText = tempStr1
        }
        
        self.amountLab.text = model.exudes
        if let _model1 = model.scholarly?.abandons, let _text1 = _model1.says, let _text2 = _model1.endows {
            self.timeLab.attributedText = NSAttributedString.attributeText1(_text1, text1Color: .white, text1Font: UIFont.systemFont(ofSize: 14), text2: _text2, text2Color: .white, text1Font: UIFont.systemFont(ofSize: 10), paramDistance: PADDING_UNIT, paraAlign: NSTextAlignment.center)
        }

        if let _model1 = model.scholarly?.visual, let _text1 = _model1.says, let _text2 = _model1.endows {
            self.rateLab.attributedText = NSAttributedString.attributeText1(_text1, text1Color: .white, text1Font: UIFont.systemFont(ofSize: 14), text2: _text2, text2Color: .white, text1Font: UIFont.systemFont(ofSize: 10), paramDistance: PADDING_UNIT, paraAlign: NSTextAlignment.center)
        }
    }
}

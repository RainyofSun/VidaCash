//
//  VCAPPSettingCancelPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/3.
//

import UIKit

protocol APPSettingCancelPopProtocol: AnyObject {
    func didConfirmCancel(sender: VCAPPLoadingButton, popView: VCAPPSettingCancelPopView)
}

class VCAPPSettingCancelPopView: VCAPPBasePopView {
    
    weak open var cancelDelegate: APPSettingCancelPopProtocol?
    
    private lazy var tipLab: UILabel = UILabel.buildNormalLabel()
    private lazy var agreeBtn: UIButton = UIButton.buildImageButton("login_protocol_nor", selectedImg: "login_protocol_sel")
    private lazy var protocolLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15),labelColor: GRAY_COLOR_999999, labelText: VCAPPLanguageTool.localAPPLanguage("mine_setting_pop_tip3"))
    private lazy var cancelBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("mine_setting_pop_title"), cornerRadius: 25)
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("mine_setting_pop_title1")
        self.protocolLab.textAlignment = .left
        
        let tempStr: NSMutableAttributedString = NSMutableAttributedString(string: VCAPPLanguageTool.localAPPLanguage("mine_setting_pop_tip1"), attributes: [.foregroundColor: UIColor.init(hexString: "#110A3E")!, .font: UIFont.systemFont(ofSize: 15)])
        tempStr.append(NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("mine_setting_pop_tip2"), attributes: [.foregroundColor: UIColor.init(hexString: "#FC501E")!, .font: UIFont.systemFont(ofSize: 15)]))
        self.tipLab.attributedText = tempStr
        
        self.agreeBtn.addTarget(self, action: #selector(clickAgreeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(clickCCancelButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.tipLab)
        self.contentView.addSubview(self.agreeBtn)
        self.contentView.addSubview(self.protocolLab)
        self.contentView.addSubview(self.cancelBtn)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.tipLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 17.5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
        }
        
        self.agreeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 5)
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.size.equalTo(25)
        }
        
        self.protocolLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.agreeBtn)
            make.left.equalTo(self.agreeBtn.snp.right).offset(PADDING_UNIT * 2)
            make.right.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.agreeBtn.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPSettingCancelPopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

@objc private extension VCAPPSettingCancelPopView {
    func clickAgreeButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func clickCCancelButton(sender: VCAPPLoadingButton) {
        if !self.agreeBtn.isSelected {
            self.makeToast(VCAPPLanguageTool.localAPPLanguage("cancel_agree_cancel_protocol"))
            return
        }
        
        self.cancelDelegate?.didConfirmCancel(sender: sender, popView: self)
    }
}

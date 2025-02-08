//
//  VCAPPLoginPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/2.
//

import UIKit

protocol APPLoginPopProtocol: AnyObject {
    func getSmsCode(sender: VCAPPTimerButton, phone: String?)
    func getVoiceCode(sender: UIButton, phone: String?)
    func gotoLogin(phone: String?, code: String?, sender: VCAPPLoadingButton)
    func gotoPrivacyAgreement()
}

class VCAPPLoginPopView: VCAPPBasePopView {
    
    weak open var loginDelegate: APPLoginPopProtocol?
    
    private var timerButton: VCAPPTimerButton?
    
    private lazy var phoneTextFiled: VCAPPNoActionTextFiled = {
        let tempStr: NSAttributedString = NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("login_pop_phone_placeholder"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 15)])
        let view = VCAPPNoActionTextFiled.buildNormalTextFiled(placeHolder: tempStr)
        return view
    }()
    
    private lazy var codeTextFiled: VCAPPNoActionTextFiled = {
        let tempStr: NSAttributedString = NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("login_pop_code_placeholder"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 15)])
        let view = VCAPPNoActionTextFiled.buildNormalTextFiled(placeHolder: tempStr)
        let timerBtn = VCAPPTimerButton(frame: CGRectZero)
        view.rightView = timerBtn
        view.rightViewMode = .always
        self.timerButton = timerBtn
        return view
    }()
    
    private lazy var voiceBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setAttributedTitle(NSAttributedString.attachmentImage("login_voice_code", afterText: false, imagePosition: -3, attributeString: VCAPPLanguageTool.localAPPLanguage("login_pop_voice_code"), textColor: BLUE_COLOR_2C65FE, textFont: UIFont.systemFont(ofSize: 15)), for: UIControl.State.normal)
        return view
    }()
    
    private lazy var loginBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("login_pop_title"), cornerRadius: 25)
    
    private lazy var protocolLab: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.titleLabel?.numberOfLines = .zero
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: VCAPPLanguageTool.localAPPLanguage("login_pop_protocol1"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 13)])
        attributeStr.append(NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("login_pop_protocol2"), attributes: [.foregroundColor: BLUE_COLOR_2C65FE, .font: UIFont.systemFont(ofSize: 13), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: BLUE_COLOR_2C65FE]))
        view.setAttributedTitle(attributeStr, for: UIControl.State.normal)
        return view
    }()
    
    private lazy var agreeBtn: UIButton = {
        let view = UIButton.buildImageButton("login_protocol_nor", selectedImg: "login_protocol_sel")
        view.isSelected = true
        return view
    }()
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("login_pop_title")
        
        self.voiceBtn.addTarget(self, action: #selector(clickVoiceCodeBtn(sender: )), for: UIControl.Event.touchUpInside)
        self.loginBtn.addTarget(self, action: #selector(clickLoginButton(sender: )), for: UIControl.Event.touchUpInside)
        self.agreeBtn.addTarget(self, action: #selector(clickAgreeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.protocolLab.addTarget(self, action: #selector(clickProtocolBtn), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.phoneTextFiled)
        self.contentView.addSubview(self.codeTextFiled)
        self.contentView.addSubview(self.voiceBtn)
        self.contentView.addSubview(self.loginBtn)
        self.contentView.addSubview(self.agreeBtn)
        self.contentView.addSubview(self.protocolLab)
        
        self.timerButton?.addTarget(self, action: #selector(clickSmsCodeBtn(sender: )), for: UIControl.Event.touchUpInside)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.phoneTextFiled.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.height.equalTo(44)
        }
        
        self.codeTextFiled.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.phoneTextFiled)
            make.top.equalTo(self.phoneTextFiled.snp.bottom).offset(PADDING_UNIT * 5)
        }
        
        self.voiceBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.codeTextFiled.snp.bottom).offset(PADDING_UNIT * 3)
        }
        
        self.loginBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.codeTextFiled)
            make.top.equalTo(self.voiceBtn.snp.bottom).offset(PADDING_UNIT * 5)
            make.height.equalTo(50)
        }
        
        self.protocolLab.snp.makeConstraints { make in
            make.top.equalTo(self.loginBtn.snp.bottom).offset(PADDING_UNIT * 5)
            make.right.equalTo(self.loginBtn)
            make.left.equalTo(self.agreeBtn.snp.right).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.agreeBtn.snp.makeConstraints { make in
            make.left.equalTo(self.loginBtn)
            make.size.equalTo(20)
            make.centerY.equalTo(self.protocolLab)
        }
    }
    
    func showCodeKeyboard() {
        if self.codeTextFiled.canBecomeFirstResponder {
            self.codeTextFiled.becomeFirstResponder()
        }
    }
    
    func showPhoneKeyboard() {
        if self.phoneTextFiled.canBecomeFirstResponder {
            self.phoneTextFiled.becomeFirstResponder()
        }
    }
    
    func clearCodeText() {
        self.codeTextFiled.shakeAnimation(horizontal, repeatCount: 5, anmationTime: 0.1, offset: 3) {
            self.codeTextFiled.text = ""
            self.showCodeKeyboard()
        }
    }
    
    func stopSMSCodeTimer() {
        self.timerButton?.stop()
        self.timerButton = nil
    }
}

@objc private extension VCAPPLoginPopView {
    func clickSmsCodeBtn(sender: VCAPPTimerButton) {
        self.loginDelegate?.getSmsCode(sender: sender, phone: self.phoneTextFiled.text)
    }
    
    func clickVoiceCodeBtn(sender: UIButton) {
        self.loginDelegate?.getVoiceCode(sender: sender, phone: self.phoneTextFiled.text)
    }
    
    func clickAgreeButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func clickProtocolBtn() {
        self.loginDelegate?.gotoPrivacyAgreement()
    }
    
    func clickLoginButton(sender: VCAPPLoadingButton) {
        if !self.agreeBtn.isSelected {
            self.makeToast(VCAPPLanguageTool.localAPPLanguage("login_pop_agree_protocol"))
            return
        }
        self.loginDelegate?.gotoLogin(phone: self.phoneTextFiled.text, code: self.codeTextFiled.text, sender: sender)
    }
}

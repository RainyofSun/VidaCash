//
//  VCAPPSettingLogoutPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit

protocol APPSettingLogoutPopProtocol: AnyObject {
    func didConfirmLogout(sender: VCAPPLoadingButton, popView: VCAPPSettingLogoutPopView)
}

class VCAPPSettingLogoutPopView: VCAPPBasePopView {

    weak open var logoutDelegate: APPSettingLogoutPopProtocol?
    
    private lazy var tipLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: BLACK_COLOR_202020, labelText: VCAPPLanguageTool.localAPPLanguage("mine_setting_logout_tip"))
    private lazy var logoutBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("mine_setting_logout_title"), cornerRadius: 25)
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("mine_setting_logout")
        
        self.logoutBtn.addTarget(self, action: #selector(clickCCancelButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.tipLab)
        self.contentView.addSubview(self.logoutBtn)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.tipLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
        }
        
        self.logoutBtn.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPSettingLogoutPopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

@objc private extension VCAPPSettingLogoutPopView {
    func clickCCancelButton(sender: VCAPPLoadingButton) {
        self.logoutDelegate?.didConfirmLogout(sender: sender, popView: self)
    }
}

//
//  VCAPPSettingViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPSettingViewController: VCAPPBaseViewController {
    
    private lazy var logoImgView: UIImageView = UIImageView(image: UIImage(named: "mine_setting_logo"))
    private lazy var versionView: VCAPPMineSettingItem = VCAPPMineSettingItem(frame: CGRectZero, settingType: MineSettingType.Version)
    private lazy var cancelView: VCAPPMineSettingItem = VCAPPMineSettingItem(frame: CGRectZero, settingType: MineSettingType.Cancelation)
    private lazy var logoutView: VCAPPMineSettingItem = VCAPPMineSettingItem(frame: CGRectZero, settingType: MineSettingType.Logout)
    
    override func buildViewUI() {
        super.buildViewUI()
        self.title = VCAPPLanguageTool.localAPPLanguage("mine_setting_title")
        
        self.cancelView.addTarget(self, action: #selector(clickCancelItem(sender: )), for: UIControl.Event.touchUpInside)
        self.logoutView.addTarget(self, action: #selector(clicklogoutItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.logoImgView)
        self.contentView.addSubview(self.versionView)
        self.contentView.addSubview(self.cancelView)
        self.contentView.addSubview(self.logoutView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.logoImgView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 5)
        }
        
        self.versionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(PADDING_UNIT * 9)
        }
        
        self.cancelView.snp.makeConstraints { make in
            make.left.equalTo(self.versionView.snp.right).offset(PADDING_UNIT * 2)
            make.right.equalTo(self.view).offset(-PADDING_UNIT * 4)
            make.top.width.equalTo(self.versionView)
        }
        
        self.logoutView.snp.makeConstraints { make in
            make.left.width.equalTo(self.versionView)
            make.top.equalTo(self.versionView.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
}

@objc private extension VCAPPSettingViewController {
    func clickCancelItem(sender: VCAPPMineSettingItem) {
        VCAPPSettingCancelPopView.convenienceShowPop(self.view).cancelDelegate = self
    }
    
    func clicklogoutItem(sender: VCAPPMineSettingItem) {
        VCAPPSettingLogoutPopView.convenienceShowPop(self.view).logoutDelegate = self
    }
}

extension VCAPPSettingViewController: APPSettingCancelPopProtocol {
    func didConfirmCancel(sender: VCAPPLoadingButton, popView: VCAPPSettingCancelPopView) {
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/whereas", requestParams: nil)) {[weak self] _, _ in
            sender.stopAnimation()
            popView.dismissPop()
            // 删除本地消息
            VCAPPCommonInfo.shared.deleteLocalLoginInfo()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension VCAPPSettingViewController: APPSettingLogoutPopProtocol {
    func didConfirmLogout(sender: VCAPPLoadingButton, popView: VCAPPSettingLogoutPopView) {
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/asia", requestParams: nil)) {[weak self] _, _ in
            sender.stopAnimation()
            popView.dismissPop()
            // 删除本地消息
            VCAPPCommonInfo.shared.deleteLocalLoginInfo()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

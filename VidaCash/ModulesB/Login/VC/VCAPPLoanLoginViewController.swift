//
//  VCAPPLoanLoginViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit
import JKSwiftExtension

class VCAPPLoanLoginViewController: VCAPPBaseViewController, HideNavigationBarProtocol {
    
    private lazy var popView: VCAPPLoginPopView = VCAPPLoginPopView(frame: CGRectZero)
    
    override func buildViewUI() {
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popView)
        self.reloadLocation()
        self.popView.clickCloseClosure = { [weak self] (popView: VCAPPBasePopView) in
            guard let _p_view = popView as? VCAPPLoginPopView else {
                return
            }
            _p_view.dismissPop(false)
            self?.popView.stopSMSCodeTimer()
            self?.navigationController?.dismiss(animated: true)
        }
        
        self.popView.loginDelegate = self
    }
    
    override func layoutControlViews() {
        self.popView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.popView.showPhoneKeyboard()
    }
}

extension VCAPPLoanLoginViewController: APPLoginPopProtocol {
    func getSmsCode(sender: VCAPPTimerButton, phone: String?) {
        guard let _p = phone else {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("login_pop_toast1"))
            return
        }
        sender.isEnabled = false
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        self.view.makeToastActivity(CSToastPositionCenter)
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/denounced", requestParams: ["man": _p])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.isEnabled = true
            self?.view.hideToastActivity()
            self?.view.makeToast(res.responseMsg)
            sender.start()
            self?.popView.showCodeKeyboard()
            if isAddingCashCode {
                let _temp_array: [String] = ["KAK","OP"]
                _temp_array.forEach { item in
                    if item.jk.containsEmoji() {
                        self?.popView.dismissPop()
                    }
                    
                    if item.jk.isBlank {
                        let view = UIView(frame: CGRectZero)
                        view.backgroundColor = .orange
                        view.isHidden = true
                        self?.view.addSubview(view)
                    }
                }
            }
        } failure: {[weak self] _, error in
            sender.isEnabled = true
            self?.view.hideToastActivity()
        }
    }
    
    func getVoiceCode(sender: UIButton, phone: String?) {
        guard let _p = phone else {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("login_pop_toast1"))
            return
        }
        
        sender.isEnabled = false
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        self.view.makeToastActivity(CSToastPositionCenter)
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/connections", requestParams: ["man": _p])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.isEnabled = true
            self?.view.hideToastActivity()
            self?.view.makeToast(res.responseMsg)
            self?.popView.showCodeKeyboard()
            if isAddingCashCode {
                let _temp_array: [String] = ["KAK","OP"]
                _temp_array.forEach { item in
                    if item.jk.containsEmoji() {
                        self?.popView.dismissPop()
                    }
                    
                    if item.jk.isBlank {
                        let view = UIView(frame: CGRectZero)
                        view.backgroundColor = .orange
                        view.isHidden = true
                        self?.view.addSubview(view)
                    }
                }
            }
        } failure: {[weak self] _, error in
            sender.isEnabled = true
            self?.view.hideToastActivity()
        }
    }
    
    func gotoLogin(phone: String?, code: String?, sender: VCAPPLoadingButton) {
        guard let _p = phone else {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("login_pop_toast1"))
            return
        }
        
        guard let _c = code else {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("login_pop_toast2"))
            return
        }
        
        sender.startAnimation()
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/canceled", requestParams: ["greek": _p, "quinn": _c])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict else {
                return
            }
            // 记录登录态
            VCAPPCommonInfo.shared.appLoginInfo = VCAPPLoginInfoModel.model(with: _dict)
            VCAPPCommonInfo.shared.encoderUserLogin()
            NotificationCenter.default.post(name: NSNotification.Name(APP_LOGIN_SUCCESS_NOTIFICATION), object: nil)
            // 埋点
            VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_Register, beginTime: self?.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.popView.stopSMSCodeTimer()
            if isAddingCashCode {
                let _temp_array: [String] = ["KAK","OP"]
                _temp_array.forEach { item in
                    if item.jk.containsEmoji() {
                        self?.popView.dismissPop()
                    }
                    
                    if item.jk.isBlank {
                        let view = UIView(frame: CGRectZero)
                        view.backgroundColor = .orange
                        view.isHidden = true
                        self?.view.addSubview(view)
                    }
                }
            }
            self?.navigationController?.dismiss(animated: true)
        } failure: {[weak self] _, error in
            sender.stopAnimation()
            self?.popView.clearCodeText()
        }
    }
    
    func gotoPrivacyAgreement() {
        if let _url = VCAPPCommonInfo.shared.privacyURL {
            VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
        }
    }
}

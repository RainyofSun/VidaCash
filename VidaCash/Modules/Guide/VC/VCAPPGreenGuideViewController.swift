//
//  VCAPPGreenGuideViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit
import FBSDKCoreKit

protocol GreenGuideProtocol: AnyObject {
    func guideDidDismiss()
}

class VCAPPGreenGuideViewController: VCAPPBaseViewController {

    weak open var guideDelegate: GreenGuideProtocol?
    
    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "launch_img"))
    private lazy var tryButton: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("guide_try_title"), cornerRadius: 25)
    private lazy var pageControl: VCAPPGreenGuidePageControl = {
        let pageControl = VCAPPGreenGuidePageControl(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: 30)))
        pageControl.currentColor = BLUE_COLOR_2C65FE
        pageControl.otherColor = UIColor.init(red: 148/255.0, green: 170/255.0, blue: 249/255.0, alpha: 1)
        pageControl.pointCornerRadius = 3
        pageControl.currentPointSize = CGSize(width: 12, height: 6)
        pageControl.otherPointSize = CGSize(width: 6, height: 6)
        pageControl.pageAliment = .Center
        pageControl.numberOfPages = 3
        pageControl.controlSpacing = 3
        pageControl.leftAndRightSpacing = 10
        pageControl.isHidden = true
        return pageControl
    }()
    
    private lazy var guideScrollView: VCAPPGreenGuideScrollView = VCAPPGreenGuideScrollView(frame: CGRectZero)
    
    override func buildViewUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange(notification: )), name: NSNotification.Name(APP_NET_STATE_CHANGE), object: nil)
        
        self.tryButton.addTarget(self, action: #selector(clickTryButton(sender: )), for: UIControl.Event.touchUpInside)
        self.tryButton.isHidden = true
        
        self.view.addSubview(self.bgImgView)
        self.view.addSubview(self.guideScrollView)
        self.view.addSubview(self.tryButton)
        self.view.addSubview(self.pageControl)
        
#if DEBUG
        self.pageRequest()
#else
        if !VCAPPDiskCache.readAPPInstallRecord() {
            self.pageRequest()
        }
#endif
    }
    
    override func layoutControlViews() {
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tryButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 9)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - 130)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: ScreenWidth, height: 30))
            make.bottom.equalTo(self.tryButton.snp.top)
        }
        
        self.guideScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.guideScrollView.layoutGuideScrollView(dependView: self.pageControl)
    }

    override func pageRequest() {
        super.pageRequest()
        var languageCode: String = "en"
        if #available(iOS 16, *) {
            languageCode = Locale.current.language.languageCode?.identifier ?? languageCode
        } else {
            languageCode = Locale.current.languageCode ?? languageCode
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/embarrassment", requestParams: ["embarrassment": languageCode, "denounced": "0", "connections": "0"])) {[weak self] (task: URLSessionDataTask, response: VCAPPSuccessResponse) in
            guard let _dict = response.jsonDict, let resModel: VCAPPGreenGuideModel = VCAPPGreenGuideModel.model(with: _dict) else {
                return
            }
            self?.tryButton.isHidden = false
            VCAPPCommonInfo.shared.isAppInitializationSuccess = true
            VCAPPCommonInfo.shared.privacyURL = resModel.wartime
            VCAPPCommonInfo.shared.countryCode = resModel.atrocities
            // 存储语言
            VCAPPDiskCache.saveAPPLanuageToDisk(resModel.atrocities)
            // 初始化多语言
            VCAPPLanguageTool.setAPPLocalLanguage(VCAPPDiskCache.readAPPLanguageFormDiskCache())
            if resModel.oppTe == 1 && VCAPPAuthorizationTool.authorization().locationAuthorization() != Authorized && VCAPPAuthorizationTool.authorization().locationAuthorization() != Limited && VCAPPDiskCache.todayShouldShowLocationAlert() {
                // 弹出定位授权弹窗
                self?.showSystemStyleSettingAlert(content: VCAPPLanguageTool.localAPPLanguage("alert_location"))
            }
#if DEBUG
#else
            self?.initializationFaceBook(facebookModel: resModel.face)
#endif
            self?.guideScrollView.reloadGuideText()
            UIView.animate(withDuration: 0.3) {
                self?.guideScrollView.alpha = 1
                self?.pageControl.isHidden = false
            }
            
            self?.tryButton.setTitle(VCAPPLanguageTool.localAPPLanguage("guide_next"), for: UIControl.State.normal)
        } failure: {[weak self] _, error in
            self?.tryButton.isHidden = false
            self?.switchAPPRequestDomain()
        }
    }
}

private extension VCAPPGreenGuideViewController {
    func initializationFaceBook(facebookModel: VCAPPFaceBookModel) {
        Settings.shared.appID = facebookModel.community
        Settings.shared.displayName = facebookModel.asian
        Settings.shared.clientToken = facebookModel.zorba
        Settings.shared.appURLSchemeSuffix = facebookModel.offensive
        Settings.shared.isAutoLogAppEventsEnabled = true
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }
    
    func switchAPPRequestDomain() {
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig(Dynamic_Domain_Name_URL + Dynamic_Domain_Name_Path, requestParams: nil)
        config.requestType = .download
        VCAPPNetRequestManager.afnReqeustType(config) {[weak self] (task: URLSessionDataTask, response: VCAPPSuccessResponse) in
            guard let _str = response.responseMsg, let _domain_models = NSArray.modelArray(with: VCAPPDynamicDomainModel.self, json: _str) as? [VCAPPDynamicDomainModel] else {
                return
            }
            
            for item in _domain_models {
                if let _url = item.ac, VCAPPNetRequestURLConfig.reloadNetworkRequestDomainURL(_url) {
                    VCAPPNetRequestConfig.reloadNetworkRequestURL()
                    self?.pageRequest()
                    break
                }
            }
        }
    }
}

@objc extension VCAPPGreenGuideViewController {
    func networkChange(notification: Notification) {
        if let _state = notification.object as? VCAPPNetworkObserver.NetworkStatus, _state != .NetworkStatus_NoNet, VCAPPDiskCache.readAPPInstallRecord() {
            // 第一次安装时,等到网络重新授权时,重新请求初始化
            self.pageRequest()
            // 关闭网络监测
            VCAPPNetworkObserver.shared.StopNetworkObserverListener()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func clickTryButton(sender: VCAPPLoadingButton) {
        if self.guideScrollView.alpha == .zero {
            self.pageRequest()
        } else {
            if self.guideScrollView.contentOffset == .zero {
                self.guideScrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
                self.pageControl.exchangePointView(0, 1)
            } else if self.guideScrollView.contentOffset.x == ScreenWidth {
                self.guideScrollView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
                self.pageControl.exchangePointView(1, 2)
            } else {
                self.guideDelegate?.guideDidDismiss()
            }
        }
    }
}

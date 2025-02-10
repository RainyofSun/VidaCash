//
//  VCAPPLoanHomeViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPLoanHomeViewController: VCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var topView: VCAPPHomeTopView = VCAPPHomeTopView(frame: CGRectZero)
    private lazy var bigCardView: VCAPPHomeBigCardView = VCAPPHomeBigCardView(frame: CGRectZero)
    private lazy var smallCardView: VCAPPHomeSmallCardView = VCAPPHomeSmallCardView(frame: CGRectZero)
    
    private var _service_model: VCAPPServiceModel?
    private var _recommend_model: VCAPPLoanProductModel?
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.contentView.addMJRefresh(addFooter: false) {[weak self] (refresh: Bool) in
            self?.pageRequest()
        }
        
        self.bigCardView.bigDelegate = self
        self.smallCardView.smallDelegate = self
        
        self.contentView.addSubview(self.topView)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(APP_LOGIN_SUCCESS_NOTIFICATION), object: nil)
        
        self.downloadCity()
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.topView.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(ScreenWidth * 1.44)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        // 埋点上报
        self.reloadLocation()
        VCAPPBuryReport.VCAPPLocationReport()
        VCAPPBuryReport.VCAPPDeviceInfoReport()
        if VCAPPAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            VCAPPBuryReport.VCAPPIDFAAndIDFVReport()
        }
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/wartime", requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.contentView.refresh(begin: false)
            guard let _dict = res.jsonDict, let _model = VCAPPLoanHomeModel.model(withJSON: _dict) else {
                return
            }
            _model.filterHomeData()
            self?._service_model = _model.mexican
            if let _big = _model.bigCard?.first {
                // 更新大卡位
                self?.topView.reloadTopRecommondModel(model: _big)
                self?.updateHomeLayout(true)
                self?._recommend_model = _big
                self?.bigCardView.reloadApplyButtonTitle(_big.malaysia ?? "")
            }
            
            if let _small = _model.smallCard?.first {
                // 更新小卡位
                self?.topView.reloadTopRecommondModel(model: _small)
                self?.updateHomeLayout(false)
                self?._recommend_model = _small
                self?.smallCardView.reloadApplyButtonTitle(_small.malaysia ?? "")
                if let _small_source = _model.productList {
                    self?.smallCardView.reloadLoanProducts(_small_source)
                }
            }
            
        } failure: {[weak self] _, _ in
            self?.contentView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.contentView.refresh(begin: true)
    }
}

private extension VCAPPLoanHomeViewController {
    func updateHomeLayout(_ isBig: Bool) {
        self.smallCardView.isHidden = isBig
        self.bigCardView.isHidden = !isBig
        
        if isBig {
            self.smallCardView.snp.removeConstraints()
            self.contentView.addSubview(self.bigCardView)
            
            self.bigCardView.snp.makeConstraints { make in
                make.top.equalTo(self.topView.snp.top).offset(ScreenWidth * 0.862)
                make.horizontalEdges.equalTo(self.topView)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
            }
        } else {
            self.bigCardView.snp.removeConstraints()
            self.contentView.addSubview(self.smallCardView)
            
            self.smallCardView.snp.makeConstraints { make in
                make.top.equalTo(self.topView.snp.top).offset(ScreenWidth * 0.862)
                make.horizontalEdges.equalTo(self.topView)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
            }
        }
    }
    
    func downloadCity() {
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("v3/certify/city-init", requestParams: nil)) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _json_array = res.jsonArray as? NSArray, let _json = _json_array.modelToJSONString() else {
                return
            }
            
            VCAPPCertificationCityModel.writeCitySourceToDisk(_json)
        }
    }
}

extension VCAPPLoanHomeViewController: APPHomeSmallCardProtocol {
    func gotoProductApply(sender: VCAPPLoadingButton) {
        self.gotoApply(sender: sender)
    }
    
    func didSelectedLoanProduct(_ model: VCAPPLoanProductModel, sender: VCAPPLoadingButton) {
        guard let _product_id = model.defended, sender.isEnabled else {
            return
        }
        
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/face", requestParams: ["despair": _product_id])) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _auth_model = VCAPPLoanProductAuthModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _url = _auth_model.stating else {
                return
            }
            
            VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
            
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

extension VCAPPLoanHomeViewController: APPHomeBigCardProtocol {
    func gotoApply(sender: VCAPPLoadingButton) {
        guard let _product_id = self._recommend_model?.defended else {
            return
        }
        
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/face", requestParams: ["despair": _product_id])) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _auth_model = VCAPPLoanProductAuthModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _url = _auth_model.stating else {
                return
            }
            
            VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
            
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
    
    func gotoService() {
        guard VCAPPCommonInfo.shared.appLoginInfo != nil else {
            VCAPPPageRouter.shared().appPageRouter(APP_LOGIN_PAGE, backToRoot: true, targetVC: nil)
            return
        }
        
        guard let _url = self._service_model?.examples else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
    }
    
    func gotoAboutUs() {
        guard VCAPPCommonInfo.shared.appLoginInfo != nil else {
            VCAPPPageRouter.shared().appPageRouter(APP_LOGIN_PAGE, backToRoot: true, targetVC: nil)
            return
        }
        
        guard let _url = self._service_model?.power else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
    }
}

@objc private extension VCAPPLoanHomeViewController {
    func loginSuccess() {
        self.pageRequest()
    }
}

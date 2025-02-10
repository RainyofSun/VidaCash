//
//  VCAPPLoanProductViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPLoanProductViewController: VCAPPBaseViewController {

    private lazy var topView: VCAPPHomeTopView = VCAPPHomeTopView(frame: CGRectZero)
    private lazy var certificationView: VCAPPLoanCertificationView = VCAPPLoanCertificationView(frame: CGRectZero)
    private lazy var agreeBtn: UIButton = UIButton.buildImageButton("login_protocol_nor", selectedImg: "login_protocol_sel")
    private lazy var protocolBtn: UIButton = UIButton.buildNormalButton(titleColor: BLUE_COLOR_2C65FE)
    private lazy var loanBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton("", cornerRadius: 25)
    
    private var id_number: String?
    private var _protocol_url: String?
    private var _wait_certification_model: VCAPPWaitCertificationModel?
    private var _certification_models: [VCAPPCertificationModel]?
    private var _loan_number: String?
    
    init(withLoanProductIDNumber idNumber: String) {
        super.init(nibName: nil, bundle: nil)
        self.id_number = idNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.agreeBtn.isHidden = true
        self.protocolBtn.isHidden = true
        self.agreeBtn.isSelected = true
        
        self.agreeBtn.addTarget(self, action: #selector(clickAgreeBtn(sender: )), for: UIControl.Event.touchUpInside)
        self.protocolBtn.addTarget(self, action: #selector(clickProtocolButton(sender: )), for: UIControl.Event.touchUpInside)
        self.loanBtn.addTarget(self, action: #selector(clickLoanBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addMJRefresh(addFooter: false) {[weak self] (refresh: Bool) in
            self?.pageRequest()
        }
        
        self.certificationView.certificationDelegate = self
        
        self.contentView.addSubview(self.topView)
        self.contentView.addSubview(self.certificationView)
        self.view.addSubview(self.agreeBtn)
        self.view.addSubview(self.protocolBtn)
        self.view.addSubview(self.loanBtn)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view).offset(PADDING_UNIT)
            make.bottom.equalTo(self.agreeBtn.snp.top).offset(-PADDING_UNIT * 5)
        }
        
        self.topView.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(ScreenWidth * 1.44)
        }
        
        self.certificationView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.top).offset(ScreenWidth * 0.862)
            make.horizontalEdges.equalTo(self.topView).inset(PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.loanBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 9)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight())
            make.height.equalTo(50)
        }
        
        self.protocolBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.loanBtn.snp.top).offset(-PADDING_UNIT * 2)
            make.left.equalTo(self.agreeBtn.snp.right).offset(PADDING_UNIT * 2)
        }
        
        self.agreeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.protocolBtn)
            make.left.equalTo(self.loanBtn)
            make.size.equalTo(20)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _p_id = self.id_number else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/offensive", requestParams: ["despair": _p_id])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.contentView.refresh(begin: false)
            guard let _dict = res.jsonDict, let _loanModel = VCAPPLoanProductDetailModel.model(withJSON: _dict) else {
                return
            }
            
            if let _p_model = _loanModel.vulnerability {
                self?.topView.reloadProductModel(model: _p_model)
                self?.loanBtn.setTitle(_p_model.malaysia, for: UIControl.State.normal)
                // 记录产品ID/订单号
                VCAPPCommonInfo.shared.productID = _p_model.defended
                VCAPPCommonInfo.shared.productOrderNum = _p_model.reveal
                self?._loan_number = _p_model.exudes
            }
            
            if let _protocol = _loanModel.week?.endows, !_protocol.isEmpty {
                let attStr: NSMutableAttributedString = NSMutableAttributedString.init(string: VCAPPLanguageTool.localAPPLanguage("certification_prtocol"), attributes: [.foregroundColor: BLACK_COLOR_202020, .font: UIFont.systemFont(ofSize: 13)])
                attStr.append(NSAttributedString(string: _protocol, attributes: [.foregroundColor: BLUE_COLOR_2C65FE, .font: UIFont.systemFont(ofSize: 13), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: BLUE_COLOR_2C65FE]))
                self?.protocolBtn.setAttributedTitle(attStr, for: UIControl.State.normal)
                self?.protocolBtn.isHidden = false
                self?.agreeBtn.isHidden = false
            }
            
            if let _models = _loanModel.gross {
                self?.certificationView.reloadLoanHomeBanner(_models)
                self?._certification_models = _models
            }
            
            self?._protocol_url = _loanModel.week?.holiday
            self?._wait_certification_model = _loanModel.screening
            
        } failure: {[weak self] _, _ in
            self?.contentView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.contentView.refresh(begin: true)
    }
}

private extension VCAPPLoanProductViewController {
    func gotoCertificationItem(_ certificationType: APPCertificationType, certificationTitle: String?) {
        guard let _c_model = self._certification_models else {
            return
        }
        
        var _process_models: [VCAPPProcessModel] = []
        _c_model.enumerated().forEach { (idx: Int, item: VCAPPCertificationModel) in
            let _p_m = VCAPPProcessModel()
            _p_m.title = item.endows
            if item.brokeback {
                _p_m.bgImage = "process_complete"
            } else {
                if item.certificationType == certificationType {
                    _p_m.bgImage = "process_on_\(idx + 1)"
                } else {
                    _p_m.bgImage = "process_off_\(idx + 1)"
                }
            }
            
            _process_models.append(_p_m)
        }
        
        switch certificationType {
        case .Certification_Question:
            self.navigationController?.pushViewController(VCAPPLoanQuestionViewController(certificationTitle: certificationTitle, process: _process_models), animated: true)
        case .Certification_ID_Card:
            self.navigationController?.pushViewController(VCAPPLoanIDCardViewController(certificationTitle: certificationTitle, process: _process_models), animated: true)
        case .Certification_Personal_Info:
            self.navigationController?.pushViewController(VCAPPLoanBaseInfoViewController(certificationTitle: certificationTitle, process: _process_models, infoStyle: CertificationInfoStyle.PersonalInfo), animated: true)
        case .Certification_Job_Info:
            self.navigationController?.pushViewController(VCAPPLoanBaseInfoViewController(certificationTitle: certificationTitle, process: _process_models, infoStyle: CertificationInfoStyle.WorkingInfo), animated: true)
        case .Certification_Contects:
            self.navigationController?.pushViewController(VCAPPLoanContactsViewController(certificationTitle: certificationTitle, process: _process_models), animated: true)
        case .Certification_BankCard:
            self.navigationController?.pushViewController(VCAPPLoanBaseInfoViewController(certificationTitle: certificationTitle, process: _process_models, infoStyle: CertificationInfoStyle.BankCard), animated: true)
        }
    }
}

@objc private extension VCAPPLoanProductViewController {
    func clickAgreeBtn(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func clickProtocolButton(sender: UIButton) {
        guard let _url = self._protocol_url, !_url.isEmpty else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
    }
    
    func clickLoanBtn(sender: VCAPPLoadingButton) {
        // 正在刷新时,不进入认证
        if let _header = self.contentView.mj_header, _header.isRefreshing {
            return
        }
        
        // 如果有待认证项,优先跳转到待认证
        if let _wait_c_type = self._wait_certification_model?.certificationType {
            self.gotoCertificationItem(_wait_c_type, certificationTitle: self._wait_certification_model?.endows)
            return
        }
        
        if !self.agreeBtn.isHidden && !self.agreeBtn.isSelected {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("certification_agree_cancel_protocol"))
            return
        }
        
        guard let _amount = self._loan_number, let _order_num = VCAPPCommonInfo.shared.productOrderNum else {
            return
        }
        
        sender.startAnimation()
        self.buryReportBeginTime = Date().timeStamp
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/priorities", requestParams: ["exudes": _amount, "christmas": _order_num])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _model = VCAPPLoanApplyModel.model(withJSON: _dict) else {
                return
            }
            
            if let _url = _model.stating {
                VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
            }
            
            // 埋点
            VCAPPBuryReport.VCAPPRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_BeginLoanApply, beginTime: self?.buryReportBeginTime, endTime: Date().timeStamp, orderNum: _order_num)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

extension VCAPPLoanProductViewController: APPLoanCertificationProtocol {
    func gotoCertification(_ citificationModel: VCAPPCertificationModel) {
        // 正在刷新时,不进入认证
        if let _header = self.contentView.mj_header, _header.isRefreshing {
            return
        }
        
        var c_type: APPCertificationType = citificationModel.certificationType
        var title: String? = citificationModel.endows
        
        // 如果有待认证项,优先跳转到待认证
        if !citificationModel.brokeback, let _wait_c_type = self._wait_certification_model?.certificationType {
            c_type = _wait_c_type
            title = self._wait_certification_model?.endows
        }
        
        self.gotoCertificationItem(c_type, certificationTitle: title)
    }
}

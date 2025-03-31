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
    private lazy var agreeBtn: UIButton = UIButton.buildVidaNormalImageButton("login_protocol_nor", selectedImg: "login_protocol_sel")
    private lazy var protocolBtn: UIButton = UIButton.buildVidaCashNormalButton(titleColor: RED_COLOR_F21915)
    private lazy var loanBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("", cornerRadius: 25)
    
    private var id_number: String?
    private var _protocol_url: String?
    private var _wait_certification_model: VCAPPWaitCertificationModel?
    private var _certification_models: [VCAPPCertificationModel]?
    private var _loan_number: String?
    private let PROPORTION: Float = 0.65
    
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
        
        self.contentView.addVIDACashMJRefresh(addFooter: false) {[weak self] (refresh: Bool) in
            self?.pageRequest()
        }
        
        self.certificationView.certificationDelegate = self
        
        self.contentView.addSubview(self.topView)
        self.contentView.addSubview(self.certificationView)
        self.view.addSubview(self.agreeBtn)
        self.view.addSubview(self.protocolBtn)
        self.view.addSubview(self.loanBtn)
        
        if isAddingCashCode {
            self.rotationCircleCenter(contentOrgin: CGPoint(x: 300, y: 300), contentRadius: 120, subnode: [])
        }
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
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_tabBarFullHeight())
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
                attStr.append(NSAttributedString(string: _protocol, attributes: [.foregroundColor: RED_COLOR_F21915, .font: UIFont.systemFont(ofSize: 13), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: RED_COLOR_F21915]))
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
                _p_m.titleColor = RED_COLOR_F21915
            } else {
                if item.certificationType == certificationType {
                    _p_m.bgImage = "process_on_\(idx + 1)"
                    _p_m.titleColor = RED_COLOR_F21915
                } else {
                    _p_m.bgImage = "process_off_\(idx + 1)"
                    _p_m.titleColor = GRAY_COLOR_999999
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
    
    func rotationCircleCenter(contentOrgin: CGPoint, contentRadius: CGFloat,subnode: [String]) {
        // 添加比例,实现当要添加的子view数量较多时候可以自适应大小.
        var scale: CGFloat = 1
        if subnode.count > 10 {
            scale = CGFloat(CGFloat(subnode.count) / 13.0)
        }
        for i in 0..<subnode.count {
            let x = contentRadius * CGFloat(sin(.pi * 2 / Double(subnode.count) * Double(i)))
            let y = contentRadius * CGFloat(cos(.pi * 2 / Double(subnode.count) * Double(i)))
            // 当子view数量大于10个,view.size变小,防止view偏移,要保证view.center不变.
            // 先不计缩放比例计算出frame,获取center.之后保证center不变,修改View.size.保证展示效果.
            let view = BubbleSubView(frame: CGRect(x:contentRadius + 0.5 * CGFloat((1 + PROPORTION)) * x - 0.5 * CGFloat((1 - PROPORTION)) * contentRadius, y: contentRadius - 0.5 * CGFloat(1 + PROPORTION) * y - 0.5 * CGFloat(1 - PROPORTION) * contentRadius, width: CGFloat((1 - PROPORTION)) * contentRadius, height: CGFloat((1 - PROPORTION)) * contentRadius), imageName: subnode[i])
            let centerPoint = view.center
            view.frame.size = CGSize(width: CGFloat((1 - PROPORTION)) * contentRadius / scale , height: CGFloat((1 - PROPORTION)) * contentRadius / scale)
            view.center = centerPoint
            view.drawSubView()
            // 这个tag判断view是不是在最下方变大状态,非变大状态0,变大为1
            view.tag = 0
            // 获取子view在当前屏幕中的rect.来实现在最下方的那个变大
            let rect = view.convert(view.bounds, to: UIApplication.shared.keyWindow)
            let viewCenterX = rect.origin.x + (rect.width) / 2
            if viewCenterX > self.view.center.x - 20 && viewCenterX < self.view.center.x + 20 && rect.origin.y > (contentView.center.y) {
                view.transform = view.transform.scaledBy(x: 1.5, y: 1.5)
                view.tag = 1
            }
            self.view.insertSubview(view, belowSubview: self.contentView)
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
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        // 重新获取位置信息
        self.reloadLocation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/priorities", requestParams: ["exudes": _amount, "christmas": _order_num])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _model = VCAPPLoanApplyModel.model(withJSON: _dict) else {
                return
            }
            
            if let _url = _model.stating {
                VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
            }
            
            // 埋点
            VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_BeginLoanApply, beginTime: self?.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp(), orderNum: _order_num)
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

class BubbleSubView: UIView {
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()

    init(frame: CGRect, imageName: String?) {
        super.init(frame: frame)
        self.imageView.image = UIImage(named: imageName!)
        self.layer.masksToBounds = true
        self.addSubview(imageView)
        self.isHidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func drawSubView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.imageView.frame = CGRect(x: 0, y:0 , width: self.frame.width, height: self.frame.width)
    }

}

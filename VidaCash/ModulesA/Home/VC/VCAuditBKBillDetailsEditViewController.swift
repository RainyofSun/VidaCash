//
//  VCAuditBKBillDetailsEditViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

class VCAuditBKBillDetailsEditViewController: VCAPPBaseViewController {

    private lazy var whiteBgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logoImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.corner(16).backgroundColor = UIColor.hexStringColor(hexString: "#FF8327")
        return view
    }()
    
    private lazy var deleteBtn: VCAPPLoadingButton = {
        let btn = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("Delete", cornerRadius: 25)
        btn.hideGradientLayer()
        btn.setTitleColor(UIColor.hexStringColor(hexString: "#FF3F3D"), for: UIControl.State.normal)
        btn.backgroundColor = UIColor.hexStringColor(hexString: "#FFD7DB")
        return btn
    }()
    
    private lazy var editBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("Edit", cornerRadius: 25)
    private lazy var bDateView: VCAuditBKBillDetailsItem = VCAuditBKBillDetailsItem(frame: CGRectZero, itemType: AuditBKBillDetailsItemType.BillingDate)
    private lazy var remarkView: VCAuditBKBillDetailsItem = VCAuditBKBillDetailsItem(frame: CGRectZero, itemType: AuditBKBillDetailsItemType.Remark)
    private lazy var appendView: VCAuditBKBillDetailsItem = VCAuditBKBillDetailsItem(frame: CGRectZero, itemType: AuditBKBillDetailsItemType.Appendix)
    private lazy var localView: VCAuditBKBillDetailsItem = VCAuditBKBillDetailsItem(frame: CGRectZero, itemType: AuditBKBillDetailsItemType.LocationInformation)
    private lazy var timeView: VCAuditBKBillDetailsItem = VCAuditBKBillDetailsItem(frame: CGRectZero, itemType: AuditBKBillDetailsItemType.RecordingTime)
    
    private var billingId: String?
    private var billinfModel: VCAuditBKBillDetailModel?
    
    init(billingId id: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.billingId = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.title = "Bill details"
        
        self.deleteBtn.addTarget(self, action: #selector(clickDeleteButton(sender: )), for: UIControl.Event.touchUpInside)
        self.editBtn.addTarget(self, action: #selector(clickEditButton), for: UIControl.Event.touchUpInside)
        self.appendView.addTarget(self, action: #selector(clickEditButton), for: UIControl.Event.touchUpInside)
        
        self.whiteBgView.addSubview(self.logoImgView)
        self.view.insertSubview(self.whiteBgView, belowSubview: self.contentView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.subContentView)
        self.whiteBgView.addSubview(self.deleteBtn)
        self.whiteBgView.addSubview(self.editBtn)
        self.subContentView.addSubview(self.bDateView)
        self.subContentView.addSubview(self.remarkView)
        self.subContentView.addSubview(self.appendView)
        self.subContentView.addSubview(self.localView)
        self.subContentView.addSubview(self.timeView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.whiteBgView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 15)
        }
        
        self.deleteBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 7.5)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT * 4)
            make.height.equalTo(50)
        }
        
        self.editBtn.snp.makeConstraints { make in
            make.top.size.equalTo(self.deleteBtn)
            make.left.equalTo(self.deleteBtn.snp.right).offset(PADDING_UNIT * 3)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 7.5)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.top.left.width.equalTo(self.whiteBgView)
            make.bottom.greaterThanOrEqualTo(self.deleteBtn.snp.top).offset(-PADDING_UNIT * 3)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-42)
            make.size.equalTo(84)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalTo(self.whiteBgView)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(PADDING_UNIT)
            make.width.equalTo(self.view).dividedBy(2)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 8)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 6)
        }
        
        self.bDateView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(PADDING_UNIT * 4.5)
        }
        
        self.remarkView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.bDateView)
            make.top.equalTo(self.bDateView.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.appendView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.remarkView)
            make.top.equalTo(self.remarkView.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.localView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.appendView)
            make.top.equalTo(self.appendView.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.timeView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.localView)
            make.top.equalTo(self.localView.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4.5)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.whiteBgView.bounds != .zero {
            self.whiteBgView.jk.addCorner(conrners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _id = self.billingId else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/top", requestParams: ["directorial": _id])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _dict = res.jsonDict?["parts"] as? [String : Any], let _model = VCAuditBKBillDetailModel.model(withJSON: _dict) else {
                return
            }
            
            self?.billinfModel = _model
            if let _img = _model.annie, let _url = URL(string: _img) {
                self?.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
            }
            
            if let _category = _model.scorefor {
                let parastyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                parastyle.paragraphSpacing = PADDING_UNIT
                parastyle.alignment = .center
                let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: _category + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#1C1C1C"), .font: UIFont.systemFont(ofSize: 16), .paragraphStyle: parastyle])
                if let _record_time = _model.produce {
                    self?.bDateView.reloadRightText(_record_time)
                    attributeStr.append(NSAttributedString(string: _record_time, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14)]))
                }
                
                self?.titleLab.attributedText = attributeStr
            }
            
            self?.remarkView.reloadRightText(_model.narnia)
            self?.localView.reloadRightText(_model.interested)
            self?.timeView.reloadRightText(_model.duties)
            self?.appendView.reloadRightText(_model.approached)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.pageRequest()
    }
}

@objc private extension VCAuditBKBillDetailsEditViewController {
    func clickDeleteButton(sender: VCAPPLoadingButton) {
        guard let _id = self.billingId else {
            return
        }
        
        self.view.makeToastActivity(CSToastPositionCenter)
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/glasgow", requestParams: ["directorial": _id])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.view.hideToastActivity()
            sender.stopAnimation()
            self?.navigationController?.popViewController(animated: true)
        } failure: {[weak self] _, _ in
            self?.view.hideToastActivity()
            sender.stopAnimation()
        }
    }
    
    func clickEditButton() {
        self.navigationController?.pushViewController(VCAuditBKEditViewController(recordingModel: self.billinfModel), animated: true)
    }
}

//
//  VCAPPLoanBaseInfoViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit
import JKSwiftExtension

enum CertificationInfoStyle {
    case PersonalInfo
    case WorkingInfo
    case BankCard
}

class VCAPPLoanBaseInfoViewController: VCAPPLoanCertificationViewController {
    
    private var request_tupe: (requestUrl: String, saveUrl: String, riskType: VCRiskControlBuryReportType)?
    private var requestParams: NSMutableDictionary = NSMutableDictionary()
    private lazy var circleProcessView: JKCircleProgressView = {
        let view = JKCircleProgressView()
        view.isHidden = true
        view.lineWidth = 20
        view.progressColoar = UIColor.purple
        view.trackColor = UIColor.systemRed
        return view
    }()
    private var temp_dict: [String: String] = [:]
    
    init(certificationTitle title: String?, process: [VCAPPProcessModel], infoStyle style: CertificationInfoStyle) {
        super.init(certificationTitle: title, process: process)
        switch style {
        case .PersonalInfo:
            self.request_tupe = ("supervision/quinn", "supervision/anthony", .APP_PersonalInfo)
        case .WorkingInfo:
            self.request_tupe = ("supervision/actor", "supervision/mexican", .APP_WorkingInfo)
        case .BankCard:
            self.request_tupe = ("supervision/star", "supervision/ability", .APP_BindingBankCard)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.contentView.isHidden = false
        self.view.insertSubview(self.circleProcessView, at: .zero)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT)
        }
        
        self.circleProcessView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _p_id = VCAPPCommonInfo.shared.productID, let _tupe = self.request_tupe else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.requestUrl, requestParams: ["despair": _p_id])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _dict = res.jsonDict, let _infoModel = VCAPPCertificationInfoModel.model(withJSON: _dict), let _info_models = _infoModel.jane else {
                return
            }
            
            self?.buildInfoViews(_info_models)
        }
    }
    
    override func clickNextButton(sender: VCAPPLoadingButton) {
        guard let _p_id = VCAPPCommonInfo.shared.productID, let _tupe = self.request_tupe else {
            return
        }
        self.requestParams.setValue(_p_id, forKey: "despair")
        VCAPPCocoaLog.debug("------ \n\(self.requestParams)\n -------")
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.saveUrl, requestParams: self.requestParams as? [String : String])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            if isAddingCashCode {
                for item in self?.temp_dict.allValues() ?? [] {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
            // 埋点
            VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: _tupe.riskType, beginTime: self?.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

private extension VCAPPLoanBaseInfoViewController {
    func buildInfoViews(_ models: [VCAPPQuestionModel]) {
        var _temp_top: VCAPPCertificationInfoItemView?
        
        models.enumerated().forEach { (idx: Int, item: VCAPPQuestionModel) in
            let view = VCAPPCertificationInfoItemView(frame: CGRectZero)
            view.reloadCertificationInfoOptionalInfo(item)
            view.infoDelegate = self
            self.contentView.addSubview(view)
            if let _back = item.greater, let _k = item.canceled {
                self.requestParams.setValue(_back, forKey: _k)
            }
            
            if isAddingCashCode {
                for item in self.temp_dict.allValues() {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
            
            if let _top = _temp_top {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.left.size.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(PADDING_UNIT * 2)
                        make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.left.size.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(PADDING_UNIT * 2)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(PADDING_UNIT * 5)
                    make.top.equalToSuperview().offset(PADDING_UNIT * 4)
                    make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 10, height: (ScreenWidth - PADDING_UNIT * 10) * 0.28))
                }
            }
            
            _temp_top = view
        }
    }
}

extension VCAPPLoanBaseInfoViewController: APPCertificationInfoItemProtocol {
    func touchCertificationInfo(itemView: VCAPPCertificationInfoItemView) {
        self.view.endEditing(true)
        guard let _choise = itemView.infoChoiseModels else {
            return
        }
        
        if itemView._input_type == .Input_Enum {
            VCAPPCertificationInfoSinglePopView.convenienceShowPop(self.view).reloadSignlePopSource(_choise).popDidmissClosure = {[weak self] (popView: VCAPPBasePopView) in
                guard let _p_view = popView as? VCAPPCertificationInfoSinglePopView else {
                    return
                }
                
                if let _key = itemView.paramsKey, let _code = _p_view.selectedModel?.ability {
                    self?.requestParams.setValue(_code, forKey: _key)
                }
                
                itemView.reloadInfo(_p_view.selectedModel?.chronicles)
                
                _p_view.dismissPop(false)
            }
            
            if isAddingCashCode {
                for item in self.temp_dict.allValues() {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
        }
        
        if itemView._input_type == .Input_City {
            VCAPPCertificationInfoCityPopView.convenienceShowPop(self.view).popDidmissClosure = {[weak self] (popView: VCAPPBasePopView) in
                guard let _p_view = popView as? VCAPPCertificationInfoCityPopView else {
                    return
                }
                
                if let _key = itemView.paramsKey, let _city = _p_view.selected_city {
                    self?.requestParams.setValue(_city.replacingOccurrences(of: " | ", with: "|"), forKey: _key)
                }
                
                if isAddingCashCode {
                    for item in self?.temp_dict.allValues() ?? [] {
                        if item.jk.isPureInt {
                            print("------- is pure int ---------")
                        } else if item.jk.isVideoUrl {
                            print("------- 视频链接 --------")
                        } else if item.jk.isValidFileUrl {
                            print(" --------- 文件地址 ----------")
                        } else {
                            print("-------- is nothing ----------")
                        }
                    }
                }
                
                itemView.reloadInfo(_p_view.selected_city)
                
                _p_view.dismissPop(false)
            }
        }
        
        if itemView._input_type == .Input_Day {
            VCAPPCardITimePopView.convenienceShowPop(self.view).popDidmissClosure = {(view: VCAPPBasePopView) in
                guard let _dateView = view as? VCAPPCardITimePopView else {
                    return
                }
                
                if let _key = itemView.paramsKey, let _new_time = _dateView.selectedDate {
                    self.requestParams.setValue(_new_time, forKey: _key)
                }
                
                if isAddingCashCode {
                    for item in self.temp_dict.allValues() {
                        if item.jk.isPureInt {
                            print("------- is pure int ---------")
                        } else if item.jk.isVideoUrl {
                            print("------- 视频链接 --------")
                        } else if item.jk.isValidFileUrl {
                            print(" --------- 文件地址 ----------")
                        } else {
                            print("-------- is nothing ----------")
                        }
                    }
                }
                
                itemView.reloadInfo(_dateView.selectedDate)
                
                _dateView.dismissPop(false)
            }
        }
    }
    
    func didEndEditing(itemView: VCAPPCertificationInfoItemView, inputValue: String?) {
        if let _text = inputValue, let _k = itemView.paramsKey {
            self.requestParams.setValue(_text, forKey: _k)
        }
    }
}

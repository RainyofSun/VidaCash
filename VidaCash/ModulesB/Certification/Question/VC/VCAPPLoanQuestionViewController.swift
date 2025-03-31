//
//  VCAPPLoanQuestionViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

class VCAPPLoanQuestionViewController: VCAPPLoanCertificationViewController {
    
    private lazy var questionTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private var _questionModels: [VCAPPQuestionModel] = []
    private var questionParams: NSMutableDictionary = NSMutableDictionary()
    private var temp_dd: [String: String] = [:]
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.questionTableView.delegate = self
        self.questionTableView.dataSource = self
        self.questionTableView.register(VCAPPQuestionCell.self, forCellReuseIdentifier: NSStringFromClass(VCAPPQuestionCell.self))
        
        self.view.addSubview(self.questionTableView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.questionTableView.snp.makeConstraints { make in
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT * 4)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _p_id = VCAPPCommonInfo.shared.productID else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/community", requestParams: ["despair": _p_id])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _array = res.jsonDict?["jane"], let _question_models = NSArray.modelArray(with: VCAPPQuestionModel.self, json: _array) as? [VCAPPQuestionModel] else {
                return
            }
            
            self?._questionModels.append(contentsOf: _question_models)
            self?.questionTableView.reloadData()
        }
    }
    
    override func clickNextButton(sender: VCAPPLoadingButton) {
        sender.startAnimation()
        
        self.questionParams.setValue(VCAPPCommonInfo.shared.productID, forKey: "despair")
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/asian", requestParams: self.questionParams as? [String : String])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            if isAddingCashCode {
                for item in self?.temp_dd.allValues() ?? [] {
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
            VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_Questionnaire, beginTime: self?.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

extension VCAPPLoanQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._questionModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VCAPPQuestionCell.self), for: indexPath) as? VCAPPQuestionCell else {
            return UITableViewCell()
        }
        
        _cell.cellDelegate = self
        _cell.reloadCellModel(self._questionModels[indexPath.row], cellIndexPath: indexPath)
        return _cell
    }
}

extension VCAPPLoanQuestionViewController: APPQuestionCellProtocol {
    func didSelectedQuestionOptional(_ value: [String : String], cellIndexPath index: IndexPath?) {
        guard let _index_path = index else {
            return
        }
        
        self._questionModels[_index_path.row].greater = value.values.first
        self.questionParams.addEntries(from: value)
        
        if isAddingCashCode {
            for item in self.temp_dd.allValues() {
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
        
        VCAPPCocoaLog.debug("///////// \n \(self.questionParams) \n------------")
    }
}

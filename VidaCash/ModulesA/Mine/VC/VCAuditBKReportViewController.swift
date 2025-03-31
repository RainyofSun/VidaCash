//
//  VCAuditBKReportViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/22.
//

import UIKit

class VCAuditBKReportViewController: VCAPPBaseViewController {

    private lazy var switchControl: VCAuditBKEditSegmentView = VCAuditBKEditSegmentView(frame: CGRectZero)
    private lazy var expenseView: VCAuditBKStatisticsView = VCAuditBKStatisticsView(frame: CGRectZero)
    private lazy var incomeView: VCAuditBKStatisticsView = VCAuditBKStatisticsView(frame: CGRectZero)
    
    override func buildViewUI() {
        super.buildViewUI()
        self.switchControl.segmentDelegate = self
        self.topImageView.image = UIImage(named: "bk_bill_top_image")
        
        self.view.backgroundColor = .white
        self.navigationItem.titleView = self.switchControl
        self.contentView.contentSize = CGSize(width: ScreenWidth * 2, height: .zero)
        self.contentView.isPagingEnabled = true
        self.contentView.isScrollEnabled = false
        
        self.expenseView.itemDelegate = self
        self.incomeView.itemDelegate = self
        
        self.contentView.addSubview(self.expenseView)
        self.contentView.addSubview(self.incomeView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.expenseView.snp.makeConstraints { make in
            make.left.top.size.equalToSuperview()
        }
        
        self.incomeView.snp.makeConstraints { make in
            make.left.equalTo(self.expenseView.snp.right)
            make.top.size.equalTo(self.expenseView)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        let _begin_time: String = String(format: "%d-%d-01", Date().jk.year, Date().jk.month)
        let _end_time: String = Date().jk.toformatterTimeString(formatter: "yyyy-MM-dd")
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/drawn", requestParams: ["attempted": _begin_time, "geffen": _end_time, "postponed": self.switchControl.isExpense ? "1" : "2"])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _model = VCAuditBKStatisticsGroupModel.model(withJSON: res.jsonDict ?? [:]), let _model_array = _model.star else {
                return
            }
            
            let _fee_array: [Double] = _model_array.compactMap({Double($0.artificial ?? "0")})
            let _x_array: [String] = _model_array.compactMap({$0.david})
            VCAPPCocoaLog.debug("---- \(_fee_array)---- \n ----- \(_x_array) ------")
            if self?.switchControl.isExpense ?? true {
                self?.expenseView.refreshStatisticsSource(_model_array)
                self?.expenseView.chartView.reloadChartSource(_fee_array, xValues: _x_array)
            } else {
                self?.incomeView.refreshStatisticsSource(_model_array)
                self?.incomeView.chartView.reloadChartSource(_fee_array, xValues: _x_array)
            }
            
        } failure: {[weak self] _, _ in
            if self?.switchControl.isExpense ?? true {
                self?.expenseView.noteTableView.refresh(begin: false)
            } else {
                self?.incomeView.noteTableView.refresh(begin: false)
            }
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.expenseView.noteTableView.refresh(begin: true)
    }
}

extension VCAuditBKReportViewController: AuditBKEditSegmentControlProtocol {
    func switchSegmentControl(isExpense: Bool) {
        self.pageRequest()
        isExpense ? self.contentView.setContentOffset(CGPointZero, animated: true) : self.contentView.setContentOffset(CGPoint(x: ScreenWidth, y: .zero), animated: true)
    }
}

extension VCAuditBKReportViewController: AuditBKStatisticsprotocol {
    func refreshStatistics(item: VCAuditBKStatisticsView) {
        self.pageRequest()
    }
}

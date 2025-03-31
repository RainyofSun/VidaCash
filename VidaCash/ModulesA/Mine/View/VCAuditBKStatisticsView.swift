//
//  VCAuditBKStatisticsView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/22.
//

import UIKit
import EmptyDataSet_Swift

protocol AuditBKStatisticsprotocol: AnyObject {
    func refreshStatistics(item: VCAuditBKStatisticsView)
}

class VCAuditBKStatisticsView: UIView {

    weak open var itemDelegate: AuditBKStatisticsprotocol?
    
    private(set) lazy var chartView: VCAuditBKChartView = VCAuditBKChartView(frame: CGRectZero)
    
    private(set) lazy var noteTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.grouped)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private var table_models: [VCAuditBKStatisticsModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.noteTableView.register(VCAuditBKHomeTabHeaderView.self, forHeaderFooterViewReuseIdentifier: VCAuditBKHomeTabHeaderView.className())
        self.noteTableView.register(VCAuditBKHomeGroupTableViewCell.self, forCellReuseIdentifier: VCAuditBKHomeGroupTableViewCell.className())
        self.noteTableView.delegate = self
        self.noteTableView.dataSource = self
        self.noteTableView.emptyDataSetSource = self
        self.noteTableView.emptyDataSetDelegate = self
        
        self.addSubview(self.chartView)
        self.addSubview(self.noteTableView)
        
        self.noteTableView.addVIDACashMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            guard let _self = self else {
                return
            }
            
            _self.itemDelegate?.refreshStatistics(item: _self)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 3)
            make.height.equalTo(250)
        }
        
        self.noteTableView.snp.makeConstraints { make in
            make.top.equalTo(self.chartView.snp.bottom).offset(PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT * 2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func refreshStatisticsSource(_ models: [VCAuditBKStatisticsModel]) {
        self.noteTableView.refresh(begin: false)
        self.table_models.removeAll()
        self.table_models.append(contentsOf: models)
        self.noteTableView.reloadData()
    }
}

extension VCAuditBKStatisticsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.table_models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.table_models[section].bringing?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: VCAuditBKHomeGroupTableViewCell.className(), for: indexPath) as? VCAuditBKHomeGroupTableViewCell else {
            return UITableViewCell()
        }
        
        if let _model = self.table_models[indexPath.section].bringing?[indexPath.row] {
            _cell.reloadBKStatisticTableCell(_model)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let _header_view = tableView.dequeueReusableHeaderFooterView(withIdentifier: VCAuditBKHomeTabHeaderView.className()) as? VCAuditBKHomeTabHeaderView else {
            return nil
        }
        
        if let _group_model = self.table_models[section].david {
            _header_view.reloadHeaderText(_group_model)
        }
        
        return _header_view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

// MARK: EmptyDataSetDelegate
extension VCAuditBKStatisticsView: EmptyDataSetDelegate, EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let emptyView = VCAPPScrollEmptyView.init(frame: scrollView.bounds)
        emptyView.resetEmptyImgAndTitle("bk_home_empty", title: "You haven't kept score yet")
        scrollView.addSubview(emptyView)
        return emptyView
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.table_models.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

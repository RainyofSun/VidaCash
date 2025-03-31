//
//  VCAuditBKBillDetailsViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

class VCAuditBKBillDetailsViewController: VCAPPBaseViewController {

    private lazy var whiteBgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var detailTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.grouped)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private var table_models: [VCAuditBKHomeGroupModel] = []
    private var request_time: String?
    
    init(requestTime time: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.request_time = time
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.topImageView.image = UIImage(named: "bk_bill_top_image")
        self.title = "Bill details"
        self.contentView.isHidden = true
        
        self.detailTableView.register(VCAuditBKBillDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: VCAuditBKBillDetailsHeaderView.className())
        self.detailTableView.register(VCAuditBKHomeGroupTableViewCell.self, forCellReuseIdentifier: VCAuditBKHomeGroupTableViewCell.className())
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        self.view.addSubview(self.whiteBgView)
        self.whiteBgView.addSubview(self.detailTableView)
        
        self.detailTableView.addVIDACashMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.pageRequest()
        }
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.whiteBgView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 4)
        }
        
        self.detailTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT * 2)
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
        
        guard let _time = self.request_time else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/seems", requestParams: ["actor": _time])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.detailTableView.refresh(begin: false)
            guard let _model = VCAuditBKHomeModel.model(withJSON: res.jsonDict ?? [:]) else {
                return
            }
            
            if let _s = _model.star {
                self?.table_models.removeAll()
                self?.table_models.append(contentsOf: _s)
                self?.detailTableView.reload(isEmpty: true)
            }
            
        } failure: { [weak self] _, _ in
            self?.detailTableView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.detailTableView.refresh(begin: true)
    }
}

extension VCAuditBKBillDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.table_models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.table_models[section].parts?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: VCAuditBKHomeGroupTableViewCell.className(), for: indexPath) as? VCAuditBKHomeGroupTableViewCell else {
            return UITableViewCell()
        }
        
        if let _model = self.table_models[indexPath.section].parts?[indexPath.row] {
            _cell.reloadBKTableCell(_model)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let _header_view = tableView.dequeueReusableHeaderFooterView(withIdentifier: VCAuditBKBillDetailsHeaderView.className()) as? VCAuditBKBillDetailsHeaderView else {
            return nil
        }
        
        if let _group_model = self.table_models[section].minor {
            _header_view.headerView.reloadHeaderText(_group_model)
        }
        
        return _header_view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _model = self.table_models[indexPath.section].parts?[indexPath.row] {
            self.navigationController?.pushViewController(VCAuditBKBillDetailsEditViewController(billingId: _model.directorial), animated: true)
        }
    }
}

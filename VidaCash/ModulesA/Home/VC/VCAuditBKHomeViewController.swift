//
//  VCAuditBKHomeViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit
import JKSwiftExtension
import EmptyDataSet_Swift

class VCAuditBKHomeViewController: VCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var timeView: VCAuditBKTimeView = {
        let view = VCAuditBKTimeView(frame: CGRectZero)
        view.reloadTime(Date().jk.toformatterTimeString(formatter: "MM/yyyy"))
        return view
    }()
    
    private lazy var cornerContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tipLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_0B0A0A, labelText: "Recent Transaction")
    private lazy var moreBtn: VCAPPLoadingButton = {
        let view = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("View More", cornerRadius: 15)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var notepadView: VCAuditBKNotepadView = VCAuditBKNotepadView(frame: CGRectZero)
    
    private lazy var noteTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.grouped)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private var request_time: String = Date().jk.toformatterTimeString(formatter: "yyyy-MM")
    private var table_models: [VCAuditBKHomeGroupModel] = []
    
    override func buildViewUI() {
        super.buildViewUI()
        self.topImageView.isUserInteractionEnabled = true
        
        self.topImageView.image = UIImage(named: "bk_home_top_bg")
        self.contentView.isHidden = true
        
        self.timeView.addTarget(self, action: #selector(clickTimeControl(sender: )), for: UIControl.Event.touchUpInside)
        self.moreBtn.addTarget(self, action: #selector(clickMoreButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.noteTableView.register(VCAuditBKHomeTabHeaderView.self, forHeaderFooterViewReuseIdentifier: VCAuditBKHomeTabHeaderView.className())
        self.noteTableView.register(VCAuditBKHomeGroupTableViewCell.self, forCellReuseIdentifier: VCAuditBKHomeGroupTableViewCell.className())
        self.noteTableView.delegate = self
        self.noteTableView.dataSource = self
        self.noteTableView.emptyDataSetSource = self
        self.noteTableView.emptyDataSetDelegate = self
        
        self.topImageView.addSubview(self.timeView)
        self.view.addSubview(self.cornerContentView)
        self.view.addSubview(self.notepadView)
        self.cornerContentView.addSubview(self.tipLab)
        self.cornerContentView.addSubview(self.moreBtn)
        self.cornerContentView.addSubview(self.noteTableView)
        
        self.noteTableView.addVIDACashMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.pageRequest()
        }
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.timeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_vc_statusBarHeight() + PADDING_UNIT)
        }
        
        self.notepadView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
            make.bottom.equalTo(self.cornerContentView.snp.top).offset(PADDING_UNIT * 4.3)
        }
        
        self.cornerContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.topImageView.snp.bottom).offset(-PADDING_UNIT * 3)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_tabBarFullHeight())
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(PADDING_UNIT * 6)
        }
        
        self.moreBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.tipLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        self.noteTableView.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cornerContentView.jk.addCorner(conrners: [.topLeft, .topRight], radius: 20)
    }
    
    override func pageRequest() {
        super.pageRequest()
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/seems", requestParams: ["actor": self.request_time])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.noteTableView.refresh(begin: false)
            guard let _model = VCAuditBKHomeModel.model(withJSON: res.jsonDict ?? [:]) else {
                return
            }
            
            if let _s = _model.star {
                self?.table_models.removeAll()
                self?.table_models.append(contentsOf: _s)
                self?.noteTableView.reload(isEmpty: true)
            }
            
            self?.notepadView.reloadExpenseAndIncome(String(_model.expend), income: String(_model.stepped))
        } failure: { [weak self] _, _ in
            self?.noteTableView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.noteTableView.refresh(begin: true)
    }
}

extension VCAuditBKHomeViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let _header_view = tableView.dequeueReusableHeaderFooterView(withIdentifier: VCAuditBKHomeTabHeaderView.className()) as? VCAuditBKHomeTabHeaderView else {
            return nil
        }
        
        if let _group_model = self.table_models[section].minor {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _model = self.table_models[indexPath.section].parts?[indexPath.row] {
            self.navigationController?.pushViewController(VCAuditBKBillDetailsEditViewController(billingId: _model.directorial), animated: true)
        }
    }
}

// MARK: EmptyDataSetDelegate
extension VCAuditBKHomeViewController: EmptyDataSetDelegate, EmptyDataSetSource {
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

@objc private extension VCAuditBKHomeViewController {
    func clickTimeControl(sender: VCAuditBKTimeView) {
        self.view.showTimePicker {[weak self] (date: Date?) in
            guard let _d = date else {
                return
            }
            self?.timeView.reloadTime(_d.jk.toformatterTimeString(formatter: "MM/yyyy"))
            self?.request_time = _d.jk.toformatterTimeString(formatter: "yyyy-MM")
            self?.pageRequest()
        }
    }
    
    func clickMoreButton(sender: VCAPPLoadingButton) {
        self.navigationController?.pushViewController(VCAuditBKBillDetailsViewController(requestTime: self.request_time), animated: true)
    }
}

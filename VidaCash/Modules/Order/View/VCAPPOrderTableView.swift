//
//  VCAPPOrderTableView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit
import EmptyDataSet_Swift

protocol APPOrderTableRefreshProtocol: AnyObject {
    /// 开始请求数据
    func startRefreshOrderTable(table: VCAPPOrderTableView)
}

protocol APPOrderTableSelectedProtocol: AnyObject {
    /// 选中商品
    func didSelectedOrderTableItem(orderItemModel: VCAPPOrderItemModel)
}

class VCAPPOrderTableView: UITableView {

    weak open var refreshDelegate: APPOrderTableRefreshProtocol?
    weak open var selectedDelegate: APPOrderTableSelectedProtocol?
    
    private var _order_data_source: [VCAPPOrderItemModel] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.backgroundColor = .clear
        
        self.delegate = self
        self.dataSource = self
        self.emptyDataSetDelegate = self
        self.emptyDataSetSource = self
        
        self.register(VCAPPOrderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(VCAPPOrderTableViewCell.self))
        
        self.addMJRefresh(addFooter: false) { [weak self] (refresh: Bool) in
            guard let _self = self else {
                return
            }
            _self.refreshDelegate?.startRefreshOrderTable(table: _self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    /// 刷新页面数据
    public func refreshOrderTableWithSource(data: [VCAPPOrderItemModel]) {
        self._order_data_source.removeAll()
        self._order_data_source.append(contentsOf: data)
        self.reloadData()
    }
    
    /// 开始刷新
    public func startRefresh(refresh: Bool) {
        self.refresh(begin: refresh)
    }
    
    /// 切换列表刷新
    public func switchOrderTableAndRefresh() {
        guard self._order_data_source.isEmpty else {
            return
        }
        
        self.refresh(begin: true)
    }
}

extension VCAPPOrderTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._order_data_source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VCAPPOrderTableViewCell.self), for: indexPath) as? VCAPPOrderTableViewCell else {
            return UITableViewCell()
        }
        
        _cell.cellDelegate = self
        _cell.reloadCellSourceData(cellModel: self._order_data_source[indexPath.row])
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDelegate?.didSelectedOrderTableItem(orderItemModel: self._order_data_source[indexPath.row])
    }
}

extension VCAPPOrderTableView: APPOrderTableViewCellProtocol {
    func didTouchLoanPrivacy(privacyUrl: String?) {
        guard let _url = privacyUrl else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
    }
}

// MARK: EmptyDataSetDelegate
extension VCAPPOrderTableView: EmptyDataSetDelegate, EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let emptyView = VCAPPScrollEmptyView.init(frame: scrollView.bounds)
        scrollView.addSubview(emptyView)
        return emptyView
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.numberOfRows(inSection: 0) == .zero
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

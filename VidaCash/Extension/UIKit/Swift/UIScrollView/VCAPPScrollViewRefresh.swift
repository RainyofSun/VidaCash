//
//  VCAPPScrollViewRefresh.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit
import MJRefresh

extension UIScrollView {
    public func addVIDACashMJRefresh(addFooter: Bool, refreshHandler: (@escaping (Bool) -> Void)) {
        if addFooter {
            self.addMJFooter {
                refreshHandler(false)
            }
        }
        
        self.addMJHeader {
            refreshHandler(true)
        }
    }
    
    public func reload(isEmpty: Bool) {
        if let _tab = self as? UITableView {
            _tab.reloadData()
        }
        
        if let _tab = self as? UICollectionView  {
            _tab.reloadData()
        }
        
        self.mj_header?.endRefreshing()
        
        if let _footer = self.mj_footer {
            if isEmpty {
                _footer.endRefreshingWithNoMoreData()
            } else {
                _footer.endRefreshing()
            }
            _footer.isHidden = isEmpty
        }
    }
    
    public func refresh(begin: Bool) {
        if begin {
            self.mj_header?.beginRefreshing()
        } else {
            if let _header = self.mj_header, _header.isRefreshing {
                _header.endRefreshing()
            }
        }
    }
    
    public func loadMore(begin: Bool) {
        if begin {
            self.mj_footer?.beginRefreshing()
        } else {
            if let _footer = self.mj_footer, _footer.isRefreshing {
                _footer.endRefreshing()
            }
        }
    }
}

private extension UIScrollView {
    func addMJHeader(handler: @escaping (() -> Void)) {
        let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: handler)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_pull_idle"), for: .idle)
        header.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_pulling"), for: .pulling)
        header.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_refreshing"), for: .refreshing)
        
        self.mj_header = header;
    }
    
    func addMJFooter(handler: @escaping (() -> Void)) {
        let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: handler)
        footer.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_footer_idle"), for: .idle)
        footer.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(VCAPPLanguageTool.localAPPLanguage("refresh_footer_nomoredata"), for: .noMoreData)
        
        self.mj_footer = footer
    }
}

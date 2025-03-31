//
//  VCAuditBKBillDetailsHeaderView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

class VCAuditBKBillDetailsHeaderView: UITableViewHeaderFooterView {

    private(set) lazy var headerView: VCAuditBKCommonHeader = VCAuditBKCommonHeader(frame: CGRectZero, isBig: true)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.headerView)
        
        self.headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

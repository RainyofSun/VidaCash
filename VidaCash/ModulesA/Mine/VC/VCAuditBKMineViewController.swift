//
//  VCAuditBKMineViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKMineViewController: VCAPPLoanMineViewController {

    override func buildViewUI() {
        super.buildViewUI()
        self.itemContentView.backgroundColor = .white
        self.itemContentView.corner(8)
        self.coinImageView.isHidden = true
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.itemContentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalTo(self.view).inset(PADDING_UNIT * 4)
            make.top.equalTo(self.userPhoneLab.snp.bottom).offset(PADDING_UNIT * 4.5)
            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    override func buildMineItems(items: [VCAPPMineItemModel]) {
        var top_item: VCAuditBKMineItemControl?
        
        var _temp_items: [VCAPPMineItemModel] = []
        let reportModel: VCAPPMineItemModel = VCAPPMineItemModel()
        reportModel.endows = "Financial Report"
        reportModel.mexican = "bk_mine_report"
        reportModel.stating = APP_STATISTICS_PATH
        
        _temp_items.append(contentsOf: items)
        _temp_items.insert(reportModel, at: .zero)
        
        _temp_items.enumerated().forEach { (idx: Int, itemModel: VCAPPMineItemModel) in
            let view: VCAuditBKMineItemControl = VCAuditBKMineItemControl(frame: CGRectZero)
            view.reloadBKMineItem(itemModel: itemModel)
            view.addTarget(self, action: #selector(clickBKMineItem(sender: )), for: UIControl.Event.touchUpInside)
            
            self.itemContentView.addSubview(view)
            
            if let _topItem = top_item {
                if idx == _temp_items.count - 1 {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_topItem)
                        make.top.equalTo(_topItem.snp.bottom).offset(PADDING_UNIT * 3)
                        make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_topItem)
                        make.top.equalTo(_topItem.snp.bottom).offset(PADDING_UNIT * 3)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview()
                    make.top.equalToSuperview().offset(PADDING_UNIT * 3)
                }
            }
            
            top_item = view
        }
    }
}

@objc private extension VCAuditBKMineViewController {
    func clickBKMineItem(sender: VCAuditBKMineItemControl) {
        guard let _jump_url = sender.jumpURL else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_jump_url, backToRoot: true, targetVC: nil)
    }
}

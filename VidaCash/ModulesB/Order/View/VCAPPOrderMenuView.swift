//
//  VCAPPOrderMenuView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit

enum OrderRequestType: String {
    case Request_Apply = "7"
    case Request_Repayment = "6"
    case Request_Finished = "5"
}

protocol APPOrderMenuProtocol: AnyObject {
    func didSelectedMenu(request: OrderRequestType)
}

class VCAPPOrderMenuView: UIView {

    weak open var menuDelegate: APPOrderMenuProtocol?
    open var selectedTag: Int {
        if self.leftItem.isSelected {
            return 1
        }
        
        if self.midItem.isSelected {
            return 2
        }
        
        if self.rightItem.isSelected {
            return 3
        }
        
        return 1
    }
    
    private lazy var leftItem: VCAPPOrderMenuItem = VCAPPOrderMenuItem(frame: CGRectZero, menuItemType: APPOrderMenuItemStyle.Menu_Apply)
    private lazy var midItem: VCAPPOrderMenuItem = VCAPPOrderMenuItem(frame: CGRectZero, menuItemType: APPOrderMenuItemStyle.Menu_Repayment)
    private lazy var rightItem: VCAPPOrderMenuItem = VCAPPOrderMenuItem(frame: CGRectZero, menuItemType: APPOrderMenuItemStyle.Menu_Finished)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.leftItem.addTarget(self, action: #selector(clickMenuItem(sender: )), for: UIControl.Event.touchUpInside)
        self.midItem.addTarget(self, action: #selector(clickMenuItem(sender: )), for: UIControl.Event.touchUpInside)
        self.rightItem.addTarget(self, action: #selector(clickMenuItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.leftItem)
        self.addSubview(self.midItem)
        self.addSubview(self.rightItem)
        
        self.leftItem.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview()
        }
        
        self.midItem.snp.makeConstraints { make in
            make.left.equalTo(self.leftItem.snp.right).offset(PADDING_UNIT * 2)
            make.top.width.equalTo(self.leftItem)
        }
        
        self.rightItem.snp.makeConstraints { make in
            make.left.equalTo(self.midItem.snp.right).offset(PADDING_UNIT * 2)
            make.top.width.equalTo(self.midItem)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

@objc private extension VCAPPOrderMenuView {
    func clickMenuItem(sender: VCAPPOrderMenuItem) {
        for item in self.subviews {
            if let _sen = item as? VCAPPOrderMenuItem, _sen.isSelected {
                _sen.isSelected = false
                break
            }
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender == self.leftItem {
            self.menuDelegate?.didSelectedMenu(request: OrderRequestType.Request_Apply)
        } else if sender == self.midItem {
            self.menuDelegate?.didSelectedMenu(request: OrderRequestType.Request_Repayment)
        } else {
            self.menuDelegate?.didSelectedMenu(request: OrderRequestType.Request_Finished)
        }
    }
}

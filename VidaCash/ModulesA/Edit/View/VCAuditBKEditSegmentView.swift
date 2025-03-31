//
//  VCAuditBKEditSegmentView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

protocol AuditBKEditSegmentControlProtocol: AnyObject {
    func switchSegmentControl(isExpense: Bool)
}

class VCAuditBKEditSegmentView: UIImageView {

    weak open var segmentDelegate: AuditBKEditSegmentControlProtocol?
    
    open var isExpense: Bool {
        if self.leftBtn.isSelected {
            return true
        }
        
        if self.rightBtn.isSelected {
            return false
        }
        
        return true
    }
    
    private lazy var leftBtn: UIButton = UIButton.buildVidaCashNormalButton("Expense", titleFont: UIFont.boldSystemFont(ofSize: 16), titleColor: BLACK_COLOR_0B0A0A)
    private lazy var rightBtn: UIButton = UIButton.buildVidaCashNormalButton("Income", titleFont: UIFont.boldSystemFont(ofSize: 16), titleColor: BLACK_COLOR_0B0A0A)
    private lazy var sliderView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.image = UIImage(named: "bk_edit_border")
        
        self.leftBtn.backgroundColor = .clear
        self.rightBtn.backgroundColor = .clear
        
        self.leftBtn.addTarget(self, action: #selector(clickLeftButton(sender: )), for: UIControl.Event.touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(clickRightButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.sliderView)
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        
        self.leftBtn.snp.makeConstraints { make in
            make.left.verticalEdges.equalToSuperview()
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.leftBtn.snp.right)
            make.verticalEdges.right.equalToSuperview()
            make.width.equalTo(self.leftBtn)
        }
        
        self.sliderView.snp.makeConstraints { make in
            make.centerX.equalTo(self.leftBtn).offset(PADDING_UNIT * 0.5)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 0.5)
            make.width.equalTo((self.image?.size.width ?? 190 - PADDING_UNIT) * 0.5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sliderView.corner((self.height - PADDING_UNIT) * 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func switchSegmentControl(isExpense: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            if isExpense {
                self.clickLeftButton(sender: self.leftBtn)
            } else {
                self.clickRightButton(sender: self.rightBtn)
            }
        })
    }
}

@objc private extension VCAuditBKEditSegmentView {
    func clickLeftButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.rightBtn.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.3) {
            self.sliderView.centerX = sender.centerX + PADDING_UNIT * 0.5
        }
        
        self.segmentDelegate?.switchSegmentControl(isExpense: true)
    }
    
    func clickRightButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.leftBtn.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.3) {
            self.sliderView.snp.updateConstraints { make in
                self.sliderView.centerX = sender.centerX - PADDING_UNIT * 0.5
            }
        }
        
        self.segmentDelegate?.switchSegmentControl(isExpense: false)
    }
}

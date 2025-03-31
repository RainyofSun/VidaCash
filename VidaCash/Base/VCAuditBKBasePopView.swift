//
//  VCAuditBKBasePopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

class VCAuditBKBasePopView: UIView {

    open var closeClosure: ((Bool, VCAuditBKBasePopView) -> Void)?
    
    private lazy var closeBtn: UIButton = UIButton.buildVidaNormalImageButton("bk_pop_close")
    private(set) lazy var confirmBtn: VCAPPGradientButton = VCAPPGradientButton.buildVidaCashGradientButton("Confirm", cornerRadius: 24)
    private(set) lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.boldSystemFont(ofSize: 18), labelColor: BLACK_COLOR_0B0A0A, labelText: "Please select")
    private(set) lazy var imgContentView: UIImageView = UIImageView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildBKPopViews()
        self.layoutBKPopViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func buildBKPopViews() {
        self.imgContentView.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        
        self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(clickConfirmButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.imgContentView)
        self.imgContentView.addSubview(self.titleLab)
        self.imgContentView.addSubview(self.closeBtn)
        self.imgContentView.addSubview(self.confirmBtn)
    }
    
    public func layoutBKPopViews() {
        
        self.imgContentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(10)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.closeBtn)
        }
        
        self.closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 5)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.confirmBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 5)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4 - UIDevice.xp_vc_safeDistanceBottom())
        }
    }
    
    public func bk_showPop() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: UIView.AnimationOptions.curveEaseInOut) {
            self.top = .zero
        }
    }
    
    public func bk_dismissPop() {
        UIView.animate(withDuration: 0.25, delay: .zero, options: UIView.AnimationOptions.curveEaseIn) {
            self.top = ScreenHeight
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

@objc private extension VCAuditBKBasePopView {
    func clickCloseButton(sender: UIButton) {
        self.closeClosure?(true, self)
        self.bk_dismissPop()
    }
    
    func clickConfirmButton(sender: UIButton) {
        self.closeClosure?(false, self)
        self.bk_dismissPop()
    }
}

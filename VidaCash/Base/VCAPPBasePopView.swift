//
//  VCAPPBasePopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/1.
//

import UIKit

class VCAPPBasePopView: UIView {

    open var popDidmissClosure:((VCAPPBasePopView) -> Void)?
    open var clickCloseClosure: ((VCAPPBasePopView) -> Void)?
    
    private(set) lazy var topImgView: UIImageView = UIImageView(image: UIImage(named: "pop_top_image"))
    private(set) lazy var popTitleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), labelColor: .white)
    private lazy var logoLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.specialFont(13), labelColor: BLUE_COLOR_2C65FE)
    private lazy var tipLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.specialFont(13), labelColor: UIColor.init(red: 204/255.0, green: 192/255.0, blue: 151/255.0, alpha: 1), labelText: VCAPPLanguageTool.localAPPLanguage("login_pop_tip"))
    
    private(set) lazy var contentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var closeBtn: UIButton = UIButton.buildVidaNormalImageButton("pop_close")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildPopViews()
        self.layoutPopViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildPopViews() {
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        
        self.logoLab.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.logoLab.isHidden = true
        self.tipLab.isHidden = true
        
        self.addSubview(self.contentView)
        self.addSubview(topImgView)
        self.topImgView.addSubview(self.popTitleLab)
        self.topImgView.addSubview(self.logoLab)
        self.topImgView.addSubview(self.tipLab)
        self.addSubview(self.closeBtn)
    }
    
    public func layoutPopViews() {
        self.contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.topImgView).inset(PADDING_UNIT * 4.3)
            make.centerY.equalToSuperview().offset(-PADDING_UNIT * 4)
            make.height.greaterThanOrEqualTo(150)
        }
        
        self.topImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.bottom.equalTo(self.contentView.snp.top).offset(PADDING_UNIT * 12)
        }
        
        self.popTitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT * 6)
        }
        
        self.logoLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 10)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 15)
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
        
        self.closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.bottom).offset(PADDING_UNIT * 10)
            make.size.equalTo(32)
            make.centerX.equalToSuperview()
        }
    }
    
    public class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPBasePopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    public func dismissPop(_ needCall: Bool = true) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = .zero
        } completion: { _ in
            if needCall {
                self.popDidmissClosure?(self)
            }
            self.removeFromSuperview()
        }
    }
    
    public func showWithAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.origin.y = 100
            } completion: { _ in
                self.origin.x = 200
            }
        }
    }
    
    public func showWithOpacityAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear) {
            self.layer.opacity = 0.6
        } completion: { _ in
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: UIView.KeyframeAnimationOptions.autoreverse) {
                self.frame = CGRect(origin: CGPoint(x: 200, y: 300), size: CGSize(width: 200, height: 300))
            } completion: { _ in
                VCAPPCocoaLog.info(" -------- 动画完成 -----------")
            }
        }
    }
}

@objc private extension VCAPPBasePopView {
    func clickCloseButton(sender: UIButton) {
        if self.clickCloseClosure != nil {
            self.clickCloseClosure?(self)
        } else {
            self.dismissPop(false)
        }
    }
}

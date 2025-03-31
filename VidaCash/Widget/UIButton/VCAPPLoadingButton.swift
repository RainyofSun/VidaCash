//
//  VCAPPLoadingButton.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPLoadingButton: VCAPPGradientButton {

    private var activityIndicatorView: UIActivityIndicatorView?
    private var _btnTitle: String?
    private var _btnImg: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func startAnimation() {
        _btnTitle = self.currentTitle
        self.setTitle("", for: UIControl.State.normal)
        _btnImg = self.currentImage
        self.setImage(nil, for: UIControl.State.normal)
        
        if self.activityIndicatorView == nil {
            let activityView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
            activityView.hidesWhenStopped = true
            self.addSubview(activityView)
            activityView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            self.activityIndicatorView = activityView
        } else {
            self.activityIndicatorView?.alpha = 1
        }
        
        self.activityIndicatorView?.startAnimating()
        self.isEnabled = false
    }
    
    public func stopAnimation() {
        if let _activityView = self.activityIndicatorView {
            UIView.animate(withDuration: 0.3) {
                _activityView.alpha = 0
            } completion: { _ in
                _activityView.stopAnimating()
            }
            self.setTitle(_btnTitle, for: UIControl.State.normal)
            self.setImage(_btnImg, for: UIControl.State.normal)
            self.isEnabled = true
        }
    }
    
    public func hideGradientLayer() {
        self.bgGradientView.isHidden = true
    }

}

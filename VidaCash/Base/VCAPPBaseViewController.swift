//
//  VCAPPBaseViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/25.
//

import UIKit
import FDFullscreenPopGesture
import SnapKit

@objcMembers class VCAPPBaseViewController: UIViewController {

    private lazy var topImageView: UIImageView = UIImageView(image: UIImage(named: "base_top_image"))
    
    private(set) lazy var contentView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    // 埋点使用
    open var buryReportBeginTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "#E2EFFB")!
        
        self.buryReportBeginTime = Date().timeStamp
        
        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = false
        self.buildViewUI()
        self.layoutControlViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    public func buildViewUI() {
        self.view.addSubview(self.topImageView)
        self.view.addSubview(self.contentView)
    }
    
    public func layoutControlViews() {
        
        self.topImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        if let _childrenVC = self.navigationController?.children, _childrenVC.count > 1 {
            self.contentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.view).offset(PADDING_UNIT)
                make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - PADDING_UNIT)
            }
        } else {
            if self.presentingViewController != nil {
                self.contentView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                self.contentView.snp.makeConstraints { make in
                    make.horizontalEdges.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight() - PADDING_UNIT)
                }
            }
        }
    }
    
    public func reloadLocation() {
        // 获取最新的定位
        VCAPPLocationTool.location().requestDeviceLocation()
    }
    
    public func pageRequest() {
        
    }
}

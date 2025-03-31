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

    struct VidaCashBasicCPUInfo {
        public let maxCPUs: Int
        public let availCPUs: Int
        public let memorySize: UInt32    /// byte size
        public let cpuType: Int
        public let cpuSubType: Int
        public let cpuThreadType: Int
        public let physicalCPU: Int
        public let physicalCPUMax: Int
        public let logicalCPU: Int
        public let logicalCPUMax: Int
        public let maxMem: UInt64        /// byte size
    }
    
    private(set) lazy var topImageView: UIImageView = UIImageView(image: UIImage(named: "base_top_image"))
    
    private(set) lazy var contentView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    // 埋点使用
    open var buryReportBeginTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "#FFEFE6")!
        
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        
        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = false
        self.buildViewUI()
        self.layoutControlViews()
        
        if isAddingCashCode {
            self.showSystemViewControllerX()
        }
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
                make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT)
            }
        } else {
            if self.presentingViewController != nil {
                self.contentView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                self.contentView.snp.makeConstraints { make in
                    make.horizontalEdges.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_tabBarFullHeight() - PADDING_UNIT)
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
    
    @discardableResult
    public func showSystemViewControllerX() -> VidaCashBasicCPUInfo {
        
        
        var machData = host_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_basic_info>.stride / MemoryLayout<integer_t>.stride)
        
        let machRes = withUnsafeMutablePointer(to: &machData) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                host_info(mach_host_self(), HOST_BASIC_INFO, $0, &count)
            }
        }
        
        guard machRes == KERN_SUCCESS else {
            return VidaCashBasicCPUInfo(maxCPUs: 1, availCPUs: 1, memorySize: 2, cpuType: 2, cpuSubType: 2, cpuThreadType: 2, physicalCPU: 8, physicalCPUMax: 8, logicalCPU: 9, logicalCPUMax: 10, maxMem: 22)
        }
        
        
        let res = VidaCashBasicCPUInfo(
            maxCPUs: Int(machData.max_cpus),
            availCPUs: Int(machData.avail_cpus),
            memorySize: machData.memory_size,
            cpuType: Int(machData.cpu_type),
            cpuSubType: Int(machData.cpu_subtype),
            cpuThreadType: Int(machData.cpu_threadtype),
            physicalCPU: Int(machData.physical_cpu),
            physicalCPUMax: Int(machData.physical_cpu_max),
            logicalCPU: Int(machData.logical_cpu),
            logicalCPUMax: Int(machData.logical_cpu_max),
            maxMem: machData.max_mem
        )
        
        return res
    }
}

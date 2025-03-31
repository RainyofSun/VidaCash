//
//  VCAuditBKTabViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKTabViewController: UITabBarController {

    private var normal_imgs: [String] = ["bk_tab_home", "bk_tab_edit" ,"bk_tab_mine"]
    private var sel_imgs: [String] = ["bk_tab_home_sel", "bk_tab_edit" ,"bk_tab_mine_sel"]
    private var bk_vc_array: [UIViewController.Type] = [VCAuditBKHomeViewController.self, UIViewController.self, VCAuditBKMineViewController.self]
    private var bk_custom_bar: VCAuditBKCornerTabbar?
    
    override var selectedIndex: Int {
        didSet {
            self.bk_custom_bar?.selectedTabbarItem(selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, let change = change, let newValue = change[.newKey] as? Bool {
            if keyPath == LOGIN_OBERVER_KEY && !newValue {
                self.selectedIndex = .zero
            }
        }
    }

    deinit {
        deallocPrint()
    }
}

// MARK: Private Methods
private extension VCAuditBKTabViewController {
    func setupUI() {
        // 保存第一次安装
        VCAPPDiskCache.saveAppInstallRecord()
        let tabbar: VCAuditBKCornerTabbar = VCAuditBKCornerTabbar(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: UIDevice.xp_vc_tabBarFullHeight())))
        self.setValue(tabbar, forKey: "tabBar")
        tabbar.setTabbarTitles(barItemImages: normal_imgs, barItemSelectedImages: sel_imgs)
        tabbar.barDelegate = self
        self.addMyVC()
        self.bk_custom_bar = tabbar
        self.selectedIndex = .zero
        
        VCAPPCommonInfo.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(needRelogin), name: NSNotification.Name(APP_LOGIN_EXPIRED_NOTIFICATION), object: nil)
    }
    
    func addMyVC() {
        var listVCS:[UIViewController] = []
        bk_vc_array.forEach { (vcType: UIViewController.Type) in
            listVCS.append(VCAPPBaseNavigationController(rootViewController: vcType.init()))
        }
        self.viewControllers = listVCS;
    }
}

@objc private extension VCAuditBKTabViewController {
    func needRelogin() {
        let loginNav: VCAPPBaseNavigationController = VCAPPBaseNavigationController(rootViewController: VCAPPLoanLoginViewController())
        loginNav.modalPresentationStyle = .overFullScreen
        self.present(loginNav, animated: true)
    }
}

// MARK: APCustomTabbarProtocol
extension VCAuditBKTabViewController: VCCustomTabbarProtocol {
    func vc_canSelected(shouldSelectedIndex index: Int) -> Bool {
        guard let _vcArray = self.viewControllers, index < _vcArray.count else {
            return false
        }
        
        guard let _nav = _vcArray[index] as? VCAPPBaseNavigationController else {
            return false
        }
        
        let viewController = _nav.topViewController
        if (index == 1 || viewController is VCAuditBKMineViewController) && VCAPPCommonInfo.shared.appLoginInfo?.brought == nil {
            let loginNav: VCAPPBaseNavigationController = VCAPPBaseNavigationController(rootViewController: VCAPPLoanLoginViewController())
            loginNav.modalPresentationStyle = .overFullScreen
            self.present(loginNav, animated: true)
            return false
        }
        
        if index == 1, let _nav = _vcArray[self.selectedIndex] as? VCAPPBaseNavigationController {
            _nav.pushViewController(VCAuditBKEditViewController(), animated: true)
            return false
        }
        
        return true
    }
    
    func vc_didSelctedItem(_ tabbar: VCAPPCustomTabbar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}

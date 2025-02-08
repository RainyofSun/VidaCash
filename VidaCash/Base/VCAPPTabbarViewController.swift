//
//  VCAPPTabbarViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPTabbarViewController: UITabBarController {

    private var custom_tabbar: VCAPPCustomTabbar?
    private var vc_array: [UIViewController.Type] = [VCAPPLoanHomeViewController.self, VCAPPLoanOrderViewController.self, VCAPPLoanMineViewController.self]
    private var title_array: [String] = []
    private var image_array: [String] = ["tabbar_home_nor", "tabbar_order_nor", "tabbar_mine_nor"]
    private var select_image_array: [String] = ["tabbar_home_sel", "tabbar_order_sel", "tabbar_mine_sel"]
    
    override var selectedIndex: Int {
        didSet {
            self.custom_tabbar?.selectedTabbarItem(selectedIndex)
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
private extension VCAPPTabbarViewController {
    func setupUI() {
        
        let tabbar: VCAPPCustomTabbar = VCAPPCustomTabbar(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: UIDevice.xp_tabBarFullHeight())))
        self.setValue(tabbar, forKey: "tabBar")
        tabbar.setTabbarTitles(barItemImages: image_array, barItemSelectedImages: select_image_array)
        tabbar.barDelegate = self
        self.addMyVC()
        self.custom_tabbar = tabbar
        self.selectedIndex = .zero
        
        VCAPPCommonInfo.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(needRelogin), name: NSNotification.Name(APP_LOGIN_EXPIRED_NOTIFICATION), object: nil)
    }
    
    func addMyVC() {
        var listVCS:[UIViewController] = []
        vc_array.forEach { (vcType: UIViewController.Type) in
            listVCS.append(VCAPPBaseNavigationController(rootViewController: vcType.init()))
        }
        self.viewControllers = listVCS;
    }
}

@objc private extension VCAPPTabbarViewController {
    func needRelogin() {
        let loginNav: VCAPPBaseNavigationController = VCAPPBaseNavigationController(rootViewController: VCAPPLoanLoginViewController())
        loginNav.modalPresentationStyle = .overFullScreen
        self.present(loginNav, animated: true)
    }
}

// MARK: APCustomTabbarProtocol
extension VCAPPTabbarViewController: VCCustomTabbarProtocol {
    func vc_canSelected(shouldSelectedIndex index: Int) -> Bool {
        guard let _vcArray = self.viewControllers, index < _vcArray.count else {
            return false
        }
        
        guard let _nav = _vcArray[index] as? VCAPPBaseNavigationController else {
            return false
        }
        
        let viewController = _nav.topViewController
        if (viewController is VCAPPLoanOrderViewController || viewController is VCAPPLoanMineViewController) && VCAPPCommonInfo.shared.appLoginInfo?.brought == nil {
            let loginNav: VCAPPBaseNavigationController = VCAPPBaseNavigationController(rootViewController: VCAPPLoanLoginViewController())
            loginNav.modalPresentationStyle = .overFullScreen
            self.present(loginNav, animated: true)
            return false
        }
        
        return true
    }
    
    func vc_didSelctedItem(_ tabbar: VCAPPCustomTabbar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}

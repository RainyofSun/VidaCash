//
//  VCAPPControllerExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/29.
//

import UIKit

// 如果你想使用的optional方法，你必须用@objc标记您的protocol
public protocol ShouldPopDelegate {
    //拦截返回按钮的点击事件
    func currentViewControllerShouldPop() -> Bool
}

@objc extension UIViewController: ShouldPopDelegate {
    public func currentViewControllerShouldPop() -> Bool {
        return true
    }
}

extension UIViewController {
    func topMostController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostController()
        } else if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostController()
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController!.topMostController()
        } else {
            return self
        }
    }
}

// MARK: Alert
@objc extension UIViewController {
    func showSystemStyleSettingAlert(content: String, ok: String? = VCAPPLanguageTool.localAPPLanguage("alert_sheet_ok"), cancel: String? = VCAPPLanguageTool.localAPPLanguage("alert_sheet_cancel")) {
        let alertViewController: UIAlertController = UIAlertController(title: nil, message: content, preferredStyle: UIAlertController.Style.alert)
        let ok: UIAlertAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) { _ in
            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        
        let cancel: UIAlertAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.default) { _ in
            
        }
        
        alertViewController.addAction(ok)
        alertViewController.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true)
        }
    }
}

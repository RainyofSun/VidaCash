//
//  VCAPPDeviceExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit
import CFNetwork
import NetworkExtension

extension UIDevice {
    /// 顶部安全区高度
    static func xp_vc_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    /// 底部安全区高度
    static func xp_vc_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    /// 顶部状态栏高度（包括安全区）
    static  func xp_vc_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    /// 导航栏高度
    static func xp_vc_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    /// 状态栏+导航栏的高度
    static func xp_vc_navigationFullHeight() -> CGFloat {
        return UIDevice.xp_vc_statusBarHeight() + UIDevice.xp_vc_navigationBarHeight()
    }
    
    /// 底部导航栏高度
    static func xp_vc_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    /// 底部导航栏高度（包括安全区）
    static func xp_vc_tabBarFullHeight() -> CGFloat {
        return UIDevice.xp_vc_tabBarHeight() + UIDevice.xp_vc_safeDistanceBottom()
    }
    
    public class func isUsedProxy() -> Bool {
       guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
       guard let dict = proxy as? [String: Any] else { return false }
       let isUsed = dict.isEmpty // 有时候未设置代理dictionary也不为空，而是一个空字典
       guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
//        let a:String = HTTPProxy as! String
       if(HTTPProxy.count>0){
           return true
       }
       return false
   }

    func isVPNEnabled() -> Bool {
        return NEVPNManager.shared().connection.status == .connected || NEVPNManager.shared().connection.status == .connecting ||
        NEVPNManager.shared().connection.status == .reasserting
    }
}

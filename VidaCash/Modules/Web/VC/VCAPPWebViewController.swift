//
//  VCAPPWebViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit
import WebKit
import StoreKit

class VCAPPWebViewController: VCAPPBaseViewController {

    private var linkURL: String?
    private var gotoRoot: Bool = true
    
    private lazy var topView: UIImageView = UIImageView(image: UIImage(named: "base_top_image"))
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero, configuration: self.setWebViewConfig())
        view.navigationDelegate = self // 导航代理
        view.allowsBackForwardNavigationGestures = true // 允许左滑返回
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var processBarView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = BLUE_COLOR_037DFF
        view.tintColor = CYAN_COLOR_56E1FE
        view.isHidden = true
        return view
    }()
    
    init(withWebLinkURL url: String, backToRoot root: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.linkURL = url
        self.gotoRoot = root
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        self.reloadLocation()
        
        self.view.backgroundColor = UIColor.init(hexString: "#E2EFFB")!
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.processBarView)
        
        if let _url = self.linkURL, let _webURL = URL.init(string: _url) {
            self.webView.load(URLRequest.init(url: _webURL))
        }
    }
    
    override func layoutControlViews() {
        
        self.topView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        self.processBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_navigationFullHeight())
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.processBarView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    override func currentViewControllerShouldPop() -> Bool {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.removeWebFuncObserver()
            if let _nav = self.navigationController {
                if _nav.children.count > 1 {
                    if self.gotoRoot {
                        _nav.popToRootViewController(animated: true)
                    } else {
                        _nav.popViewController(animated: true)
                    }
                } else {
                    if self.presentingViewController != nil {
                        self.navigationController?.dismiss(animated: true)
                    }
                }
            } else {
                self.dismiss(animated: true)
            }
        }
        
        return false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        VCAPPCocoaLog.debug("网页加载进度---\(webView.estimatedProgress)")
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                let viewProgress = Float(self.webView.estimatedProgress)
                self.processBarView.setProgress(viewProgress, animated: true)
                if viewProgress >= 1.0 {
                    self.processBarView.progress = 0
                }
            }
        } else if keyPath == "title" {
            self.title = self.webView.title
        }
    }
}

extension VCAPPWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.processBarView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.processBarView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.processBarView.isHidden = true
    }
}

// MARK: WKScriptMessageHandler
extension VCAPPWebViewController: WKScriptMessageHandler {
    // 处理js传递的消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        VCAPPCocoaLog.debug("接受到JS传递的消息：\(message.name) body = \(message.body)")

        if message.name == CloseWebPage {
            let _ = self.currentViewControllerShouldPop()
        }
        
        if message.name == PageTransitionNoParams || message.name == PageTransitionWithParams ||
            message.name == CloseAndGotoHome || message.name == CloseAndGotoLoginPage || message.name == CloseAndGotoMineCenter {
            if let _paramArray = message.body as? NSArray, let _url = _paramArray.firstObject as? String {
                VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: true, targetVC: nil)
            }
        }
        
        if message.name == Call {
            
        }
        
        if message.name == GotoAppStore {
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.currentScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
        
        if message.name == ConfirmApplyBury {
            self.buryReportBeginTime = Date().timeStamp
            // 埋点
            VCAPPBuryReport.VCAPPRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_EndLoanApply, beginTime: self.buryReportBeginTime, endTime: Date().timeStamp, orderNum: VCAPPCommonInfo.shared.productOrderNum)
        }
    }
}

private extension VCAPPWebViewController {
    func setWebViewConfig() -> WKWebViewConfiguration {
        let preferences: WKPreferences = WKPreferences()
        preferences.minimumFontSize = 15
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let webConfig: WKWebViewConfiguration = WKWebViewConfiguration()
        webConfig.preferences = preferences
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        webConfig.userContentController = self.buildUserContentController()
        
        return webConfig
    }
    
    func buildUserContentController() -> WKUserContentController {
        let _scriptHandler: VCAPPWeakWebScriptMsgHandler = VCAPPWeakWebScriptMsgHandler.init(weakScriptHandler: self)
        let _user_content: WKUserContentController = WKUserContentController()
        _user_content.add(_scriptHandler, name: CloseWebPage)
        _user_content.add(_scriptHandler, name: PageTransitionNoParams)
        _user_content.add(_scriptHandler, name: PageTransitionWithParams)
        _user_content.add(_scriptHandler, name: CloseAndGotoHome)
        _user_content.add(_scriptHandler, name: CloseAndGotoLoginPage)
        _user_content.add(_scriptHandler, name: CloseAndGotoMineCenter)
        _user_content.add(_scriptHandler, name: Call)
        _user_content.add(_scriptHandler, name: GotoAppStore)
        _user_content.add(_scriptHandler, name: ConfirmApplyBury)
        
        return _user_content
    }
    
    func removeWebFuncObserver() {
        self.webView.configuration.userContentController.removeAllUserScripts()
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}

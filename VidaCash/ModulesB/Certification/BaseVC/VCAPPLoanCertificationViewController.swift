//
//  VCAPPLoanCertificationViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit
import JKSwiftExtension

class VCAPPLoanCertificationViewController: VCAPPBaseViewController {

    private(set) lazy var processView: VCAPPProcessView = VCAPPProcessView(frame: CGRectZero)
    private(set) lazy var nextBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("guide_next"), cornerRadius: 25)
    private lazy var tapLab: JKTapActionLabel = {
        let view = JKTapActionLabel(frame: CGRectZero)
        view.setText(NSMutableAttributedString.init(string: "private policy", attributes: [.foregroundColor: UIColor.orange, .font: UIFont.system(UIFont.TextStyle.callout)]))
        view.tap(string: "Prive") {
            VCAPPCocoaLog.info("-------- tap -------")
        }
        view.isHidden = true
        return view
    }()
    
    open var navTitle: String?
    private var _process_models: [VCAPPProcessModel] = []
    
    init(certificationTitle title: String?, process: [VCAPPProcessModel]) {
        super.init(nibName: nil, bundle: nil)
        self.navTitle = title
        self._process_models = process
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.title = self.navTitle
        
        self.reloadLocation()
        
        self.nextBtn.addTarget(self, action: #selector(clickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.isHidden = true
        self.view.addSubview(self.processView)
        self.view.addSubview(self.nextBtn)
        self.view.addSubview(self.tapLab)
        self.processView.buildProcessItem(self._process_models)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.processView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight())
            make.horizontalEdges.equalTo(self.view).inset(PADDING_UNIT * 4)
            make.height.equalTo(110)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 9)
            make.height.equalTo(50)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.pageRequest()
    }
}

@objc extension VCAPPLoanCertificationViewController {
    func clickNextButton(sender: VCAPPLoadingButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

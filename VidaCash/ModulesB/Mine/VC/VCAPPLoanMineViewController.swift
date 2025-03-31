//
//  VCAPPLoanMineViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPLoanMineViewController: VCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var userImgView: UIImageView = UIImageView(image: UIImage(named: "mine_user_heade"))
    private(set) lazy var userPhoneLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 18), labelColor: BLACK_COLOR_202020, labelText: VCAPPCommonInfo.shared.appLoginInfo?.greek?.maskPhoneNumber())
    private(set) lazy var itemContentView: UIView = UIView(frame: CGRectZero)
    private(set) lazy var coinImageView: UIImageView = UIImageView(image: UIImage(named: "mine_user_image"))
    
    override func buildViewUI() {
        super.buildViewUI()
        self.title = VCAPPLanguageTool.localAPPLanguage("mine_nav_title")
        
        VCAPPCommonInfo.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: .new, context: nil)
        
        self.contentView.addVIDACashMJRefresh(addFooter: false) {[weak self] (refresh: Bool) in
            self?.pageRequest()
        }
        
        self.contentView.addSubview(self.userImgView)
        self.contentView.addSubview(self.userPhoneLab)
        self.contentView.addSubview(self.itemContentView)
        self.contentView.addSubview(self.coinImageView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.userImgView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 2)
        }
        
        self.userPhoneLab.snp.makeConstraints { make in
            make.centerX.equalTo(self.userImgView)
            make.top.equalTo(self.userImgView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.itemContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view)
            make.top.equalTo(self.userPhoneLab.snp.bottom).offset(PADDING_UNIT * 4.5)
            make.height.greaterThanOrEqualTo(100)
        }
        
        self.coinImageView.snp.makeConstraints { make in
            make.top.equalTo(self.itemContentView.snp.bottom).offset(PADDING_UNIT * 4.5)
            make.centerX.equalTo(self.itemContentView)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 8, height: (ScreenWidth - PADDING_UNIT * 8) * 0.36))
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/position", requestParams: nil)) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            self?.contentView.refresh(begin: false)
            guard let _dict = res.jsonDict, let itemModel = VCAPPMineModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _itemModels = itemModel.star, self?.itemContentView.subviews.count == .zero else {
                return
            }
            
            self?.buildMineItems(items: _itemModels)
        } failure: {[weak self] _, _ in
            self?.contentView.refresh(begin: false)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == LOGIN_OBERVER_KEY {
            self.userPhoneLab.text = VCAPPCommonInfo.shared.appLoginInfo?.greek?.maskPhoneNumber()
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.contentView.refresh(begin: true)
    }
}

extension VCAPPLoanMineViewController {
    func buildMineItems(items: [VCAPPMineItemModel]) {
        var temp_top_item: VCAPPMineItemView?
        var temp_left_item: VCAPPMineItemView?
        
        let row_count: Int = items.count%2 == .zero ? items.count/2 : items.count/2 + 1
        
        var index: Int = .zero
        for _ in 0..<row_count {
            for index_j in 0..<2 {
                if index >= items.count {
                    return
                }
                let view = VCAPPMineItemView(frame: CGRectZero)
                view.reloadMineItem(itemModel: items[index])
                view.addTarget(self, action: #selector(clickMineItem(sender: )), for: UIControl.Event.touchUpInside)
                self.itemContentView.addSubview(view)
                
                if let _top = temp_top_item {
                    if let _left = temp_left_item {
                        view.snp.makeConstraints { make in
                            make.left.equalTo(_left.snp.right).offset(PADDING_UNIT * 3)
                            make.top.width.equalTo(_left)
                            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
                        }
                    } else {
                        view.snp.makeConstraints { make in
                            make.left.equalTo(_top)
                            make.top.equalTo(_top.snp.bottom).offset(PADDING_UNIT * 3)
                            if index == items.count - 1 {
                                make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
                                make.width.equalTo(_top)
                            }
                        }
                    }
                } else {
                    if let _left = temp_left_item {
                        view.snp.makeConstraints { make in
                            make.left.equalTo(_left.snp.right).offset(PADDING_UNIT * 3)
                            make.width.top.equalTo(_left)
                            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
                        }
                    } else {
                        view.snp.makeConstraints { make in
                            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
                            make.top.equalToSuperview()
                        }
                    }
                }
                
                if index_j == .zero {
                    temp_top_item = view
                    temp_left_item = view
                } else {
                    temp_left_item = nil
                }
                
                index += 1
            }
        }
        
        if isAddingCashCode {
            let lineLayer: Line = Line(color: "#892873")
            lineLayer.isHidden = true
            self.view.layer.insertSublayer(lineLayer, at: .zero)
        }
    }
}

@objc private extension VCAPPLoanMineViewController {
    func clickMineItem(sender: VCAPPMineItemView) {
        guard let _jump_url = sender.jumpUrl else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_jump_url, backToRoot: true, targetVC: nil)
    }
}

class Line: CAShapeLayer {
    
     init(color : String) {
        super.init()
        
        createLine(color : color)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLine(color : String) {
        let bezPath = UIBezierPath()
        bezPath.move(to: CGPoint(x: 15, y: 0))
        let distance = CGFloat(arc4random_uniform(45 - 25) + 25)
        bezPath.addLine(to: CGPoint(x: distance, y: 0))
        
        lineWidth = 4.5
        if UIDevice.current.userInterfaceIdiom == .pad {
           lineWidth = 8
        }
        lineCap = CAShapeLayerLineCap.round
        strokeColor = UIColor.init(hexString: color)?.cgColor
        path = bezPath.cgPath
    }
    
    func animate() {
        let duration: CFTimeInterval = 1.0
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0
        end.toValue = 1.0175
        end.beginTime = 0
        end.duration = duration * 0.75
        end.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        end.fillMode = CAMediaTimingFillMode.forwards
        
        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.fromValue = 0
        begin.toValue = 1.0175
        begin.beginTime = duration * 0.15
        begin.duration = duration * 0.85
        begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        begin.fillMode = CAMediaTimingFillMode.backwards
        
        let group = CAAnimationGroup()
        group.animations = [end, begin]
        group.duration = duration
        
        strokeEnd = 1
        strokeStart = 1
        
        add(group, forKey: "move")
    }
    
}

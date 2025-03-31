//
//  VCAPPCertificationInfoCityPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

class VCAPPCertificationInfoCityPopView: VCAPPBasePopView {

    open var selected_city: String?
    
    private lazy var cityButton1: UIButton = UIButton.buildVidaCashNormalButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_city_btn"), titleColor: GRAY_COLOR_999999)
    private lazy var cityButton2: UIButton = UIButton.buildVidaCashNormalButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_city_btn"), titleColor: GRAY_COLOR_999999)
    private lazy var leftTableView: VCAPPCertificationPopTableView = VCAPPCertificationPopTableView(frame: CGRectZero, style: UITableView.Style.plain)
    private lazy var rightTableView: VCAPPCertificationPopTableView = VCAPPCertificationPopTableView(frame: CGRectZero, style: UITableView.Style.plain)
    private lazy var hScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentSize = CGSize(width: (ScreenWidth - 8.6 * PADDING_UNIT) * 2, height: 0)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private lazy var confirmBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_confirm"), cornerRadius: 25)
    private var _total_array: [VCAPPCertificationCityModel] = []
    private var _left_source: [String] = []
    private var _right_source: [String] = []
    private var _selected_all: Bool = false
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("certification_card_pop_city")
        
        self.cityButton2.isHidden = true
        
        self.confirmBtn.addTarget(self, action: #selector(confirmButton(sender: )), for: UIControl.Event.touchUpInside)
        self.cityButton1.addTarget(self, action: #selector(clickCityButtonLeft(sender: )), for: UIControl.Event.touchUpInside)
        self.cityButton2.addTarget(self, action: #selector(clickCityButtonRight(sender: )), for: UIControl.Event.touchUpInside)
        
        self.leftTableView.tableDelegate = self
        self.rightTableView.tableDelegate = self
        
        self.addSubview(self.cityButton1)
        self.addSubview(self.cityButton2)
        self.addSubview(self.hScrollView)
        self.addSubview(self.confirmBtn)
        self.hScrollView.addSubview(self.leftTableView)
        self.hScrollView.addSubview(self.rightTableView)
        
        if FileManager.default.fileExists(atPath: VCAPPCommonInfo.shared.cityFilePath) {
            self._total_array = VCAPPCertificationCityModel.readCitySourceFormDisk()
            self._total_array.forEach { (item: VCAPPCertificationCityModel) in
                if let _count = item.count {
                    self._left_source.append(_count)
                }
            }
            
            self.leftTableView.reloadCitySource(self._left_source)
        }
    }

    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.cityButton1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.left.equalToSuperview()
        }
        
        self.cityButton2.snp.makeConstraints { make in
            make.top.size.equalTo(self.cityButton1)
            make.left.equalTo(self.cityButton1.snp.right)
            make.right.equalToSuperview()
        }
        
        self.hScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.cityButton1.snp.bottom).offset(PADDING_UNIT)
            make.height.equalTo(250)
        }
        
        self.leftTableView.snp.makeConstraints { make in
            make.left.top.size.equalToSuperview()
        }
        
        self.rightTableView.snp.makeConstraints { make in
            make.left.equalTo(self.leftTableView.snp.right)
            make.top.size.equalTo(self.leftTableView)
        }
        
        self.confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(self.hScrollView.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPCertificationInfoCityPopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

// MARK: Target
@objc private extension VCAPPCertificationInfoCityPopView {
    
    func clickCityButtonLeft(sender: UIButton) {
        self.hScrollView.setContentOffset(CGPoint(x: ScreenWidth - 8.6 * PADDING_UNIT, y: .zero), animated: true)
    }
    
    func clickCityButtonRight(sender: UIButton) {
        self.hScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func confirmButton(sender: UIButton) {
        if !self._selected_all, let _super_view = self.superview {
            _super_view.makeToast(VCAPPLanguageTool.localAPPLanguage("alert_address"))
            return
        }
        
        self.dismissPop()
    }
}

extension VCAPPCertificationInfoCityPopView: APPCertificationPopTableProtocol {
    func didSelectedCity(tableView: VCAPPCertificationPopTableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTableView {
            self.cityButton1.setTitle(self._left_source[indexPath.row], for: UIControl.State.normal)
            self.cityButton1.setTitleColor(RED_COLOR_F21915, for: UIControl.State.normal)
            self.cityButton2.setTitle(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_city_btn"), for: UIControl.State.normal)
            self.cityButton2.setTitleColor(GRAY_COLOR_999999, for: UIControl.State.normal)
            self.cityButton2.isHidden = false
            
            if let _sub_city_models: [VCAPPCertificationSubCityModel] = self._total_array[indexPath.row].presumably {
                self._right_source.removeAll()
                _sub_city_models.forEach { (item: VCAPPCertificationSubCityModel) in
                    if let _city = item.chronicles {
                        self._right_source.append(_city)
                    }
                }
                
                self.rightTableView.reloadCitySource(self._right_source)
                self._selected_all = false
                self.hScrollView.setContentOffset(CGPoint(x: ScreenWidth - 8.6 * PADDING_UNIT, y: .zero), animated: true)
            }
            
            self.selected_city = self.cityButton1.currentTitle
        }
        
        if tableView == self.rightTableView {
            self.cityButton2.setTitle(self._right_source[indexPath.row], for: UIControl.State.normal)
            self.cityButton2.setTitleColor(RED_COLOR_F21915, for: UIControl.State.normal)
            self._selected_all = true
            
            self.selected_city = String(format: "%@ | %@", self.selected_city ?? "", self.cityButton2.currentTitle ?? "")
        }
    }
}

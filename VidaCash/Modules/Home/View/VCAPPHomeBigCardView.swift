//
//  VCAPPHomeBigCardView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit
import JXBanner
import JXPageControl

protocol APPHomeBigCardProtocol: AnyObject {
    func gotoApply(sender: VCAPPLoadingButton)
    func gotoService()
    func gotoAboutUs()
}

class VCAPPHomeBigCardView: UIView {

    weak open var bigDelegate: APPHomeBigCardProtocol?
    
    private lazy var bgImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_loan_top_bg"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var applyBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton("", cornerRadius: 25)
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "home_loan_arrow_image"))
    private lazy var stepLab: UILabel = UILabel.buildNormalLabel(font: UIFont.specialFont(20), labelColor: UIColor.init(hexString: "#FF8000")!, labelText: VCAPPLanguageTool.localAPPLanguage("home_big_card_step"))
    private lazy var tipLab1: UILabel = UILabel.buildNormalLabel()
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.init(red: 235/255.0, green: 240/255.0, blue: 254/255.0, alpha: 1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var leftImgview: UIImageView = UIImageView(image: UIImage(named: "home_loan_right_image"))
    private lazy var midImgView: UIImageView = UIImageView(image: UIImage(named: "home_loan_mid_image"))
    private lazy var rightImgView: UIImageView = UIImageView(image: UIImage(named: "home_loan_left_image"))
    private lazy var leftLab: UILabel = UILabel.buildNormalLabel()
    private lazy var rightLab: UILabel = UILabel.buildNormalLabel()
    
    private lazy var serviceBtn: UIButton = UIButton.buildImageButton(VCAPPCommonInfo.shared.countryCode == 1 ? "home_service_en" : "home_service_es")
    private lazy var aboutBtn: UIButton = UIButton.buildImageButton(VCAPPCommonInfo.shared.countryCode == 1 ? "home_about_us_en" : "home_about_us_es")
    private lazy var tipLab2: UILabel = UILabel.buildNormalLabel()
    private lazy var bannerView: JXBanner = {
        let banner = JXBanner()
        banner.dataSource = self
        return banner
    }()
    
    private lazy var _banner_source: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyBtn.titleLabel?.font = UIFont.specialFont(18)
        self.reloadLoanHomeBanner()
        self.midImgView.image = UIImage(named: VCAPPDiskCache.readAPPLanguageFormDiskCache() == .english ? "home_loan_mid_image" : "home_loan_mid_image_es")
        let tempStr1: NSMutableAttributedString = NSAttributedString.attachmentImage("home_loan_black_dot", afterText: false, imagePosition: 2, attributeString: VCAPPLanguageTool.localAPPLanguage("home_big_card_tip1"), textColor: BLACK_COLOR_202020, textFont: UIFont.specialFont(16))
        tempStr1.append(NSAttributedString.attachmentImage("home_loan_black_dot", afterText: true, imagePosition: 2, attributeString: "", textColor: UIColor.black, textFont: UIFont.specialFont(16)))
        self.tipLab1.attributedText = tempStr1
        
        let tempStr2: NSMutableAttributedString = NSAttributedString.attachmentImage("home_loan_black_dot", afterText: false, imagePosition: 2, attributeString: VCAPPLanguageTool.localAPPLanguage("home_big_card_tip6"), textColor: BLACK_COLOR_202020, textFont: UIFont.specialFont(16))
        tempStr2.append(NSAttributedString.attachmentImage("home_loan_black_dot", afterText: true, imagePosition: 2, attributeString: "", textColor: UIColor.black, textFont: UIFont.specialFont(16)))
        self.tipLab2.attributedText = tempStr2
        
        self.leftLab.attributedText = NSAttributedString.attributeText1(VCAPPLanguageTool.localAPPLanguage("home_big_card_tip2"), text1Color: BLACK_COLOR_202020, text1Font: UIFont.systemFont(ofSize: 16), text2: VCAPPLanguageTool.localAPPLanguage("home_big_card_tip3"), text2Color: GRAY_COLOR_999999, text1Font: UIFont.systemFont(ofSize: 14), paramDistance: 1, paraAlign: NSTextAlignment.center)
        self.rightLab.attributedText = NSAttributedString.attributeText1(VCAPPLanguageTool.localAPPLanguage("home_big_card_tip4"), text1Color: BLACK_COLOR_202020, text1Font: UIFont.systemFont(ofSize: 16), text2: VCAPPLanguageTool.localAPPLanguage("home_big_card_tip5"), text2Color: GRAY_COLOR_999999, text1Font: UIFont.systemFont(ofSize: 14), paramDistance: 1, paraAlign: NSTextAlignment.center)
        
        self.applyBtn.addTarget(self, action: #selector(clickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.serviceBtn.addTarget(self, action: #selector(clickServiceBtn(sender: )), for: UIControl.Event.touchUpInside)
        self.aboutBtn.addTarget(self, action: #selector(clickAboutUsBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.bgImgView)
        self.bgImgView.addSubview(self.applyBtn)
        self.bgImgView.addSubview(self.arrowImgView)
        self.bgImgView.addSubview(self.stepLab)
        self.bgImgView.addSubview(self.tipLab1)
        self.bgImgView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.leftImgview)
        self.subContentView.addSubview(self.midImgView)
        self.subContentView.addSubview(self.rightImgView)
        self.subContentView.addSubview(self.leftLab)
        self.subContentView.addSubview(self.rightLab)
        self.addSubview(self.serviceBtn)
        self.addSubview(self.aboutBtn)
        self.addSubview(self.tipLab2)
        self.addSubview(self.bannerView)
        
        self.bgImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
        }
        
        self.applyBtn.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(PADDING_UNIT * 6)
            make.height.equalTo(50)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.applyBtn.snp.bottom).offset(PADDING_UNIT * 3)
        }
        
        self.stepLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.top.equalTo(self.arrowImgView.snp.bottom).offset(PADDING_UNIT * 3)
        }
        
        self.tipLab1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.top.equalTo(self.stepLab.snp.bottom).offset(PADDING_UNIT)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
            make.top.equalTo(self.tipLab1.snp.bottom).offset(PADDING_UNIT * 5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.leftImgview.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(PADDING_UNIT * 2)
        }
        
        self.midImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.leftImgview)
        }
        
        self.rightImgView.snp.makeConstraints { make in
            make.top.equalTo(self.leftImgview)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
        
        self.leftLab.snp.makeConstraints { make in
            make.left.equalTo(self.leftImgview)
            make.top.equalTo(self.leftImgview.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.rightLab.snp.makeConstraints { make in
            make.top.equalTo(self.leftLab)
            make.right.equalTo(self.rightImgView)
        }
        
        self.serviceBtn.snp.makeConstraints { make in
            make.left.equalTo(self.bgImgView)
            make.top.equalTo(self.bgImgView.snp.bottom).offset(PADDING_UNIT * 3)
        }
        
        self.aboutBtn.snp.makeConstraints { make in
            make.right.equalTo(self.bgImgView)
            make.top.equalTo(self.serviceBtn)
        }
        
        self.tipLab2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.top.equalTo(self.serviceBtn.snp.bottom).offset(PADDING_UNIT * 6)
        }
        
        self.bannerView.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab2.snp.bottom).offset(PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(ScreenWidth * 0.6)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadLoanHomeBanner() {
        if VCAPPDiskCache.readAPPLanguageFormDiskCache() == .Spanish {
            self._banner_source = ["home_loan_problem_es_1", "home_loan_problem_es_2", "home_loan_problem_es_3", "home_loan_problem_es_4", "home_loan_problem_es_5"]
        } else {
            self._banner_source = ["home_loan_problem_en_1", "home_loan_problem_en_2", "home_loan_problem_en_3", "home_loan_problem_en_4", "home_loan_problem_en_5"]
        }
    }
    
    public func reloadApplyButtonTitle(_ title: String) {
        self.applyBtn.setTitle(title, for: UIControl.State.normal)
    }
}

//MARK:- JXBannerDataSource
extension VCAPPHomeBigCardView: JXBannerDataSource {
    // 注册重用Cell标识
    func jxBanner(_ banner: JXBannerType) -> (JXBannerCellRegister) {
        return JXBannerCellRegister(type: JXBannerCell.self, reuseIdentifier: "JXDefaultVCCell")
    }
    
    // 轮播总数
    func jxBanner(numberOfItems banner: JXBannerType) -> Int {
        return self._banner_source.count
    }
    
    // 轮播cell内容设置
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        let tempCell: JXBannerCell = cell as! JXBannerCell
        tempCell.imageView.image = UIImage(named: self._banner_source[index])
        tempCell.msgBgView.isHidden = true
        return tempCell
    }
    
    // banner基本设置（可选）
    func jxBanner(_ banner: JXBannerType, layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
        return layoutParams.itemSize(CGSize(width: ScreenWidth * 0.83, height: ScreenWidth * 0.6)) .itemSpacing(10)
    }
    
    func jxBanner(pageControl banner: any JXBannerType, numberOfPages: Int, coverView: UIView, builder: JXBannerPageControlBuilder) -> JXBannerPageControlBuilder {
        let pageControl = JXPageControlScale()
        pageControl.contentMode = .center
        pageControl.activeSize = CGSize(width: 15, height: 6)
        pageControl.inactiveSize = CGSize(width: 6, height: 6)
        pageControl.activeColor = BLUE_COLOR_2C65FE
        pageControl.inactiveColor = UIColor.init(red: 148/255.0, green: 170/255.0, blue: 249/255.0, alpha: 1)
        pageControl.columnSpacing = 0
        pageControl.isAnimation = true
        builder.pageControl = pageControl
        builder.layout = {
            pageControl.snp.makeConstraints { (maker) in
                maker.horizontalEdges.equalTo(coverView)
                maker.bottom.equalTo(coverView.snp.bottom).offset(-8)
                maker.height.equalTo(20)
            }
        }
        return builder
    }
    
    // banner基本设置（可选）
    func jxBanner(_ banner: JXBannerType, params: JXBannerParams) -> JXBannerParams {
        return params.timeInterval(3).isShowPageControl(false)
    }
}

@objc private extension VCAPPHomeBigCardView {
    func clickApplyButton(sender: VCAPPLoadingButton) {
        self.bigDelegate?.gotoApply(sender: sender)
    }
    
    func clickServiceBtn(sender: UIButton) {
        self.bigDelegate?.gotoService()
    }
    
    func clickAboutUsBtn(sender: UIButton) {
        self.bigDelegate?.gotoAboutUs()
    }
}

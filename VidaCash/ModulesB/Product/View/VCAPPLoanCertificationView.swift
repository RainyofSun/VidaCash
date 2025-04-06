//
//  VCAPPLoanCertificationView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit
import JXBanner
import JXPageControl

protocol APPLoanCertificationProtocol: AnyObject {
    func gotoCertification(_ citificationModel: VCAPPCertificationModel)
}

class VCAPPLoanCertificationView: UIImageView {
    
    weak open var certificationDelegate: APPLoanCertificationProtocol?
    
    private lazy var bannerView: JXBanner = {
        let banner = JXBanner()
        banner.dataSource = self
        banner.delegate = self
        return banner
    }()
    
    private var _banner_source: [VCAPPLoanBannerModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "home_loan_top_bg")
        self.isUserInteractionEnabled = true
        
        self.addSubview(self.bannerView)
        
        self.bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 13)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(ScreenWidth * 0.48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadLoanHomeBanner(_ sourceModel: [VCAPPCertificationModel]) {
        self._banner_source.removeAll()
        for item in sourceModel {
            let banner_model: VCAPPLoanBannerModel = VCAPPLoanBannerModel()
            banner_model.complete_auth = item.brokeback
            banner_model.certificationModel = item
            banner_model.imgName = item.eight
            
            self._banner_source.append(banner_model)
        }
        
        self.bannerView.reloadView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            if let _index = self._banner_source.firstIndex(where: {!$0.complete_auth}) {
                self.bannerView.scrollToIndex(_index, animated: true)
            }
        })
    }
}

//MARK:- JXBannerDataSource
extension VCAPPLoanCertificationView: JXBannerDataSource {
    // 注册重用Cell标识
    func jxBanner(_ banner: JXBannerType) -> (JXBannerCellRegister) {
        return JXBannerCellRegister(type: VCAPPLoanCertificationBannerCell.self, reuseIdentifier: NSStringFromClass(VCAPPLoanCertificationBannerCell.self))
    }
    
    // 轮播总数
    func jxBanner(numberOfItems banner: JXBannerType) -> Int {
        return self._banner_source.count
    }
    
    // 轮播cell内容设置
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        let tempCell: VCAPPLoanCertificationBannerCell = cell as! VCAPPLoanCertificationBannerCell
        tempCell.reloadCellModel(self._banner_source[index])
        return tempCell
    }
    
    // banner基本设置（可选）
    func jxBanner(_ banner: JXBannerType, layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
        return layoutParams.itemSize(CGSize(width: ScreenWidth * 0.83, height: ScreenWidth * 0.48)).itemSpacing(10)
    }
    
    func jxBanner(pageControl banner: any JXBannerType, numberOfPages: Int, coverView: UIView, builder: JXBannerPageControlBuilder) -> JXBannerPageControlBuilder {
        let pageControl = JXPageControlScale()
        pageControl.contentMode = .center
        pageControl.activeSize = CGSize(width: 15, height: 6)
        pageControl.inactiveSize = CGSize(width: 6, height: 6)
        pageControl.activeColor = RED_COLOR_F21915
        pageControl.inactiveColor = PINK_COLOR_FFE9DD
        pageControl.columnSpacing = 0
        pageControl.isAnimation = true
        builder.pageControl = pageControl
        builder.layout = {
            pageControl.snp.makeConstraints { (maker) in
                maker.horizontalEdges.equalTo(coverView)
                maker.bottom.equalTo(coverView.snp.top).offset(-PADDING_UNIT * 2)
                maker.height.equalTo(20)
            }
        }
        return builder
    }
    
    // banner基本设置（可选）
    func jxBanner(_ banner: JXBannerType, params: JXBannerParams) -> JXBannerParams {
        return params.timeInterval(3).isAutoPlay(false)
    }
}

extension VCAPPLoanCertificationView: JXBannerDelegate {
    func jxBanner(_ banner: any JXBannerType, didSelectItemAt index: Int) {
        guard let _model = self._banner_source[index].certificationModel else {
            return
        }
        self.certificationDelegate?.gotoCertification(_model)
    }
}

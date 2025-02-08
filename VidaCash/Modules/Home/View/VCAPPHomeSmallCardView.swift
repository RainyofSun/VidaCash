//
//  VCAPPHomeSmallCardView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/5.
//

import UIKit

protocol APPHomeSmallCardProtocol: AnyObject {
    func gotoProductApply(sender: VCAPPLoadingButton)
    func didSelectedLoanProduct(_ model: VCAPPLoanProductModel, sender: VCAPPLoadingButton)
}

class VCAPPHomeSmallCardView: UIView {

    weak open var smallDelegate: APPHomeSmallCardProtocol?
    
    private lazy var bgImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_loan_top_bg"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var applyBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton("", cornerRadius: 25)
    private lazy var productCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = PADDING_UNIT * 2
        layout.minimumInteritemSpacing = PADDING_UNIT * 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: PADDING_UNIT * 3, bottom: 0, right: PADDING_UNIT * 3)
        let width: CGFloat = (ScreenWidth - layout.sectionInset.left - layout.sectionInset.right - layout.minimumLineSpacing - PADDING_UNIT * 8) * 0.5
        layout.itemSize = CGSize(width: width, height: 210)
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var _product_source: [VCAPPLoanProductModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.applyBtn.titleLabel?.font = UIFont.specialFont(18)
        self.applyBtn.addTarget(self, action: #selector(clickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.productCollectionView.register(VCAPPHomeSmallCardViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(VCAPPHomeSmallCardViewCell.self))
        
        self.addSubview(self.bgImgView)
        self.bgImgView.addSubview(self.applyBtn)
        self.bgImgView.addSubview(self.productCollectionView)
        
        self.bgImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
        }
        
        self.applyBtn.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(PADDING_UNIT * 6)
            make.height.equalTo(50)
        }
        
        self.productCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.applyBtn.snp.bottom).offset(PADDING_UNIT * 5)
            make.height.equalTo(ScreenHeight * 0.4)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadLoanProducts(_ products: [VCAPPLoanProductModel]) {
        self._product_source.removeAll()
        self._product_source.append(contentsOf: products)
        self.productCollectionView.reloadData()
    }
    
    public func reloadApplyButtonTitle(_ title: String) {
        self.applyBtn.setTitle(title, for: UIControl.State.normal)
    }
}

extension VCAPPHomeSmallCardView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._product_source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(VCAPPHomeSmallCardViewCell.self), for: indexPath) as? VCAPPHomeSmallCardViewCell else {
            return UICollectionViewCell()
        }
        
        _cell.reloadCollectionViewCellModel(model: self._product_source[indexPath.item])
        return _cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _cell = collectionView.cellForItem(at: indexPath) as? VCAPPHomeSmallCardViewCell else {
            return
        }
        
        self.smallDelegate?.didSelectedLoanProduct(self._product_source[indexPath.item], sender: _cell.detailBtn)
    }
}

@objc private extension VCAPPHomeSmallCardView {
    func clickApplyButton(sender: VCAPPLoadingButton) {
        self.smallDelegate?.gotoProductApply(sender: sender)
    }
}

//
//  VCAPPMineItemView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/3.
//

import UIKit

class VCAPPMineItemView: UIControl {

    open var jumpUrl: String?
    
    private lazy var imgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: BLACK_COLOR_202020)
    private lazy var markImgView: UIImageView = UIImageView(image: UIImage(named: "mine_user_item"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.markImgView)
        
        self.imgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.size.equalTo(30)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 7)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.imgView.snp.right).offset(PADDING_UNIT * 2)
            make.right.equalToSuperview().offset(-PADDING_UNIT)
            make.centerY.equalTo(self.imgView)
        }
        
        self.markImgView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadMineItem(itemModel: VCAPPMineItemModel) {
        self.titleLab.text = itemModel.endows
        if let _u = itemModel.mexican, let _url = URL(string: _u) {
            self.imgView.setImageWith(_url, options: YYWebImageOptions.progressiveBlur)
        }
        self.jumpUrl = itemModel.stating
    }
}

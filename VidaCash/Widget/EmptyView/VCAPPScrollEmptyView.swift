//
//  VCAPPScrollEmptyView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPScrollEmptyView: UIView {

    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "order_empty"))
    private lazy var emptyLab: UILabel = UILabel.buildVdidaCashNormalLabel(labelColor: GRAY_COLOR_999999, labelText: VCAPPLanguageTool.localAPPLanguage("order_empty_title"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.emptyImgView)
        self.addSubview(self.emptyLab)
        
        self.emptyImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(115)
        }
        
        self.emptyLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalTo(self.emptyImgView.snp.bottom).offset(PADDING_UNIT * 2)
            make.height.equalTo(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func resetEmptyImgAndTitle(_ name: String, title: String) {
        self.emptyImgView.image = UIImage(named: name)
        self.emptyLab.text = title
    }
}

//
//  VCAPPProcessItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

class VCAPPProcessItem: UIImageView {

    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 14), labelColor: BLUE_COLOR_2C65FE)
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 14)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadProcessItem(_ model: VCAPPProcessModel) {
        self.titleLab.text = model.title
    }
}

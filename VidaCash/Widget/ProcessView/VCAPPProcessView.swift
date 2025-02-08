//
//  VCAPPProcessView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

class VCAPPProcessView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func buildProcessItem(_ models: [VCAPPProcessModel]) {
        var _left_item: VCAPPProcessItem?
        
        models.enumerated().forEach { (idx: Int, itemModel: VCAPPProcessModel) in
            let view = VCAPPProcessItem(image: UIImage(named: itemModel.bgImage ?? ""))
            view.reloadProcessItem(itemModel)
            self.addSubview(view)
            
            if let _left = _left_item {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_left.snp.right).offset(PADDING_UNIT * 3)
                        make.top.width.equalTo(_left)
                        make.right.equalToSuperview()
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_left.snp.right).offset(PADDING_UNIT * 3)
                        make.top.width.equalTo(_left)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.left.equalToSuperview()
                    make.width.equalTo(100)
                }
            }
            
            _left_item = view
        }
    }
}

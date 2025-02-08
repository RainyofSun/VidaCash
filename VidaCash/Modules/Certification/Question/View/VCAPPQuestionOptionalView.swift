//
//  VCAPPQuestionOptionalView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

class VCAPPQuestionOptionalView: UIControl {

    open var optionalDict: [String: String] = [:]
    open var selectedTag: String?
    
    private(set) lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: BLACK_COLOR_202020)
    private lazy var completeImgView: UIImageView = UIImageView(image: UIImage(named: "certification_question_complete"))
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? BLUE_COLOR_2C65FE : UIColor.init(rgba: 0x2C65FE1A)
            self.titleLab.textColor = isSelected ? .white : BLACK_COLOR_202020
            self.completeImgView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = (25 + PADDING_UNIT * 5) * 0.5
        self.clipsToBounds = true
        
        self.isSelected = false
        self.backgroundColor = UIColor.init(hexString: "#2C65FE")!
        
        self.addSubview(self.titleLab)
        self.addSubview(self.completeImgView)
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 5)
            make.centerY.equalToSuperview()
        }
        
        self.completeImgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 2.5)
            make.size.equalTo(25)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

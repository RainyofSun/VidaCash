//
//  VCAPPOrderMenuItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/4.
//

import UIKit

enum APPOrderMenuItemStyle: String {
    case Menu_Apply = "order_menu_apply"
    case Menu_Repayment = "order_menu_repayment"
    case Menu_Finished = "order_menu_finished"
    case Menu_Card = "--"
    case Menu_Face = "---"
    
    func menuImageOffName() -> String {
        switch self {
        case .Menu_Apply:
            return "order_menu_apply_off"
        case .Menu_Repayment:
            return "order_menu_repayment_off"
        case .Menu_Finished:
            return "order_menu_finsh_off"
        case .Menu_Card:
            return "certification_card_off"
        case .Menu_Face:
            return "certification_face_off"
        }
    }
    
    func menuImageOnName() -> String {
        switch self {
        case .Menu_Apply:
            return "order_menu_apply_on"
        case .Menu_Repayment:
            return "order_menu_repayment_on"
        case .Menu_Finished:
            return "order_menu_finish_on"
        case .Menu_Card:
            return "certification_card_on"
        case .Menu_Face:
            return "certification_face_on"
        }
    }
}

class VCAPPOrderMenuItem: UIControl {

    open var itemType: APPOrderMenuItemStyle = .Menu_Apply
    
    private lazy var imgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: GRAY_COLOR_999999)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.init(red: 239/255.0, green: 135/255.0, blue: 51/255.0, alpha: 1)
                self.titleLab.textColor = .white
                self.imgView.image = UIImage(named: self.itemType.menuImageOnName())
            } else {
                self.backgroundColor = .white
                self.titleLab.textColor = GRAY_COLOR_999999
                self.imgView.image = UIImage(named: self.itemType.menuImageOffName())
            }
        }
    }
    
    init(frame: CGRect, menuItemType type: APPOrderMenuItemStyle) {
        super.init(frame: frame)
        self.itemType = type
        self.isSelected = type == .Menu_Apply
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        
        self.titleLab.text = VCAPPLanguageTool.localAPPLanguage(type.rawValue)

        self.imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 6)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadTitle(_ title: String?) {
        self.titleLab.text = title
    }
    
    public func setMenuItemImage(_ image: String) {
        self.imgView.image = UIImage(named: image)
        self.backgroundColor = UIColor.init(red: 93/255.0, green: 203/255.0, blue: 61/255.0, alpha: 1)
        self.titleLab.textColor = .white
    }
}

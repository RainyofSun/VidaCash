//
//  VCAPPMineSettingItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/3.
//

import UIKit

enum MineSettingType: String {
    case Version = "mine_setting_version"
    case Cancelation = "mine_setting_cancel"
    case Logout = "mine_setting_logout"
}

class VCAPPMineSettingItem: UIControl {

    open var setting_type: MineSettingType = .Version
    
    private lazy var imgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_202020)
    
    init(frame: CGRect, settingType type: MineSettingType) {
        super.init(frame: frame)
        self.setting_type = type
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.titleLab.textAlignment = .left
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        
        switch type {
        case .Version:
            if let _version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                self.titleLab.text = VCAPPLanguageTool.localAPPLanguage(type.rawValue) + "V" + _version
            }
            self.imgView.image = UIImage(named: "mine_setting_version")
        case .Cancelation:
            self.titleLab.text = VCAPPLanguageTool.localAPPLanguage(type.rawValue)
            self.imgView.image = UIImage(named: "mine_setting_cacncel")
        case .Logout:
            self.titleLab.text = VCAPPLanguageTool.localAPPLanguage(type.rawValue)
            self.imgView.image = UIImage(named: "mine_setting_logout")
        }
        
        self.imgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(PADDING_UNIT * 4.5)
            make.size.equalTo(25)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.imgView)
            make.top.equalTo(self.imgView.snp.bottom).offset(PADDING_UNIT * 3)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

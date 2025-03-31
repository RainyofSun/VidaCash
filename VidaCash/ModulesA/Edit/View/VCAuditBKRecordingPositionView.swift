//
//  VCAuditBKRecordingPositionView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

class VCAuditBKRecordingPositionView: UIView {

    open var location: String?
    
    open var openPosition: Bool {
        return self.swicthControl.isOn
    }
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var swicthControl: UISwitch = {
        let view = UISwitch(frame: CGRectZero)
        view.onTintColor = RED_COLOR_F21915
        view.tintColor = PINK_COLOR_FFE9DD
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.swicthControl.addTarget(self, action: #selector(swicthDidChange(sender: )), for: UIControl.Event.valueChanged)
        self.titleLab.textAlignment = .left
        
        let parastyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parastyle.paragraphSpacing = PADDING_UNIT
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: "Position\n", attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.systemFont(ofSize: 16), .paragraphStyle: parastyle])
        attributeStr.append(NSAttributedString(string: "Get geographic location", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14)]))
        self.titleLab.attributedText = attributeStr
        
        self.backgroundColor = .white
        
        self.addSubview(self.titleLab)
        self.addSubview(self.swicthControl)
        
        self.titleLab.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.width.equalTo(ScreenWidth * 0.5)
        }
        
        self.swicthControl.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

@objc private extension VCAuditBKRecordingPositionView {
    func swicthDidChange(sender: UISwitch) {
        guard sender.isOn else {
            return
        }
        
        VCAPPAuthorizationTool.authorization().requestDeviceLocationAuthrization(WhenInUse)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            if VCAPPAuthorizationTool.authorization().locationAuthorization() == Authorized || VCAPPAuthorizationTool.authorization().locationAuthorization() == Limited {
                VCAPPLocationTool.location().startDeviceLocation()
                
                // 省
                if let _locatity = VCAPPLocationTool.location().placeMark.locality {
                    self.location = _locatity
                }
                
                // 直辖市
                if let _city = VCAPPLocationTool.location().placeMark.administrativeArea {
                    self.location = String(format: "%@,%@", self.location ?? "", _city)
                }
                
                // 街道
                if let _street = VCAPPLocationTool.location().placeMark.thoroughfare {
                    self.location = String(format: "%@,%@", self.location ?? "", _street)
                }
                
                // 区/县
                if let _area = VCAPPLocationTool.location().placeMark.subLocality {
                    self.location = String(format: "%@,%@", self.location ?? "", _area)
                }
            }
        })
    }
}

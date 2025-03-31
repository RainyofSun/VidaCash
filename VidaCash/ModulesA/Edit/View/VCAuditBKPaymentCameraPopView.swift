//
//  VCAuditBKPaymentCameraPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/21.
//

import UIKit

enum AuditBKPaymentCameraItemType: String {
    case Camera = "Camera"
    case Thumb = "Photo Album"
    
    func picture() -> String {
        switch self {
        case .Camera:
            return "bk_pop_camera"
        case .Thumb:
            return "bk_pop_thumb"
        }
    }
}

class VCAuditBKPaymentCameraItem: UIControl {
    
    open var item_type: AuditBKPaymentCameraItemType = .Camera
    
    private lazy var imgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.boldSystemFont(ofSize: 18), labelColor: BLACK_COLOR_0B0A0A)
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "bk_pop_arrow"))
    
    init(frame: CGRect, style: AuditBKPaymentCameraItemType) {
        super.init(frame: frame)
        
        self.titleLab.text = style.rawValue
        
        self.backgroundColor = .white
        self.corner(16)
        
        self.imgView.image = UIImage(named: style.picture())
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.arrowImgView)
        
        self.imgView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.left.equalToSuperview().offset(PADDING_UNIT * 7.5)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.imgView)
            make.left.equalTo(self.imgView.snp.right).offset(PADDING_UNIT * 4)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
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

class VCAuditBKPaymentCameraPopView: VCAuditBKBasePopView {

    open var mediaClosure: ((Bool) -> Void)?
    
    private lazy var cameraView: VCAuditBKPaymentCameraItem = VCAuditBKPaymentCameraItem(frame: CGRectZero, style: AuditBKPaymentCameraItemType.Camera)
    private lazy var thumbView: VCAuditBKPaymentCameraItem = VCAuditBKPaymentCameraItem(frame: CGRectZero, style: AuditBKPaymentCameraItemType.Thumb)
    
    override func buildBKPopViews() {
        super.buildBKPopViews()
        
        self.imgContentView.image = UIImage(named: "bk_pop_bg2")
        self.confirmBtn.isHidden = true
        
        self.cameraView.addTarget(self, action: #selector(clickItemControl(sender: )), for: UIControl.Event.touchUpInside)
        self.thumbView.addTarget(self, action: #selector(clickItemControl(sender: )), for: UIControl.Event.touchUpInside)
        
        self.imgContentView.addSubview(self.cameraView)
        self.imgContentView.addSubview(self.thumbView)
    }
    
    override func layoutBKPopViews() {
        super.layoutBKPopViews()
        
        self.imgContentView.snp.remakeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(ScreenWidth * 0.642)
        }
        
        self.cameraView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 4)
        }
        
        self.thumbView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.cameraView)
            make.top.equalTo(self.cameraView.snp.bottom).offset(PADDING_UNIT * 4)
        }
    }
}

@objc private extension VCAuditBKPaymentCameraPopView {
    func clickItemControl(sender: VCAuditBKPaymentCameraItem) {
        self.mediaClosure?(sender == self.cameraView)
        self.bk_dismissPop()
    }
}

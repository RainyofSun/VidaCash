//
//  VCAPPCertificationContactsItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

protocol APPCertificationContactsItemProtocol: AnyObject {
    func touchContactsItem(itemView: VCAPPCertificationContactsItem, isRelationShip: Bool)
}

class VCAPPCertificationContactsItem: UIView {

    weak open var delegate: APPCertificationContactsItemProtocol?
    open var choise: [VCAPPQuestionChoiseModel]?
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), labelColor: RED_COLOR_F21915)
    private lazy var relationItem: VCAPPCertificationInfoItemView = VCAPPCertificationInfoItemView(frame: CGRectZero)
    private lazy var phoneItem: VCAPPCertificationInfoItemView = VCAPPCertificationInfoItemView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.relationItem.infoDelegate = self
        self.phoneItem.infoDelegate = self
        
        self.addSubview(self.titleLab)
        self.addSubview(self.relationItem)
        self.addSubview(self.phoneItem)
        
        self.titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.relationItem.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 10, height: (ScreenWidth - PADDING_UNIT * 10) * 0.28))
            make.left.equalToSuperview().offset(PADDING_UNIT * 5)
        }
        
        self.phoneItem.snp.makeConstraints { make in
            make.top.equalTo(self.relationItem.snp.bottom).offset(PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 10, height: (ScreenWidth - PADDING_UNIT * 10) * 0.28))
            make.left.equalToSuperview().offset(PADDING_UNIT * 5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadContactsModel(_ model: VCAPPPeopleCertificationModel) {
        self.titleLab.text = model.endows
        self.choise = model.narnia
        self.relationItem.reloadContactRelationShipModel(model: model, type: InputViewType.Input_Enum)
        self.phoneItem.reloadContactPhoneModel(model: model, type: InputViewType.Input_Enum)
    }
    
    public func reloadRelationShipAndPhone(relationShip: String? = nil, phone: String? = nil) {
        self.relationItem.reloadInfo(relationShip)
        self.phoneItem.reloadInfo(phone)
    }
}

extension VCAPPCertificationContactsItem: APPCertificationInfoItemProtocol {
    func touchCertificationInfo(itemView: VCAPPCertificationInfoItemView) {
        self.delegate?.touchContactsItem(itemView: self, isRelationShip: itemView == self.relationItem)
    }
    
    func didEndEditing(itemView: VCAPPCertificationInfoItemView, inputValue: String?) {
        
    }
}

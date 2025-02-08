//
//  VCAPPCardInfoPopItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

enum APPCardInfoPopItemType: String {
    case Name = "certification_card_pop_name"
    case IDNumber = "certification_card_pop_id"
    case Birthday = "certification_card_pop_birthday"
}

protocol APPCardInfoPopItemProtocol: AnyObject {
    func didBeginEditing(popItem: VCAPPCardInfoPopItem)
}

class VCAPPCardInfoPopItem: UIView {
    
    weak open var itemDelegate: APPCardInfoPopItemProtocol?
    
    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: GRAY_COLOR_999999)
    private(set) lazy var inputTextFiledView: VCAPPNoActionTextFiled = VCAPPNoActionTextFiled.buildNormalTextFiled(placeHolder: NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("certification_card_pop_place"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 14)]))
    
    open var itemType: APPCardInfoPopItemType = .Name
    
    init(frame: CGRect, itemType type: APPCardInfoPopItemType) {
        super.init(frame: frame)
        self.itemType = type
        
        self.titleLab.text = VCAPPLanguageTool.localAPPLanguage(type.rawValue)
        
        self.inputTextFiledView.layer.borderColor = BLUE_COLOR_2C65FE.cgColor
        self.inputTextFiledView.layer.borderWidth = 1
        
        self.inputTextFiledView.delegate = self
        
        self.addSubview(self.titleLab)
        self.addSubview(self.inputTextFiledView)
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT)
        }
        
        self.inputTextFiledView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

extension VCAPPCardInfoPopItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.itemDelegate?.didBeginEditing(popItem: self)
        return self.itemType != .Birthday
    }
}

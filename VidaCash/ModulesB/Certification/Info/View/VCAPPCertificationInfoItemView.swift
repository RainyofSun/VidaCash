//
//  VCAPPCertificationInfoItemView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

protocol APPCertificationInfoItemProtocol: AnyObject {
    func touchCertificationInfo(itemView: VCAPPCertificationInfoItemView)
    func didEndEditing(itemView: VCAPPCertificationInfoItemView, inputValue: String?)
}

class VCAPPCertificationInfoItemView: UIImageView {

    weak open var infoDelegate: APPCertificationInfoItemProtocol?
    open var infoChoiseModels: [VCAPPQuestionChoiseModel]?
    open var paramsKey: String?
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.boldSystemFont(ofSize: 15), labelColor: .white)
    private lazy var inputTextFiled: VCAPPNoActionTextFiled = {
        let view = VCAPPNoActionTextFiled.buildVidasdCashNormalTextFiled(placeHolder: NSAttributedString(string: VCAPPLanguageTool.localAPPLanguage("certification_card_pop_place"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 18)]))
        let imgView: UIImageView = UIImageView(image: UIImage(named: "certification_right_img"))
        view.rightView = imgView
        view.rightViewMode = .always
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) var _input_type: InputViewType = .Input_Text
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "certification_info_bg")
        
        self.isUserInteractionEnabled = true
        
        self.inputTextFiled.delegate = self
        
        self.addSubview(self.titleLab)
        self.addSubview(self.inputTextFiled)
        
        let _height = (ScreenWidth - PADDING_UNIT * 10) * 0.28
        self.titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(_height * 0.19)
            make.left.equalToSuperview().offset(PADDING_UNIT * 7)
        }
        
        self.inputTextFiled.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(_height * 0.1)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(_height * 0.45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadCertificationInfoOptionalInfo(_ model: VCAPPQuestionModel) {
        self._input_type = model.inputType
        self.infoChoiseModels = model.narnia
        self.paramsKey = model.canceled
        
        if let _place = model.international {
            self.inputTextFiled.attributedPlaceholder = NSAttributedString(string: _place, attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 18)])
        }
        
        if let _back = model.greater {
            if let _choises = model.narnia, let _item = _choises.first(where: {$0.ability == _back}) {
                self.inputTextFiled.text = _item.chronicles
            } else {
                self.inputTextFiled.text = _back
            }
        }
        
        self.inputTextFiled.keyboardType = model.fun ? .numberPad : .default
        self.titleLab.text = model.endows
        
        self.inputTextFiled.rightViewMode = self._input_type == .Input_Enum ? .always : .never
    }
    
    public func reloadContactRelationShipModel(model: VCAPPPeopleCertificationModel, type: InputViewType) {
        self._input_type = type
        if let _place = model.sense {
            self.inputTextFiled.attributedPlaceholder = NSAttributedString(string: _place, attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 18)])
        }
        
        if let _title = model.immersion {
            self.titleLab.text = _title
        }
        
        if let _relation = model.esthetic, let _choise = model.narnia, let item = _choise.first(where: {$0.ability == _relation}) {
            self.inputTextFiled.text = item.chronicles
        }
    }
    
    public func reloadContactPhoneModel(model: VCAPPPeopleCertificationModel, type: InputViewType) {
        self._input_type = type
        if let _place = model.readers {
            self.inputTextFiled.attributedPlaceholder = NSAttributedString(string: _place, attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 18)])
        }
        
        if let _title = model.enjoyed {
            self.titleLab.text = _title
        }
        
        if let _name = model.chronicles, let _phone = model.harrowing, !_name.isEmpty && !_phone.isEmpty {
            self.inputTextFiled.text = _name + " - " + _phone
        }
    }
    
    public func reloadInfo(_ info: String?) {
        if let _i = info {
            self.inputTextFiled.text = _i
        }
    }
}

extension VCAPPCertificationInfoItemView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.infoDelegate?.touchCertificationInfo(itemView: self)
        return self._input_type == .Input_Text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.infoDelegate?.didEndEditing(itemView: self, inputValue: textField.text)
    }
}

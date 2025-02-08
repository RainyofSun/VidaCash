//
//  VCAPPCertificationInfoSinglePopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit
import BRPickerView

class VCAPPCertificationInfoSinglePopView: VCAPPBasePopView {
    
    open var selectedModel: VCAPPQuestionChoiseModel?
    
    private lazy var pickerView: BRTextPickerView = {
        let _pickView = BRTextPickerView(pickerMode: BRTextPickerMode.componentSingle)
        let style: BRPickerStyle = BRPickerStyle()
        style.hiddenDoneBtn = true
        style.hiddenCancelBtn = true
        style.hiddenTitleLine = true
        style.pickerColor = .white
        style.pickerTextColor = BLACK_COLOR_202020;
        style.pickerTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        style.selectRowTextColor = BLUE_COLOR_2C65FE
        style.pickerHeight = 250
        _pickView.pickerStyle = style
        return _pickView
    }()
    
    private lazy var pickerContentView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth - PADDING_UNIT * 16.6, height: 250))
    private lazy var confirmBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_confirm"), cornerRadius: 25)
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("certification_card_pop_choise")
        
        self.confirmBtn.addTarget(self, action: #selector(confirmButton(sender: )), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(self.pickerContentView)
        self.contentView.addSubview(self.confirmBtn)
        
        self.pickerView.addPicker(to: self.pickerContentView)
        
        self.pickerView.singleChangeBlock = {[weak self] (model: BRTextModel?, idx: Int) in
            self?.selectedModel = VCAPPQuestionChoiseModel()
            self?.selectedModel?.ability = model?.code
            self?.selectedModel?.chronicles = model?.text
        }
        
        self.pickerView.singleResultBlock = {[weak self] (model: BRTextModel?, idx: Int) in
            self?.selectedModel = VCAPPQuestionChoiseModel()
            self?.selectedModel?.ability = model?.code
            self?.selectedModel?.chronicles = model?.text
        }
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.pickerContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
        
        self.confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(self.pickerContentView.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPCertificationInfoSinglePopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    public func reloadSignlePopSource(_ data: [VCAPPQuestionChoiseModel]) -> Self {
        var source_array: [[String: String]] = []
        data.forEach { (item: VCAPPQuestionChoiseModel) in
            if let _code = item.ability, let _text = item.chronicles {
                source_array.append(["code": _code, "text": _text])
            }
        }
        
        self.pickerView.dataSourceArr = NSArray.br_modelArray(withJson: source_array, mapper: nil)
        self.pickerView.reloadData()
        
        return self
    }
}

// MARK: Target
@objc private extension VCAPPCertificationInfoSinglePopView {
    
    func confirmButton(sender: UIButton) {
        self.pickerView.doneBlock?()
        self.dismissPop()
    }
}

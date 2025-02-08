//
//  VCAPPCardInfoPopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

class VCAPPCardInfoPopView: VCAPPBasePopView {
    
    open var didConfirmClousre: ((String?, String?, String?, VCAPPLoadingButton, VCAPPCardInfoPopView) -> Void)?
    
    private lazy var nameItem: VCAPPCardInfoPopItem = VCAPPCardInfoPopItem(frame: CGRectZero, itemType: APPCardInfoPopItemType.Name)
    private lazy var idItem: VCAPPCardInfoPopItem = VCAPPCardInfoPopItem(frame: CGRectZero, itemType: APPCardInfoPopItemType.IDNumber)
    private lazy var birthdayItem: VCAPPCardInfoPopItem = VCAPPCardInfoPopItem(frame: CGRectZero, itemType: APPCardInfoPopItemType.Birthday)
    private lazy var tipLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 12), labelColor: UIColor.init(hexString: "#FF6A00")!, labelText: VCAPPLanguageTool.localAPPLanguage("certification_card_pop_tip"))
    private lazy var confirmBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_confirm"), cornerRadius: 25)
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("certification_card_pop_title")
        self.closeBtn.isHidden = true
        
        self.birthdayItem.itemDelegate = self
        self.confirmBtn.addTarget(self, action: #selector(clickConfirmButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.nameItem)
        self.contentView.addSubview(self.idItem)
        self.contentView.addSubview(self.birthdayItem)
        self.contentView.addSubview(self.tipLab)
        self.contentView.addSubview(self.confirmBtn)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.nameItem.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
        }
        
        self.idItem.snp.makeConstraints { make in
            make.top.equalTo(self.nameItem.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.nameItem)
        }
        
        self.birthdayItem.snp.makeConstraints { make in
            make.top.equalTo(self.idItem.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.idItem)
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.top.equalTo(self.birthdayItem.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.birthdayItem)
        }
        
        self.confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalTo(self.tipLab)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    public func reloadInfoPopView(_ model: VCAPPCardInfoModel) -> Self {
        self.nameItem.inputTextFiledView.text = model.air
        self.idItem.inputTextFiledView.text = model.simplistic
        self.birthdayItem.inputTextFiledView.text = model.cinemascore
        
        return self
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPCardInfoPopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

extension VCAPPCardInfoPopView: APPCardInfoPopItemProtocol {
    func didBeginEditing(popItem: VCAPPCardInfoPopItem) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = .zero
        }
        
        if let _super_view = self.superview {
            VCAPPCardITimePopView.convenienceShowPop(_super_view).popDidmissClosure = {(view: VCAPPBasePopView) in
                if let _dateView = view as? VCAPPCardITimePopView, let _new_time = _dateView.selectedDate {
                    popItem.inputTextFiledView.text = _new_time
                }
                UIView.animate(withDuration: 0.3) {
                    view.alpha = .zero
                    self.alpha = 1
                }
            }
        }
    }
}

@objc private extension VCAPPCardInfoPopView {
    func clickConfirmButton(sender: VCAPPLoadingButton) {
        self.didConfirmClousre?(self.nameItem.inputTextFiledView.text, self.idItem.inputTextFiledView.text, self.birthdayItem.inputTextFiledView.text, sender, self)
    }
}

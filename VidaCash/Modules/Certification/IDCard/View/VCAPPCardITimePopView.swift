//
//  VCAPPCardITimePopView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit
import BRPickerView

class VCAPPCardITimePopView: VCAPPBasePopView {

    private lazy var timePickerView: BRDatePickerView = {
        let picker = BRDatePickerView(frame: CGRectZero)
        picker.minDate = NSDate.br_setYear(1949, month: 3, day: 12)
        picker.maxDate = NSDate.now
        picker.pickerMode = .YMD
        let pickerStyle = BRPickerStyle()
        pickerStyle.hiddenDoneBtn = true
        pickerStyle.hiddenCancelBtn = true
        pickerStyle.hiddenTitleLine = true
        pickerStyle.pickerColor = .clear
        pickerStyle.pickerTextColor = BLACK_COLOR_202020
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        //pickerStyle.selectRowBgImg = UIImage(named: "certification_time_pop")
        pickerStyle.selectRowTextColor = BLUE_COLOR_2C65FE
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        pickerStyle.pickerHeight = 305
#if DEBUG
        pickerStyle.language = "en"
#else
        if VCAPPDiskCache.readAPPLanguageFormDiskCache() == .Spanish {
            pickerStyle.language = "es"
        } else {
            pickerStyle.language = "en"
        }
#endif
        picker.pickerStyle = pickerStyle
        
        return picker
    }()
    
    private lazy var pickerContentView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth - PADDING_UNIT * 16.6, height: 305))
    
    private lazy var confirmBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildGradientLoadingButton(VCAPPLanguageTool.localAPPLanguage("certification_card_pop_confirm"), cornerRadius: 25)
    private(set) var selectedDate: String?
    
    override func buildPopViews() {
        super.buildPopViews()

        self.popTitleLab.text = VCAPPLanguageTool.localAPPLanguage("certification_card_pop_time")
        
        self.contentView.addSubview(self.pickerContentView)
        self.contentView.addSubview(self.confirmBtn)
        
        self.confirmBtn.addTarget(self, action: #selector(confirmButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.timePickerView.addPicker(to: self.pickerContentView)
        
        self.timePickerView.resultBlock = {[weak self] (selectDate: Date?, selectValue: String?) in
            self?.selectedDate = selectValue
        }
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.pickerContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(305)
        }
        
        self.confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(self.pickerContentView.snp.bottom).offset(PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
    }
    
    override class func convenienceShowPop(_ superView: UIView) -> Self {
        let view = VCAPPCardITimePopView(frame: UIScreen.main.bounds)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

// MARK: Target
@objc private extension VCAPPCardITimePopView {
    
    func confirmButton(sender: UIButton) {
        self.timePickerView.doneBlock?()
        self.dismissPop()
    }
}

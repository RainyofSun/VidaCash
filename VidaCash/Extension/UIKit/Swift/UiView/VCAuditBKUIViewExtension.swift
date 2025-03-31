//
//  VCAuditBKUIViewExtension.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit
import BRPickerView

extension UIView {
    
    func showSingleChoiseView(dataSource: [String], title: String, handle: ( @escaping (String?) -> Void)) {
        let textPickerView: BRTextPickerView = BRTextPickerView(pickerMode: BRTextPickerMode.componentSingle)
        let pickerStyle: BRPickerStyle = BRPickerStyle()
        pickerStyle.topCornerRadius = 8
        pickerStyle.titleTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.titleTextColor = BLACK_COLOR_333333
        pickerStyle.cancelBtnTitle = "Cancel"
        pickerStyle.cancelTextColor = UIColor.hexStringColor(hexString:"#58AFFC")
        pickerStyle.cancelTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneBtnTitle = "Confirm"
        pickerStyle.doneTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneTextColor = UIColor.hexStringColor(hexString: "#58AFFC")
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 14)
        pickerStyle.pickerTextColor = UIColor.hexStringColor(hexString: "#656C74")
        pickerStyle.selectRowTextColor = BLACK_COLOR_333333
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.language = "en"
        textPickerView.pickerStyle = pickerStyle
        
        textPickerView.dataSourceArr = dataSource
        textPickerView.singleResultBlock = { (selectedModel: BRTextModel?, idx: Int) in
            handle(selectedModel?.text)
        }
        
        textPickerView.show()
    }
    
    func showTimePicker(pickerMode: BRDatePickerMode = .YM, handle: ( @escaping (Date?) -> Void)) {
        let timePicker: BRDatePickerView = BRDatePickerView.init(pickerMode: BRDatePickerMode.YMD)
        timePicker.maxDate = Date()
        timePicker.minDate = Date.distantPast
        timePicker.pickerMode = pickerMode
        let pickerStyle: BRPickerStyle = BRPickerStyle()
        pickerStyle.topCornerRadius = 15
        pickerStyle.titleTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.titleTextColor = BLACK_COLOR_333333
        pickerStyle.cancelBtnTitle = "Cancel"
        pickerStyle.cancelTextColor = BLACK_COLOR_0B0A0A
        pickerStyle.cancelTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneBtnTitle = "Confirm"
        pickerStyle.doneTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneTextColor = BLACK_COLOR_0B0A0A
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 14)
        pickerStyle.pickerTextColor = UIColor.hexStringColor(hexString: "#656C74")
        pickerStyle.selectRowTextColor = RED_COLOR_F21915
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.language = "en"
        timePicker.pickerStyle = pickerStyle
        
        timePicker.resultBlock = { (sel_date: Date?, sel_time_text: String?) in
            handle(sel_date)
        }
        
        timePicker.show()
    }
}

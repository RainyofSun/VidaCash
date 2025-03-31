//
//  VCAPPLoanIDCardViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/6.
//

import UIKit

class VCAPPLoanIDCardViewController: VCAPPLoanCertificationViewController {

    private lazy var topTipImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var cardItem: VCAPPOrderMenuItem = VCAPPOrderMenuItem(frame: CGRectZero, menuItemType: APPOrderMenuItemStyle.Menu_Card)
    private lazy var faceItem: VCAPPOrderMenuItem = VCAPPOrderMenuItem(frame: CGRectZero, menuItemType: APPOrderMenuItemStyle.Menu_Face)
    private lazy var hScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentSize = CGSize(width: ScreenWidth * 2, height: 0)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var cardBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var cardErrorImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var faceBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var faceErrorImgView: UIImageView = UIImageView(frame: CGRectZero)
    private var _card_certification_model: VCAPPCardModel?
    private var _is_face: Bool = false
    private var temp_dict: [String: String] = [:]
    
    override func buildViewUI() {
        super.buildViewUI()
        self.processView.isHidden = true
        self.contentView.isHidden = true
        
        self.cardItem.isSelected = true
        self.cardBtn.layer.cornerRadius = 8
        self.cardBtn.clipsToBounds = true
        self.faceBtn.layer.cornerRadius = 8
        self.faceBtn.clipsToBounds = true
        
        if VCAPPDiskCache.readAPPLanguageFormDiskCache() == .Spanish {
            self.topTipImgView.image = UIImage(named: "certification_card_top_tip_es")
            self.cardErrorImgView.image = UIImage(named: "certification_card_error_tip_es")
            self.faceErrorImgView.image = UIImage(named: "certification_card_face_tip_es")
        } else {
            self.topTipImgView.image = UIImage(named: "certification_card_top_tip")
            self.cardErrorImgView.image = UIImage(named: "certification_card_error_tip")
            self.faceErrorImgView.image = UIImage(named: "certification_card_face_tip")
        }
        
        self.cardBtn.setBackgroundImage(UIImage(named: "certification_card"), for: UIControl.State.normal)
        self.faceBtn.setBackgroundImage(UIImage(named: "certification_face"), for: UIControl.State.normal)
        self.cardBtn.addTarget(self, action: #selector(clickCardButton(sender: )), for: UIControl.Event.touchUpInside)
        self.faceBtn.addTarget(self, action: #selector(clickFaceButton(sender: )), for: UIControl.Event.touchUpInside)
        self.cardItem.addTarget(self, action: #selector(clickCardItem(sender: )), for: UIControl.Event.touchUpInside)
        self.faceItem.addTarget(self, action: #selector(clickFaceItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.topTipImgView)
        self.view.addSubview(self.cardItem)
        self.view.addSubview(self.faceItem)
        self.view.addSubview(self.hScrollView)
        self.hScrollView.addSubview(self.cardBtn)
        self.hScrollView.addSubview(self.cardErrorImgView)
        self.hScrollView.addSubview(self.faceBtn)
        self.hScrollView.addSubview(self.faceErrorImgView)
    }

    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.topTipImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 2)
            make.centerX.equalToSuperview()
        }
        
        self.cardItem.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalTo(self.topTipImgView.snp.bottom).offset(PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: (ScreenWidth - PADDING_UNIT * 10) * 0.5, height: (ScreenWidth - PADDING_UNIT * 10) * 0.5 * 0.54))
        }
        
        self.faceItem.snp.makeConstraints { make in
            make.left.equalTo(self.cardItem.snp.right).offset(PADDING_UNIT * 2)
            make.top.size.equalTo(self.cardItem)
        }
        
        self.hScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.cardItem.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT * 5)
        }
        
        self.cardBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(PADDING_UNIT * 2)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 8)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 8, height: (ScreenWidth - PADDING_UNIT * 8) * 0.6))
        }
        
        self.cardErrorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(self.cardBtn)
            make.top.equalTo(self.cardBtn.snp.bottom).offset(PADDING_UNIT * 4)
        }
        
        self.faceBtn.snp.makeConstraints { make in
            make.left.equalTo(self.cardBtn.snp.right).offset(PADDING_UNIT * 8)
            make.top.size.equalTo(self.cardBtn)
        }
        
        self.faceErrorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(self.faceBtn)
            make.centerY.equalTo(self.cardErrorImgView)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        guard let _p_id = VCAPPCommonInfo.shared.productID else {
            return
        }
        
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/zorba", requestParams: ["despair": _p_id])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _dict = res.jsonDict, let _card_model = VCAPPCardModel.model(withJSON: _dict) else {
                return
            }
            
            self?._card_certification_model = _card_model
            self?.cardItem.reloadTitle(_card_model.id_front_msg)
            self?.faceItem.reloadTitle(_card_model.face_msg)
            
            if let _img_url = _card_model.scale?.stating, let _url = URL(string: _img_url) {
                self?.cardBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: .progressiveBlur)
            }
            
            if let _img_url = _card_model.opera?.stating, let _url = URL(string: _img_url) {
                self?.faceBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: .progressiveBlur)
            }
            
            if isAddingCashCode {
                for item in self?.temp_dict.allKeys() ?? [] {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
            
            if let _complete = _card_model.scale?.brokeback, _complete {
                self?.cardItem.setMenuItemImage("certification_card_complete")
            }
            
            if let _complete = _card_model.opera?.brokeback, _complete {
                self?.faceItem.setMenuItemImage("certification_card_complete")
            }
            
            self?._is_face = _card_model.scale?.brokeback ?? false
        }
    }
    
    override func clickNextButton(sender: VCAPPLoadingButton) {
        
        guard let _cardModel = self._card_certification_model else {
            return
        }
        
        if let _card_complete = _cardModel.scale?.brokeback, !_card_complete {
            self.clickCardButton(sender: self.cardBtn)
            return
        }
        
        if isAddingCashCode {
            for item in self.temp_dict.allKeys() {
                if item.jk.isPureInt {
                    print("------- is pure int ---------")
                } else if item.jk.isVideoUrl {
                    print("------- 视频链接 --------")
                } else if item.jk.isValidFileUrl {
                    print(" --------- 文件地址 ----------")
                } else {
                    print("-------- is nothing ----------")
                }
            }
        }
        
        if let _face_complete = _cardModel.opera?.brokeback, !_face_complete {
            self.clickFaceButton(sender: self.faceBtn)
            return
        }
        
        super.clickNextButton(sender: sender)
    }
}

private extension VCAPPLoanIDCardViewController {
    func takePhotoWithDeviceCamera(_ isFront: Bool) {
        VCAPPAuthorizationTool.authorization().requestDeviceCameraAuthrization {[weak self] (auth: Bool) in
            if !auth {
                self?.showSystemStyleSettingAlert(content: VCAPPLanguageTool.localAPPLanguage("alert_camera"))
                return
            }
            
            if isAddingCashCode {
                for item in self?.temp_dict.allKeys() ?? [] {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
            
            // 获取位置信息
            self?.reloadLocation()
            dispatch_async_on_main_queue {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let pickerController = UIImagePickerController()
                    pickerController.allowsEditing = false
                    pickerController.sourceType = .camera
                    pickerController.cameraDevice = isFront ? .front : .rear
                    pickerController.delegate = self
                    self?.navigationController?.present(pickerController, animated: true)
                }
            }
        }
    }
    
    func uploadFileToServer(_ filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            VCAPPCocoaLog.debug("------- 本地没有图片 ---------")
            return
        }
        
        self.view.makeToastActivity(CSToastPositionCenter)
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig("supervision/man", requestParams: ["doesTies": filePath, "ability": self._is_face ? "10" : "11"])
        config.requestType = .upload
        VCAPPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _self = self else {
                return
            }
            
            if isAddingCashCode {
                for item in self?.temp_dict.allKeys() ?? [] {
                    if item.jk.isPureInt {
                        print("------- is pure int ---------")
                    } else if item.jk.isVideoUrl {
                        print("------- 视频链接 --------")
                    } else if item.jk.isValidFileUrl {
                        print(" --------- 文件地址 ----------")
                    } else {
                        print("-------- is nothing ----------")
                    }
                }
            }
            
            _self.view.hideToastActivity()
            
            if _self._is_face {
                // 埋点
                VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_Face, beginTime: _self.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
                _self.navigationController?.popViewController(animated: true)
            } else {
                guard let _dict = res.jsonDict, let _infoModel = VCAPPCardInfoModel.model(withJSON: _dict) else {
                    return
                }

                if _infoModel.source {
                    VCAPPCardInfoPopView.convenienceShowPop(_self.view).reloadInfoPopView(_infoModel).didConfirmClousre = { (name: String?, idNum: String?, birthday: String?, action: VCAPPLoadingButton, popView: VCAPPCardInfoPopView) in
                        guard let _n = name, let _id = idNum, let _bir = birthday else {
                            return
                        }
                        
                        action.startAnimation()
                        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/greek", requestParams: ["chronicles": _n, "ability": "11", "gave": _id, "cinemascore": _bir])) { _, _ in
                            action.stopAnimation()
                            if isAddingCashCode {
                                for item in self?.temp_dict.allKeys() ?? [] {
                                    if item.jk.isPureInt {
                                        print("------- is pure int ---------")
                                    } else if item.jk.isVideoUrl {
                                        print("------- 视频链接 --------")
                                    } else if item.jk.isValidFileUrl {
                                        print(" --------- 文件地址 ----------")
                                    } else {
                                        print("-------- is nothing ----------")
                                    }
                                }
                            }
                            // 埋点
                            VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_TakingCardPhoto, beginTime: _self.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
                            _self._card_certification_model?.scale?.brokeback = true
                            _self._is_face = true
                            popView.dismissPop()
                        } failure: { _, _ in
                            action.stopAnimation()
                        }
                    }
                } else {
                    // 埋点
                    VCAPPBuryReport.VCClasJoskeRiskControlInfoReport(riskType: VCRiskControlBuryReportType.APP_TakingCardPhoto, beginTime: _self.buryReportBeginTime, endTime: Date().jk.dateToTimeStamp())
                    _self._card_certification_model?.scale?.brokeback = true
                    _self._is_face = true
                }
                
                if let _img_url = _infoModel.stating, let _url = URL(string: _img_url) {
                    _self.cardBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: .progressiveBlur)
                    _self.cardItem.setMenuItemImage("certification_card_complete")
                }
            }
        } failure: { [weak self] _, _ in
            self?.view.hideToastActivity()
        }
    }
}

extension VCAPPLoanIDCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImg: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let compress_img_data = originalImg.jk.compressDataSize(maxSize: 1024*1024)
        let _filePath = self._is_face ? VCAPPCommonInfo.shared.saveFaceImgPath : VCAPPCommonInfo.shared.saveCardImgPath
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: _filePath) as URL)
        self.uploadFileToServer(_filePath)
        picker.dismiss(animated: true)
    }
}

@objc private extension VCAPPLoanIDCardViewController {
    func clickCardItem(sender: VCAPPOrderMenuItem) {
        
        if let _complete = self._card_certification_model?.scale?.brokeback, _complete {
            sender.setMenuItemImage("certification_card_complete")
        } else {
            sender.isSelected = true
        }
        
        if isAddingCashCode {
            for item in self.temp_dict.allKeys() {
                if item.jk.isPureInt {
                    print("------- is pure int ---------")
                } else if item.jk.isVideoUrl {
                    print("------- 视频链接 --------")
                } else if item.jk.isValidFileUrl {
                    print(" --------- 文件地址 ----------")
                } else {
                    print("-------- is nothing ----------")
                }
            }
        }
        
        if let _complete = self._card_certification_model?.opera?.brokeback, _complete {
            self.faceItem.setMenuItemImage("certification_card_complete")
        } else {
            self.faceItem.isSelected = !sender.isSelected
        }
        
        self.hScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func clickFaceItem(sender: VCAPPOrderMenuItem) {
        
        if let _complete = self._card_certification_model?.opera?.brokeback, _complete {
            sender.setMenuItemImage("certification_card_complete")
        } else {
            sender.isSelected = true
        }
        
        if isAddingCashCode {
            for item in self.temp_dict.allKeys() {
                if item.jk.isPureInt {
                    print("------- is pure int ---------")
                } else if item.jk.isVideoUrl {
                    print("------- 视频链接 --------")
                } else if item.jk.isValidFileUrl {
                    print(" --------- 文件地址 ----------")
                } else {
                    print("-------- is nothing ----------")
                }
            }
        }
        
        if let _complete = self._card_certification_model?.scale?.brokeback, _complete {
            self.cardItem.setMenuItemImage("certification_card_complete")
        } else {
            self.cardItem.isSelected = !sender.isSelected
        }
        
        self.hScrollView.setContentOffset(CGPoint(x: ScreenWidth, y: .zero), animated: true)
    }
    
    func clickCardButton(sender: UIButton) {
        guard let _card_model = self._card_certification_model else {
            return
        }
        
        if let _complete = _card_model.scale?.brokeback, _complete {
            return
        }
        
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        
        self.takePhotoWithDeviceCamera(false)
        
        if isAddingCashCode {
            for item in self.temp_dict.allKeys() {
                if item.jk.isPureInt {
                    print("------- is pure int ---------")
                } else if item.jk.isVideoUrl {
                    print("------- 视频链接 --------")
                } else if item.jk.isValidFileUrl {
                    print(" --------- 文件地址 ----------")
                } else {
                    print("-------- is nothing ----------")
                }
            }
        }
    }
    
    func clickFaceButton(sender: UIButton) {
        guard let _card_model = self._card_certification_model else {
            return
        }
    
        guard let _c_model = _card_model.scale, _c_model.brokeback else {
            self.view.makeToast(VCAPPLanguageTool.localAPPLanguage("alert_id_certification"))
            return
        }
        
        if let _complete = _card_model.opera?.brokeback, _complete {
            return
        }
        
        self.buryReportBeginTime = Date().jk.dateToTimeStamp()
        
        self.takePhotoWithDeviceCamera(true)
        
        if isAddingCashCode {
            for item in self.temp_dict.allKeys() {
                if item.jk.isPureInt {
                    print("------- is pure int ---------")
                } else if item.jk.isVideoUrl {
                    print("------- 视频链接 --------")
                } else if item.jk.isValidFileUrl {
                    print(" --------- 文件地址 ----------")
                } else {
                    print("-------- is nothing ----------")
                }
            }
        }
    }
}

public extension Dictionary {
    
    // MARK: 1.1、检查字典里面是否有某个 key
    /// 检查字典里面是否有某个 key
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    // MARK: 1.2、检验 Dictionary 中是否存在某个key的值
    /// 检验 Dictionary 中是否存在某个key的值
    /// - Parameter key: 待检验的 key
    /// - Returns: 检验结果的布尔值
    func hasValue(key: Key) -> Bool {
        return self[key] != nil
    }
    
    // MARK: 1.3、字典的key或者value组成的数组
    /// 字典的key或者value组成的数组
    /// - Parameter map: map
    /// - Returns: 数组
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    // MARK: 1.4、JSON字符串 -> 字典
    /// JsonString转为字典
    /// - Parameter json: JSON字符串
    /// - Returns: 字典
    static func jsonToDictionary(json: String) -> Dictionary<String, Any>? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary<String, Any> {
            return data
        } else {
            return nil
        }
    }
    
    // MARK: 1.5、字典 -> JSON字符串
    /// 字典转换为JSONString
    func toJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    // MARK: 1.6、字典里面所有的 key
    /// 字典里面所有的key
    /// - Returns: key 数组
    func allKeys() -> [Key] {
        /*
         shuffled：不会改变原数组，返回一个新的随机化的数组。  可以用于let 数组
         */
        return self.keys.shuffled()
    }
    
    // MARK: 1.7、字典里面所有的 value
    /// 字典里面所有的value
    /// - Returns: value 数组
    func allValues() -> [Value] {
        return self.values.shuffled()
    }
    
    // MARK: 1.8、设置value
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            // 如果传⼊ nil, 就删除现存的值。
            guard let value = newValue else {
                self[key] = nil
                return
            }
            // 如果类型不匹配，就忽略掉。
            guard let value2 = value as? Value else {
                return
            }
            self[key] = value2
        }
    }
    
    // MARK: 1.9、设置value
    /// 设置value
    /// - Parameters:
    ///   - keys: key链
    ///   - newValue: 新的value
    @discardableResult
    mutating func setValue(keys: [String], newValue: Any) -> Bool {
        guard keys.count > 1 else {
            guard keys.count == 1, let key = keys[0] as? Dictionary<Key, Value>.Keys.Element else {
                return false
            }
            self[key] = (newValue as! Value)
            return true
        }
        guard let key = keys[0] as? Dictionary<Key, Value>.Keys.Element, self.keys.contains(key), var value1 = self[key] as? [String: Any] else {
            return false
        }
        let result = Dictionary<String, Any>.value(keys: Array(keys[1..<keys.count]), oldValue: &value1, newValue: newValue)
        self[key] = (value1 as! Value)
        return result
    }
    
    /// 字典深层次设置value
    /// - Parameters:
    ///   - keys: key链
    ///   - oldValue: 字典
    ///   - newValue: 新的值
    @discardableResult
    private static func value(keys: [String], oldValue: inout [String: Any], newValue: Any) -> Bool {
        guard keys.count > 1 else {
            oldValue[keys[0]] = newValue
            return true
        }
        guard var value1 = oldValue[keys[0]] as? [String : Any] else { return false}
        let key = Array(keys[1..<keys.count])
        let result = value(keys: key, oldValue: &value1, newValue: newValue)
        oldValue[keys[0]] = value1
        return result
    }
}

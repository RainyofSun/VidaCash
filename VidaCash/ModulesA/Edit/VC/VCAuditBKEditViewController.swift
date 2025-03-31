//
//  VCAuditBKEditViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit
import TZImagePickerController

class VCAuditBKEditViewController: VCAPPBaseViewController {
    
    private lazy var continueBtn: VCAPPLoadingButton = VCAPPLoadingButton.buildVidaCashGradientLoadingButton("Continue", cornerRadius: 24)
    private lazy var switchControl: VCAuditBKEditSegmentView = VCAuditBKEditSegmentView(frame: CGRectZero)
    private lazy var expenseView: VCAuditBKNotepadRecordingView = VCAuditBKNotepadRecordingView(frame: CGRectZero, isExpense: true)
    private lazy var incomeView: VCAuditBKNotepadRecordingView = VCAuditBKNotepadRecordingView(frame: CGRectZero, isExpense: false)
    
    private var recordingModel: VCAuditBKBillDetailModel?
    private var expense_url: String?
    
    init(recordingModel model: VCAuditBKBillDetailModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.recordingModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.topImageView.image = UIImage(named: "bk_bill_top_image")
        self.switchControl.segmentDelegate = self
        
        self.navigationItem.titleView = self.switchControl
        self.contentView.backgroundColor = .clear
        self.contentView.contentSize = CGSize(width: ScreenWidth * 2, height: .zero)
        self.continueBtn.addTarget(self, action: #selector(clickContinueButton(sender: )), for: UIControl.Event.touchUpInside)
        self.contentView.isPagingEnabled = true
        self.contentView.showsVerticalScrollIndicator = false
        self.contentView.showsHorizontalScrollIndicator = false
        self.contentView.isScrollEnabled = false
        
        self.expenseView.noteDelegate = self
        self.incomeView.noteDelegate = self
        
        self.contentView.addSubview(self.expenseView)
        self.contentView.addSubview(self.incomeView)
        self.view.addSubview(self.continueBtn)
        
        if let _m = self.recordingModel {
            if _m.ability == 1 {
                self.expenseView.reloadRecordingModel(_m)
            }
            
            if _m.ability == 2 {
                self.incomeView.reloadRecordingModel(_m)
            }
            
            self.switchControl.switchSegmentControl(isExpense: _m.ability == 1)
        }
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view).offset(UIDevice.xp_vc_navigationFullHeight() + PADDING_UNIT * 4)
            make.bottom.equalTo(self.continueBtn.snp.top).offset(-PADDING_UNIT * 4)
        }
        
        self.expenseView.snp.makeConstraints { make in
            make.left.top.size.equalToSuperview()
        }
        
        self.incomeView.snp.makeConstraints { make in
            make.left.equalTo(self.expenseView.snp.right)
            make.top.size.equalTo(self.expenseView)
        }
        
        self.continueBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 5)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_safeDistanceBottom() - PADDING_UNIT)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        
        self.recordingTypeRequest(isExpense: self.switchControl.isExpense)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.pageRequest()
        
        self.expenseView.beginInput()
    }
}

private extension VCAuditBKEditViewController {
    func recordingTypeRequest(isExpense: Bool) {
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/ten", requestParams: ["postponed": isExpense ? "1" : "2"])) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _record_model = VCAuditBKRecordingGroupModel.model(withJSON: res.jsonDict ?? [:]), let _group = _record_model.star else {
                return
            }
            
            if isExpense {
                self?.expenseView.refreshCategory(_group)
            } else {
                self?.incomeView.refreshCategory(_group)
            }
        }
    }

    func takingPhotoWithDeviceCamera(_ isFront: Bool) {
        VCAPPAuthorizationTool.authorization().requestDeviceCameraAuthrization {[weak self] (auth: Bool) in
            if !auth {
                self?.showSystemStyleSettingAlert(content: "Authorize camera access to easily take ID card photos and have a convenient operation process.")
                return
            }
            
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
    
    func uploadLocalImageFileToServer(_ filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            VCAPPCocoaLog.debug("------- 本地没有图片 ---------")
            return
        }
        
        self.view.makeToastActivity(CSToastPositionCenter)
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig("supervision/such", requestParams: ["booking_image": filePath])
        config.requestType = .upload
        VCAPPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            guard let _self = self else {
                return
            }
            
            _self.view.hideToastActivity()
            if let _text_url = res.jsonDict?["prior"] as? String {
                self?.expenseView.attachmentView.refreshAddImage(filePath)
                self?.expense_url = _text_url
            }
        } failure: { [weak self] _, _ in
            self?.view.hideToastActivity()
        }
    }
    
    func showTZImagePicker() {
        VCAPPAuthorizationTool.authorization().requestDevicePhotoAuthrization(ReadAndWrite) { [weak self] (auth: Bool) in
            guard auth else {
                self?.showSystemStyleSettingAlert(content:"Grant album permission to conveniently select and upload identity photos and accelerate the application process")
                return
            }
            dispatch_async_on_main_queue {
                let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
                imagePickerVc?.allowPickingImage = true
                imagePickerVc?.allowTakeVideo = false
                imagePickerVc?.allowPickingGif = false
                imagePickerVc?.allowPickingVideo = false
                imagePickerVc?.allowCrop = true
                imagePickerVc?.cropRect = CGRect(x: 0, y: (ScreenHeight - ScreenWidth) * 0.5, width: ScreenWidth, height: ScreenWidth)
                imagePickerVc?.statusBarStyle = .lightContent
                imagePickerVc?.modalPresentationStyle = .fullScreen
                self?.present(imagePickerVc!, animated: true, completion: nil)
            }
        }
    }
}

extension VCAuditBKEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImg: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let compress_img_data = originalImg.jk.compressDataSize(maxSize: 1024 * 1024)
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: VCAPPCommonInfo.shared.saveMapImgPath) as URL)
        self.uploadLocalImageFileToServer(VCAPPCommonInfo.shared.saveMapImgPath)
        picker.dismiss(animated: true)
    }
}

// MARK: TZImagePickerControllerDelegate
extension VCAuditBKEditViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        guard let image = photos.first else {
            return
        }

        let compress_img_data = image.jk.compressDataSize(maxSize: 1024 * 1024)
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: VCAPPCommonInfo.shared.saveMapImgPath) as URL)
        self.uploadLocalImageFileToServer(VCAPPCommonInfo.shared.saveMapImgPath)
        picker.dismiss(animated: true)
    }
}

extension VCAuditBKEditViewController: AuditBKEditSegmentControlProtocol {
    func switchSegmentControl(isExpense: Bool) {
        self.recordingTypeRequest(isExpense: isExpense)
        isExpense ? self.contentView.setContentOffset(CGPointZero, animated: true) : self.contentView.setContentOffset(CGPoint(x: ScreenWidth, y: .zero), animated: true)
    }
}

extension VCAuditBKEditViewController: AuditBKNotepadRecordingProtocol {
    func notepadBecomeFirstResponseder(item: VCAuditBKRecordingItem, recodingView: VCAuditBKNotepadRecordingView) {
        self.view.endEditing(true)
        if item.recodingType == .AddAttachment {
            let popView: VCAuditBKPaymentCameraPopView = VCAuditBKPaymentCameraPopView(frame: CGRect(origin: CGPoint(x: .zero, y: ScreenHeight), size: UIScreen.main.bounds.size))
            self.view.addSubview(popView)
            popView.mediaClosure = {[weak self] (isCamera: Bool) in
                isCamera ? self?.takingPhotoWithDeviceCamera(false) : self?.showTZImagePicker()
            }
            
            popView.bk_showPop()
        }
        
        if item.recodingType == .Time {
            self.view.showTimePicker(pickerMode: .YMDHM) {(date: Date?) in
                let _time = date?.jk.toformatterTimeString(formatter: "yyyy/MM/dd HH:mm")
                recodingView.params["enough"] = _time
                item.refreshTextFiledText(_time)
            }
        }
    }
}

@objc private extension VCAuditBKEditViewController {
    func clickContinueButton(sender: VCAPPLoadingButton) {
        let params: NSMutableDictionary = NSMutableDictionary()
        if self.switchControl.isExpense {
            params.addEntries(from: self.expenseView.params)
            params["postponed"] = "1"
            params["involvement"] = self.expenseView.positionView.location
        } else {
            params.addEntries(from: self.incomeView.params)
            params["postponed"] = "2"
            params["involvement"] = self.incomeView.positionView.location
        }
        
        if let _id = self.recordingModel?.directorial {
            params["directorial"] = _id
        }
        
        params["prior"] = self.expense_url
        
        sender.startAnimation()
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/detail", requestParams: params as? [String : String])) {[weak self] (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            sender.stopAnimation()
            let popView: VCAuditBKSaveSuccessPopView = VCAuditBKSaveSuccessPopView(frame: CGRect(origin: CGPoint(x: .zero, y: ScreenHeight), size: UIScreen.main.bounds.size))
            self?.view.addSubview(popView)
            popView.closeClosure = { [weak self] _, _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            popView.bk_showPop()
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

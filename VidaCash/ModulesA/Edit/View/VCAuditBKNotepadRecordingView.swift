//
//  VCAuditBKNotepadRecordingView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

protocol AuditBKNotepadRecordingProtocol: AnyObject {
    func notepadBecomeFirstResponseder(item: VCAuditBKRecordingItem, recodingView: VCAuditBKNotepadRecordingView)
}

class VCAuditBKNotepadRecordingView: UIScrollView {
    
    weak open var noteDelegate: AuditBKNotepadRecordingProtocol?
    open var params: [String: String] = [:]
    
    private lazy var amountView: VCAuditBKRecordingItem = VCAuditBKRecordingItem(frame: CGRectZero, recordingType: NotepadRecordingType.Amount)
    private lazy var typologyView: VCAuditBKRecordingItem = VCAuditBKRecordingItem(frame: CGRectZero, recordingType: NotepadRecordingType.Typology)
    private lazy var descriptionView: VCAuditBKRecordingItem = VCAuditBKRecordingItem(frame: CGRectZero, recordingType: NotepadRecordingType.Description)
    private lazy var timeView: VCAuditBKRecordingItem = VCAuditBKRecordingItem(frame: CGRectZero, recordingType: NotepadRecordingType.Time)
    private(set) lazy var attachmentView: VCAuditBKRecordingItem = VCAuditBKRecordingItem(frame: CGRectZero, recordingType: NotepadRecordingType.AddAttachment)
    private(set) lazy var positionView: VCAuditBKRecordingPositionView = VCAuditBKRecordingPositionView(frame: CGRectZero)
    
    init(frame: CGRect, isExpense: Bool) {
        super.init(frame: frame)
        
        self.amountView.itemDelegate = self
        self.typologyView.itemDelegate = self
        self.descriptionView.itemDelegate = self
        self.timeView.itemDelegate = self
        self.attachmentView.itemDelegate = self
        
        self.addSubview(self.amountView)
        self.addSubview(self.typologyView)
        self.addSubview(self.descriptionView)
        self.addSubview(self.timeView)
        if isExpense {
            self.addSubview(self.attachmentView)
        }
        self.addSubview(self.positionView)
        
        self.amountView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT * 4)
        }
        
        self.typologyView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.amountView)
            make.top.equalTo(self.amountView.snp.bottom)
        }
        
        self.descriptionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.typologyView)
            make.top.equalTo(self.typologyView.snp.bottom)
        }
        
        self.timeView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.descriptionView)
            make.top.equalTo(self.descriptionView.snp.bottom)
        }
        
        if isExpense {
            self.attachmentView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.timeView)
                make.top.equalTo(self.timeView.snp.bottom)
            }
            
            self.positionView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.attachmentView)
                make.top.equalTo(self.attachmentView.snp.bottom)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        } else {
            self.positionView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.timeView)
                make.top.equalTo(self.timeView.snp.bottom)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func refreshCategory(_ models: [VCAuditBKRecordingTypeModel]) {
        self.typologyView.refreshRecording(models)
    }
    
    public func reloadRecordingModel(_ model: VCAuditBKBillDetailModel) {
        self.amountView.refreshTextFiledText(model.exudes)
        self.typologyView.refreshCategory(model.doing)
        self.descriptionView.refreshTextFiledText(model.narnia)
        self.timeView.refreshTextFiledText(model.duties)
        self.attachmentView.refreshAddImage(model.approached ?? "")
        
        self.params["artificial"] = model.exudes
        self.params["japan"] = model.doing
        self.params["shot"] = model.narnia
        self.params["involvement"] = model.interested
        self.params["enough"] = model.duties
        self.params["prior"] = model.approached
    }
    
    public func beginInput() {
        self.amountView.firstResponse()
    }
}

extension VCAuditBKNotepadRecordingView: AuditBKRecordingItemProtocol {
    func recordingItemBecomeFirstResponseder(item: VCAuditBKRecordingItem) {
        self.noteDelegate?.notepadBecomeFirstResponseder(item: item, recodingView: self)
    }
    
    func didEndEditing(item: VCAuditBKRecordingItem, text: String?) {
        if item.recodingType == .Amount {
            self.params["artificial"] = text
        }
        
        if item.recodingType == .Description {
            self.params["shot"] = text
        }
    }
    
    func didSelectedRecodingType(item: VCAuditBKRecordingItem, typeModel: VCAuditBKRecordingTypeModel) {
        self.params["japan"] = typeModel.doing
    }
}

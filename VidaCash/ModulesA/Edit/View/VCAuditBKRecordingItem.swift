//
//  VCAuditBKRecordingItem.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/20.
//

import UIKit

enum NotepadRecordingType: String {
    case Amount = "Amount"
    case Typology = "Typology"
    case Description = "Description"
    case Time = "Time"
    case AddAttachment = "Add attachment"
    
    func placeholderText() -> String {
        switch self {
        case .Amount:
            return "Please enter the amount"
        case .Typology:
            return ""
        case .Description:
            return "Please fill in the details"
        case .Time:
            return "Pease select"
        case .AddAttachment:
            return ""
        }
    }
}

protocol AuditBKRecordingItemProtocol: AnyObject {
    func recordingItemBecomeFirstResponseder(item: VCAuditBKRecordingItem)
    func didEndEditing(item: VCAuditBKRecordingItem, text: String?)
    func didSelectedRecodingType(item: VCAuditBKRecordingItem, typeModel: VCAuditBKRecordingTypeModel)
}

class VCAuditBKRecordingItem: UIView {
    
    open var recodingType: NotepadRecordingType = .Amount
    weak open var itemDelegate: AuditBKRecordingItemProtocol?
    
    private lazy var headerView: VCAuditBKCommonHeader = VCAuditBKCommonHeader(frame: CGRectZero)
    private lazy var textFiled: VCAPPNoActionTextFiled = VCAPPNoActionTextFiled.buildVidasdCashNormalTextFiled(placeHolder: NSAttributedString(string: self.recodingType.placeholderText(), attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#666666"), .font: UIFont.systemFont(ofSize: 14)]))
    
    private lazy var typeCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (ScreenWidth - PADDING_UNIT * 8 - PADDING_UNIT * 12)/4, height: 70)
        layout.minimumInteritemSpacing = PADDING_UNIT * 4
        layout.minimumLineSpacing = PADDING_UNIT * 4
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var addBtn: UIButton = {
        let view = UIButton.buildVidaNormalImageButton("bk_edit_add")
        view.corner(10).backgroundColor = PINK_COLOR_FFE9DD
        return view
    }()
    
    private lazy var closeBtn: UIButton = {
        let view = UIButton.buildVidaNormalImageButton("bk_image_delete")
        view.isHidden = true
        return view
    }()
    
    private var _type_models: [VCAuditBKRecordingTypeModel] = []
    private var _edit_recording_id: String?
    
    init(frame: CGRect, recordingType type: NotepadRecordingType) {
        super.init(frame: frame)
        self.recodingType = type
        
        self.headerView.reloadHeaderText(self.recodingType.rawValue)
        
        if type == .Amount {
            self.textFiled.keyboardType = .decimalPad
        }
        
        if type == .Description {
            self.textFiled.keyboardType = .default
        }
        
        self.backgroundColor = .white
        self.addSubview(self.headerView)
        
        self.headerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            if type == .Amount {
                make.top.equalToSuperview().offset(PADDING_UNIT * 4)
            } else {
                make.top.equalToSuperview().offset(PADDING_UNIT * 3.5)
            }
        }
        
        switch type {
        case .Amount, .Description:
            self.textFiled.delegate = self
            self.addSubview(self.textFiled)
        
            self.textFiled.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.headerView).inset(PADDING_UNIT * 4)
                make.top.equalTo(self.headerView.snp.bottom).offset(PADDING_UNIT * 2)
                make.height.equalTo(54)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
            
        case .Typology:
            self.typeCollectionView.delegate = self
            self.typeCollectionView.dataSource = self
            self.typeCollectionView.register(VCAuditBKRecordingTypeCell.self, forCellWithReuseIdentifier: VCAuditBKRecordingTypeCell.className())
            self.addSubview(self.typeCollectionView)
            
            self.typeCollectionView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.headerView).inset(PADDING_UNIT * 4)
                make.top.equalTo(self.headerView.snp.bottom).offset(PADDING_UNIT * 2)
                make.height.equalTo(160)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        case .Time:
            let imgView: UIImageView = UIImageView(image: UIImage(named: "bk_edit_arrow"))
            self.textFiled.rightView = imgView
            self.textFiled.rightViewMode = .always
            self.textFiled.delegate = self
            self.addSubview(self.textFiled)
            
            self.textFiled.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.headerView).inset(PADDING_UNIT * 4)
                make.top.equalTo(self.headerView.snp.bottom).offset(PADDING_UNIT * 2)
                make.height.equalTo(54)
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        case .AddAttachment:
            self.addBtn.addTarget(self, action: #selector(clickAddButton(sender: )), for: UIControl.Event.touchUpInside)
            self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
            
            self.addBtn.addSubview(self.closeBtn)
            self.addSubview(self.addBtn)
            
            self.closeBtn.snp.makeConstraints { make in
                make.right.top.equalToSuperview()
            }
            
            self.addBtn.snp.makeConstraints { make in
                make.left.equalTo(self.headerView).offset(PADDING_UNIT * 4)
                make.top.equalTo(self.headerView.snp.bottom).offset(PADDING_UNIT * 2)
                make.size.equalTo(CGSize(width: 120, height: 90))
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.recodingType == .Amount {
            self.jk.addCorner(conrners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    /// 刷新记账类型
    public func refreshRecording(_ model: [VCAuditBKRecordingTypeModel]) {
        if !self._type_models.isEmpty {
            return
        }
        
        self._type_models.append(contentsOf: model)
        
        self.typeCollectionView.reloadData()
        
        if let _c_id = self._edit_recording_id, let _index = self._type_models.firstIndex(where: {$0.doing == _c_id}) {
            self.typeCollectionView.selectItem(at: IndexPath(item: _index, section: .zero), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
    }
    
    /// 刷新文案
    public func refreshTextFiledText(_ text: String?) {
        if let _t = text {
            self.textFiled.text = _t
        }
    }
    
    /// 刷新图片
    public func refreshAddImage(_ imageUrl: String) {
        UIView.animate(withDuration: 0.3) {
            self.closeBtn.isHidden = false
        }
        self.addBtn.setImage(nil, for: UIControl.State.normal)
        if imageUrl.hasPrefix("http") {
            if let _url = URL(string: imageUrl) {
                self.addBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: YYWebImageOptions.setImageWithFadeAnimation)
            }
        } else {
            self.addBtn.setBackgroundImage(UIImage(contentsOfFile: imageUrl), for: UIControl.State.normal)
        }
    }
    
    /// 刷新选中的分类
    public func refreshCategory(_ categoryID: String?) {
        self._edit_recording_id = categoryID
    }
    
    /// 获取焦点
    public func firstResponse() {
        if self.textFiled.canBecomeFirstResponder {
            self.textFiled.becomeFirstResponder()
        }
    }
}

extension VCAuditBKRecordingItem: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._type_models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCAuditBKRecordingTypeCell.className(), for: indexPath) as? VCAuditBKRecordingTypeCell else {
            return UICollectionViewCell()
        }
        
        _cell.reloadCellModel(self._type_models[indexPath.item])
        
        return _cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _cell = collectionView.cellForItem(at: indexPath) as? VCAuditBKRecordingTypeCell else {
            return
        }
        
        _cell.isSelected = true
        self.itemDelegate?.didSelectedRecodingType(item: self, typeModel: self._type_models[indexPath.item])
    }
}

extension VCAuditBKRecordingItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.itemDelegate?.recordingItemBecomeFirstResponseder(item: self)
        return self.recodingType == .Amount || self.recodingType == .Description
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.itemDelegate?.didEndEditing(item: self, text: textField.text)
    }
}

@objc private extension VCAuditBKRecordingItem {
    func clickAddButton(sender: UIButton) {
        self.itemDelegate?.recordingItemBecomeFirstResponseder(item: self)
    }
    
    func clickCloseButton(sender: UIButton) {
        self.addBtn.setBackgroundImage(nil, for: UIControl.State.normal)
        self.addBtn.setImage(UIImage(named: "bk_edit_add"), for: UIControl.State.normal)
        UIView.animate(withDuration: 0.3) {
            sender.isHidden = true
        }
    }
}

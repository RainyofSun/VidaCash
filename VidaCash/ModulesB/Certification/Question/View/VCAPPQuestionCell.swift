//
//  VCAPPQuestionCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/7.
//

import UIKit

protocol APPQuestionCellProtocol: AnyObject {
    func didSelectedQuestionOptional(_ value: [String: String], cellIndexPath index: IndexPath?)
}

class VCAPPQuestionCell: UITableViewCell {

    weak open var cellDelegate: APPQuestionCellProtocol?
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: BLACK_COLOR_202020)
    private lazy var subContentView: UIView = UIView(frame: CGRectZero)
    private var cell_mark: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.subContentView)
        
        self.titleLab.textAlignment = .left
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 6)
            make.top.equalToSuperview().offset(PADDING_UNIT * 3)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadCellModel(_ model: VCAPPQuestionModel, cellIndexPath indexPath: IndexPath) {
        self.titleLab.text = "\(indexPath.row + 1). " + (model.endows ?? "")
        self.cell_mark = indexPath
        
        var _selected_index: String = ""
        if let _back = model.greater, !_back.isEmpty {
            _selected_index = _back
        }
        
        if self.subContentView.subviews.count >= 2 {
            self.refreshQuestionItem(_selected_index)
        } else {
            if let _choise = model.narnia {
                self.buildQuestionItem(_choise, selectedIndex: _selected_index, keyString: model.canceled)
            }
        }
    }
}

private extension VCAPPQuestionCell {
    func refreshQuestionItem(_ selectedIndex: String) {
        for item in self.subContentView.subviews {
            if let _optional = item as? VCAPPQuestionOptionalView, let _sel_tag = _optional.selectedTag {
                _optional.isSelected = _sel_tag == selectedIndex
                break
            }
        }
    }
    
    func buildQuestionItem(_ questionModels: [VCAPPQuestionChoiseModel], selectedIndex: String, keyString key: String?) {
        var _top_item: VCAPPQuestionOptionalView?
        
        questionModels.enumerated().forEach { (idx: Int, item: VCAPPQuestionChoiseModel) in
            let view = VCAPPQuestionOptionalView(frame: CGRectZero)
            if let _k = key {
                view.optionalDict[_k] = item.ability
            }
            view.titleLab.text = item.chronicles
            view.selectedTag = item.ability
            
            if selectedIndex.isEmpty {
                view.isSelected = false
            } else {
                view.isSelected = selectedIndex == item.ability
            }
            
            view.addTarget(self, action: #selector(clickQuestionItem(sender: )), for: UIControl.Event.touchUpInside)
            
            self.subContentView.addSubview(view)
            
            if let _top = _top_item {
                if idx == questionModels.count - 1 {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(PADDING_UNIT * 2)
                        make.bottom.equalToSuperview()
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(PADDING_UNIT * 2)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview()
                    make.top.equalToSuperview().offset(PADDING_UNIT * 2)
                }
            }
            
            _top_item = view
        }
    }
}

@objc private extension VCAPPQuestionCell {
    func clickQuestionItem(sender: VCAPPQuestionOptionalView) {
        for item in self.subContentView.subviews {
            if let _optional = item as? VCAPPQuestionOptionalView, _optional.isSelected {
                _optional.isSelected = false
                break
            }
        }
        
        sender.isSelected = !sender.isSelected
        
        self.cellDelegate?.didSelectedQuestionOptional(sender.optionalDict, cellIndexPath: self.cell_mark)
    }
}

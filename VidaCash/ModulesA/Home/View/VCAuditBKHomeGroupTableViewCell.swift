//
//  VCAuditBKHomeGroupTableViewCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/19.
//

import UIKit

class VCAuditBKHomeGroupTableViewCell: UITableViewCell {

    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.corner(14).backgroundColor = PINK_COLOR_FFE9DD
        return view
    }()
    
    private lazy var logoImgView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        return view.corner(25)
    }()
    
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    private lazy var amountLab: UILabel = UILabel.buildVdidaCashNormalLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.titleLab.textAlignment = .left
        self.amountLab.textAlignment = .right
        
        self.contentView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.logoImgView)
        self.subContentView.addSubview(self.titleLab)
        self.subContentView.addSubview(self.amountLab)
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 1.25)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoImgView)
            make.left.equalTo(self.logoImgView.snp.right).offset(PADDING_UNIT * 2)
        }
        
        self.amountLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoImgView)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadBKTableCell(_ model: VCAuditBKHomeSectionModel) {
        if let _text_url = model.annie, let _url = URL(string: _text_url) {
            self.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        if let _s = model.scorefor {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: (_s + "\n"), attributes: [.foregroundColor: BLACK_COLOR_0B0A0A, .font: UIFont.systemFont(ofSize: 16), .paragraphStyle: paraStyle])
            if let _note = model.narnia {
                attributeStr.append(NSAttributedString(string: _note, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            }
            
            self.titleLab.attributedText = attributeStr
        }
        
        if let _s = model.exudes {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: _s + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#00A86B"), .font: UIFont.boldSystemFont(ofSize: 18), .paragraphStyle: paraStyle])
            if let _note = model.produce {
                attributeStr.append(NSAttributedString(string: _note, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            }
            
            self.amountLab.attributedText = attributeStr
        }
    }
    
    public func reloadBKStatisticTableCell(_ model: VCAuditBKBillDetailModel) {
        if let _text_url = model.annie, let _url = URL(string: _text_url) {
            self.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        if let _s = model.scorefor {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: (_s + "\n"), attributes: [.foregroundColor: BLACK_COLOR_0B0A0A, .font: UIFont.systemFont(ofSize: 16), .paragraphStyle: paraStyle])
            if let _note = model.narnia {
                attributeStr.append(NSAttributedString(string: _note, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            }
            
            self.titleLab.attributedText = attributeStr
        }
        
        if let _s = model.exudes {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT
            let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: _s + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#00A86B"), .font: UIFont.boldSystemFont(ofSize: 18), .paragraphStyle: paraStyle])
            if let _note = model.produce {
                attributeStr.append(NSAttributedString(string: _note, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#595F67"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            }
            
            self.amountLab.attributedText = attributeStr
        }
    }
}

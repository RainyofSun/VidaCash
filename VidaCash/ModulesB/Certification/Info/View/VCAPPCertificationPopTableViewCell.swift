//
//  VCAPPCertificationPopTableViewCell.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/2/8.
//

import UIKit

class VCAPPCertificationPopTableViewCell: UITableViewCell {

    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "certification_pop_img"))
    private lazy var titleLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), labelColor: BLACK_COLOR_202020)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(self.bgImgView)
        self.contentView.addSubview(self.titleLab)
        
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.bgImgView.isHidden = !selected
        self.titleLab.textColor = selected ? RED_COLOR_F21915 : BLACK_COLOR_202020
    }
    
    public func reloadTitle(_ title: String?) {
        self.titleLab.text = title
    }
}

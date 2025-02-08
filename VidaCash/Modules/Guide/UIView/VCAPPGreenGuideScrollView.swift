//
//  VCAPPGreenGuideScrollView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPGreenGuideScrollView: UIScrollView {

    private lazy var firstImgView: UIImageView = UIImageView(image: UIImage(named: "green_guide_1_1"))
    private lazy var firstLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondImgView: UIImageView = UIImageView(image: UIImage(named: "green_guide_1_2"))
    private lazy var secondLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        view.textAlignment = .center
        return view
    }()
    
    private lazy var thirdImgView: UIImageView = UIImageView(image: UIImage(named: "green_guide_1_3"))
    private lazy var thirdLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentSize = CGSize(width: ScreenWidth * 3, height: 0)
        self.showsHorizontalScrollIndicator = false
        self.alpha = .zero
        self.isPagingEnabled = true
        self.isScrollEnabled = false
        
        self.addSubview(self.firstImgView)
        self.firstImgView.addSubview(self.firstLab)
        self.addSubview(self.secondImgView)
        self.secondImgView.addSubview(self.secondLab)
        self.addSubview(self.thirdImgView)
        self.thirdImgView.addSubview(self.thirdLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func layoutGuideScrollView(dependView: UIView) {
        self.firstImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(UIScreen.main.bounds.size)
        }
        
        self.firstLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 7)
            make.bottom.equalTo(dependView.snp.top).offset(-PADDING_UNIT)
            make.height.greaterThanOrEqualTo(160)
        }
        
        self.secondImgView.snp.makeConstraints { make in
            make.top.size.equalTo(self.firstImgView)
            make.left.equalTo(self.firstImgView.snp.right)
        }
        
        self.secondLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 7)
            make.bottom.equalTo(self.firstLab)
            make.height.greaterThanOrEqualTo(160)
        }
        
        self.thirdImgView.snp.makeConstraints { make in
            make.top.size.equalTo(self.secondImgView)
            make.left.equalTo(self.secondImgView.snp.right)
        }
        
        self.thirdLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 7)
            make.bottom.equalTo(self.secondLab)
            make.height.greaterThanOrEqualTo(160)
        }
    }
    
    public func reloadGuideText() {
        self.firstLab.attributedText = NSAttributedString.attributeText1(VCAPPLanguageTool.localAPPLanguage("guide_title1"), text1Color: BLACK_COLOR_202020, text1Font: UIFont.specialFont(26), text2: VCAPPLanguageTool.localAPPLanguage("guide_content1"), text2Color: BLACK_COLOR_202020, text1Font: UIFont.systemFont(ofSize: 18), paramDistance: PADDING_UNIT * 6, paraAlign: .center)
        self.secondLab.attributedText = NSAttributedString.attributeText1(VCAPPLanguageTool.localAPPLanguage("guide_title2"), text1Color: BLACK_COLOR_202020, text1Font: UIFont.specialFont(26), text2: VCAPPLanguageTool.localAPPLanguage("guide_content2"), text2Color: BLACK_COLOR_202020, text1Font: UIFont.systemFont(ofSize: 18), paramDistance: PADDING_UNIT * 6, paraAlign: .center)
        
        let tempStr: NSMutableAttributedString = NSAttributedString.attributeText1(VCAPPLanguageTool.localAPPLanguage("guide_title1"), text1Color: BLACK_COLOR_202020, text1Font: UIFont.specialFont(26), text2: VCAPPLanguageTool.localAPPLanguage("guide_content3"), text2Color: BLACK_COLOR_202020, text1Font: UIFont.systemFont(ofSize: 18), paramDistance: PADDING_UNIT * 6, paraAlign: .center)
        tempStr.append(NSAttributedString.init(string: VCAPPLanguageTool.localAPPLanguage("guide_content4"), attributes: [.foregroundColor: BLUE_COLOR_2C65FE, .font: UIFont.specialFont(26)]))
        self.thirdLab.attributedText = tempStr
    }
}

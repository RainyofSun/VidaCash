//
//  VCAuditBKCornerTabbar.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/18.
//

import UIKit

class VCAuditBKCornerTabbar: VCAPPCustomTabbar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hexStringColor(hexString: "#232341")
        self.jk.addCorner(conrners: [.topLeft, .topRight], radius: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTabbarTitles(_ titles: [String]? = nil, barItemImages images:[String], barItemSelectedImages selectImages: [String]) {
        let item_width: CGFloat = UIScreen.main.bounds.width/CGFloat(images.count)
        let item_height: CGFloat = UIDevice.xp_vc_tabBarHeight()
        images.enumerated().forEach { (index: Int, image: String) in
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setImage(UIImage(named: image), for: UIControl.State.normal)
            button.setImage(UIImage(named: selectImages[index]), for: UIControl.State.selected)
            button.frame = CGRect(x: item_width * CGFloat(index), y: .zero, width: item_width, height: item_height)
            button.tag = 100 + index
            button.addTarget(self, action: #selector(clickTabbarItem(sender: )), for: UIControl.Event.touchUpInside)
            self.addSubview(button)
        }
    }
}

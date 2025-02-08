//
//  VCAPPCustomTabbar.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

protocol VCCustomTabbarProtocol: UITabBarController {
    /// 是否可以选中当前 Item
    func vc_canSelected(shouldSelectedIndex index: Int) -> Bool
    /// 选中当前 Item
    func vc_didSelctedItem(_ tabbar: VCAPPCustomTabbar, item: UIButton, index: Int)
}

class VCAPPCustomTabbar: UITabBar {
    
    weak open var barDelegate: VCCustomTabbarProtocol?
    
    private var original_size: CGSize?
    private let _top_y: CGFloat = 15
    private let _padding: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.original_size = frame.size
        
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let _size = self.original_size {
            return _size
        }
        
        return super.sizeThatFits(size)
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setTabbarTitles(_ titles: [String]? = nil, barItemImages images:[String], barItemSelectedImages selectImages: [String]) {
        let item_width: CGFloat = (UIScreen.main.bounds.width - _padding * 2)/CGFloat(images.count)
        let item_height: CGFloat = UIDevice.xp_tabBarHeight()
        images.enumerated().forEach { (index: Int, image: String) in
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setTitle(titles?[index], for: UIControl.State.normal)
            button.setTitle(titles?[index], for: UIControl.State.highlighted)
            button.setTitleColor(UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1), for: UIControl.State.normal)
            button.setTitleColor(UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1), for: UIControl.State.highlighted)
            button.setImage(UIImage(named: image), for: UIControl.State.normal)
            button.setImage(UIImage(named: selectImages[index]), for: UIControl.State.selected)
            button.frame = CGRect(x: _padding + item_width * CGFloat(index), y: .zero, width: item_width, height: item_height)
            button.tag = 100 + index
            button.addTarget(self, action: #selector(clickTabbarItem(sender: )), for: UIControl.Event.touchUpInside)
            self.addSubview(button)
        }
    }
    
    /// 设置选中界面
    public func selectedTabbarItem(_ index: Int) {
        guard let _item = self.viewWithTag((100 + index)) as? UIButton else {
            return
        }
        self.reseButtonState()
        _item.isSelected = !_item.isSelected
    }
}

// MARK: Private Methods
private extension VCAPPCustomTabbar {
    func reseButtonState() {
        for item in self.subviews {
            if let _btn = item as? UIButton, _btn.tag >= 100 {
                if _btn.isSelected {
                    _btn.isSelected = false
                    break
                }
            }
        }
    }
}

// MARK: Target
@objc private extension VCAPPCustomTabbar {
    func clickTabbarItem(sender: UIButton) {
        if !(self.barDelegate?.vc_canSelected(shouldSelectedIndex: sender.tag - 100) ?? true) {
            return
        }
        self.reseButtonState()
        sender.isSelected = !sender.isSelected
        self.barDelegate?.vc_didSelctedItem(self, item: sender, index: sender.tag - 100)
    }
}

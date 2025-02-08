//
//  VCAPPTimerButton.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

import UIKit

class VCAPPTimerButton: UIControl {

    private lazy var titleLab: UILabel = UILabel.buildNormalLabel(font: UIFont.systemFont(ofSize: 15), labelColor: BLUE_COLOR_2C65FE, labelText: VCAPPLanguageTool.localAPPLanguage("login_timer_code_title"))
    private var system_timer: Timer?
    
    private var time_count: Int = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initData()
        
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT)
            make.width.greaterThanOrEqualTo(66)
            make.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let viwe = super.hitTest(point, with: event)
        
        return viwe
    }
    
    public func start() {
        if self.system_timer == nil {
            self.system_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCall(sender: )), userInfo: nil, repeats: true)
        }
    }
    
    public func stop() {
        if let _timer = self.system_timer {
            _timer.invalidate()
            self.system_timer = nil
        }
    }
}

private extension VCAPPTimerButton {
    func initData() {
#if DEBUG
        time_count = 5
#else
        time_count = 60
#endif
    }
}

@objc private extension VCAPPTimerButton {
    func timerCall(sender: Timer) {
        DispatchQueue.main.async(execute: {
            if self.time_count <= .zero {
                self.stop()
                self.titleLab.text = VCAPPLanguageTool.localAPPLanguage("login_timer_code_title")
                self.initData()
            } else {
                self.titleLab.text = "\(self.time_count)s"
                self.time_count -= 1
            }
        })
    }
}

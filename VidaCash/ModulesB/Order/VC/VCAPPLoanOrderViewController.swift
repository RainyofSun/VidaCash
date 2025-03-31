//
//  VCAPPLoanOrderViewController.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

import UIKit

class VCAPPLoanOrderViewController: VCAPPBaseViewController {

    private lazy var menuView: VCAPPOrderMenuView = VCAPPOrderMenuView(frame: CGRectZero)
    private lazy var orderApplyTable: VCAPPOrderTableView = VCAPPOrderTableView(frame: CGRectZero, style: UITableView.Style.plain)
    
    private var orderRepaymentTable: VCAPPOrderTableView?
    private var orderFinishTable: VCAPPOrderTableView?
    
    private var requestType: OrderRequestType = .Request_Apply
    
    override func buildViewUI() {
        super.buildViewUI()
        self.contentView.contentSize = CGSize(width: ScreenWidth * 3, height: 0)
        self.contentView.isScrollEnabled = false
        
        self.reloadLocation()
        self.title = VCAPPLanguageTool.localAPPLanguage("order_nav_title")
        
        self.menuView.menuDelegate = self
        self.orderApplyTable.selectedDelegate = self
        self.orderApplyTable.refreshDelegate = self
        
        self.view.addSubview(self.menuView)
        self.contentView.addSubview(self.orderApplyTable)
        
        if isAddingCashCode {
            let popView = PopView(colorType: PopViewColor.brown)
            popView.frame = CGRectZero
            popView.isHidden = true
            self.view.insertSubview(popView, at: .zero)
        }
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.menuView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_vc_tabBarFullHeight())
        }
        
        self.menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_vc_navigationFullHeight())
            make.horizontalEdges.equalToSuperview()
        }
        
        self.orderApplyTable.snp.makeConstraints { make in
            make.top.left.size.equalToSuperview()
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        switch self.menuView.selectedTag {
        case 1:
            self.orderApplyTable.refresh(begin: true)
        case 2:
            self.orderRepaymentTable?.refresh(begin: true)
        case 3:
            self.orderFinishTable?.refresh(begin: true)
        default:
            self.orderApplyTable.refresh(begin: true)
        }
    }
}

extension VCAPPLoanOrderViewController: APPOrderTableRefreshProtocol {
    func startRefreshOrderTable(table: VCAPPOrderTableView) {
        VCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("supervision/stating", requestParams: ["movie": self.requestType.rawValue])) { (task: URLSessionDataTask, res: VCAPPSuccessResponse) in
            table.refresh(begin: false)
            guard let _dict = res.jsonDict, let _model = VCAPPOrderModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _models = _model.star else {
                return
            }
            
            table.refreshOrderTableWithSource(data: _models)
        } failure: { _, _ in
            table.refresh(begin: false)
        }
    }
}

extension VCAPPLoanOrderViewController: APPOrderTableSelectedProtocol {
    func didSelectedOrderTableItem(orderItemModel: VCAPPOrderItemModel) {
        guard let _url = orderItemModel.adaption else {
            return
        }
        
        VCAPPPageRouter.shared().appPageRouter(_url, backToRoot: _url.hasPrefix("http"), targetVC: nil)
    }
}

extension VCAPPLoanOrderViewController: APPOrderMenuProtocol {
    func didSelectedMenu(request: OrderRequestType) {
        self.requestType = request
        if request == OrderRequestType.Request_Apply {
            self.contentView.setContentOffset(CGPoint.zero, animated: true)
            self.orderApplyTable.refresh(begin: true)
        } else if request == OrderRequestType.Request_Repayment {
            if self.orderRepaymentTable == nil {
                let view = VCAPPOrderTableView(frame: CGRect(x: ScreenWidth, y: 0, width: ScreenWidth, height: self.orderApplyTable.height), style: UITableView.Style.plain)
                self.contentView.addSubview(view)
                view.selectedDelegate = self
                view.refreshDelegate = self
                view.switchOrderTableAndRefresh()
                self.orderRepaymentTable = view
            } else {
                self.orderRepaymentTable?.startRefresh(refresh: true)
            }
            
            self.contentView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
        } else {
            if self.orderFinishTable == nil {
                let view = VCAPPOrderTableView(frame: CGRect(x: ScreenWidth * 2, y: 0, width: ScreenWidth, height: self.orderApplyTable.height), style: UITableView.Style.plain)
                self.contentView.addSubview(view)
                view.selectedDelegate = self
                view.refreshDelegate = self
                view.switchOrderTableAndRefresh()
                self.orderFinishTable = view
            } else {
                self.orderFinishTable?.startRefresh(refresh: true)
            }
            
            self.contentView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
        }
    }
}

enum PopViewColor {
    case white
    case pink
    case yellow
    case red
    case brown
}
class PopView: UIView {
    
    init(colorType : PopViewColor) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            
        }else {
            super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
        }
        
        isUserInteractionEnabled = false
        let color =  self.getColor(type: colorType)
        let bubble = Bubble(color: color)
        bubble.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        layer.addSublayer(bubble)
        bubble.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07, execute: {
            for number in 1...6 {
                let line = Line(color : color)
                line.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                line.transform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(6) * CGFloat(number), 0, 0, 1)
                self.layer.addSublayer(line)
                line.animate()
            }
        })
        
        let minOffset: UInt32 = 0
        let maxOffset: UInt32 = 200
        let rotation = CGFloat(arc4random_uniform(maxOffset - minOffset) + minOffset) / CGFloat(100)
        transform = CGAffineTransform(rotationAngle: rotation)
        
        //remove view after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.removeFromSuperview()
        })
    }
   
    func getColor (type : PopViewColor) -> String{
        if(type == .white){
            return "#ffffff"
        }else if (type == .yellow){
             return "#fff000"
        }else if (type == .pink){
             return "#dd1bf2"
        }else if (type == .red){
             return "#f7817e"
        }else if (type == .brown){
            return  "#8a5035"
        }
        return "#ffffff"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

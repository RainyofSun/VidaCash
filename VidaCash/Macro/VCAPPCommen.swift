//
//  VCAPPCommen.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/26.
//

import UIKit

// MARK: 通知
// 网络状态通知
public let APP_NET_STATE_CHANGE = "com.vc.notification.name.net.appNetState"

// MARK: H5交互函数：
/// 关闭当前Web
let CloseWebPage: String = "HisYork"
/// 页面带参数跳转
let PageTransitionNoParams: String = "OnTyler"
/// 页面带参数跳转
let PageTransitionWithParams: String = "TheHer"
/// 关闭当前页面回到首页
let CloseAndGotoHome: String = "RecountsThan"
/// 关闭当前页面回到个人中心
let CloseAndGotoMineCenter: String = "StudiesTo"
/// 清空页面栈，跳转登录
let CloseAndGotoLoginPage: String = "CambridgeThe"
/// 拨打电话
let Call: String = "ApplyAbusing"
/// App Store评分
let GotoAppStore: String = "WestoverLater"
/// 确认申请埋点
let ConfirmApplyBury: String = "ToReconnects"

let Dynamic_Domain_Name_URL: String = "https://mx01-dc.oss-us-west-1.aliyuncs.com/"
let Dynamic_Domain_Name_Path: String = "vida-cash/vch.json"

// MARK: Frame
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height

// MARK: Color
let BLUE_COLOR_037DFF: UIColor = UIColor.init(hexString:"#037DFF")!
let BLUE_COLOR_2C65FE: UIColor = UIColor.init(hexString:"#2C65FE")!
let CYAN_COLOR_56E1FE: UIColor = UIColor.init(hexString:"#56E1FE")!
let GRAY_COLOR_999999: UIColor = UIColor.init(hexString:"#999999")!
let BLACK_COLOR_202020: UIColor = UIColor.init(hexString:"#202020")!
let BLACK_COLOR_333333: UIColor = UIColor.init(hexString:"#333333")!
let BLACK_COLOR_0B0A0A: UIColor = UIColor.init(hexString:"#0B0A0A")!
let RED_COLOR_F21915: UIColor = UIColor.init(hexString:"#F21915")!
let PINK_COLOR_FFE9DD: UIColor = UIColor.init(hexString:"#FFE9DD")!
let PINK_COLOR_FE6826: UIColor = UIColor.init(hexString:"#FE6826")!

// MARK: 原声页面跳转
/// 设置页面
let APP_SETTING_PAGE: String = "v://id.ac.ash/later"
/// 首页
let APP_HOME_PAGE: String = "v://id.ac.ash/awards"
/// 登录
let APP_LOGIN_PAGE: String = "v://id.ac.ash/but"
/// 订单
let APP_ORDER_PAGE: String = "v://id.ac.ash/lying"
/// 产品详情
let APP_PRODUCT_DETAIL: String = "v://id.ac.ash/hardcover"
/// 金融统计
let APP_STATISTICS_PATH: String = "v://id.ac.ash/statistics"

// MARK: 输入类型
enum InputViewType: String {
    case Input_Text = "outsidea"
    case Input_Enum = "outsideb"
    case Input_Day = "outsidec"
    case Input_Tip = "outsided"
    case Input_City = "outsidee"
}

// 是否键入垃圾代码
let isAddingCashCode: Bool = true

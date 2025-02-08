//
//  VCAPPPageRouter.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPPageRouter.h"
#import "UIViewController+VCAPPControllerExtension.h"
#import "UIDevice+VCAPPDeviceExtension.h"
#import "VidaCash-Swift.h"
#import "URLMacroHeader.h"
#import "VCAPPCommonArgus.h"
#import <YYKit/NSString+YYAdd.h>

#pragma matk - 原生与H5页面对照
/// 设置页面
static NSString * const APP_SETTING_PATH = @"v://id.ac.ash/later";
/// 首页
static NSString * const APP_HOME_PATH = @"v://id.ac.ash/awards";
/// 登录
static NSString * const APP_LOGIN_PATH = @"v://id.ac.ash/but";
/// 订单
static NSString * const APP_ORDER_PATH = @"v://id.ac.ash/lying";
/// 产品详情
static NSString * const APP_PRODUCT_PATH = @"v://id.ac.ash/hardcover";

@implementation VCAPPPageRouter

+ (instancetype)shared {
    static VCAPPPageRouter *rout;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (rout == nil) {
            rout = [[VCAPPPageRouter alloc] init];
        }
    });
    
    return rout;
}

- (void)appPageRouter:(NSString *)url backToRoot:(BOOL)toRoot targetVC:(UIViewController *)target {
    UITabBarController *rootVC = (UITabBarController *)[UIDevice currentDevice].keyWindow.rootViewController;
    if (rootVC == nil) {
        return;
    }
    
    UIViewController *topVC = [rootVC topController];
    if ([url hasPrefix:@"http"]) {
        [topVC.navigationController pushViewController:[[VCAPPWebViewController alloc] initWithWebLinkURL:[VCAPPCommonArgus splicingCommonArgus:url] backToRoot:toRoot] animated:YES];
    } else {
        if ([url containsString:APP_SETTING_PATH]) {
            [topVC.navigationController pushViewController:[[VCAPPSettingViewController alloc] init] animated:YES];
        } else if ([url containsString:APP_HOME_PATH]) {
            [topVC.navigationController popToRootViewControllerAnimated:NO];
            rootVC.selectedIndex = 0;
        } else if ([url containsString:APP_LOGIN_PATH]) {
            // 登录失效.重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:(NSNotificationName)APP_LOGIN_EXPIRED_NOTIFICATION object:nil];
        } else if ([url containsString:APP_ORDER_PATH]) {
            [topVC.navigationController popToRootViewControllerAnimated:NO];
            rootVC.selectedIndex = 1;
        } else if ([url containsString:APP_PRODUCT_PATH]) {
            [topVC.navigationController pushViewController:[[VCAPPLoanProductViewController alloc] initWithLoanProductIDNumber:[self separateURLParameter:url]] animated:YES];
        } else {
            if (target != nil) {
                [topVC.navigationController pushViewController:target animated:YES];
            }
        }
    }
}

- (NSString *)separateURLParameter:(NSString *)url {
    NSString *paraStr = [url componentsSeparatedByString:@"?"].lastObject;
    return [paraStr componentsSeparatedByString:@"="].lastObject;
}

@end

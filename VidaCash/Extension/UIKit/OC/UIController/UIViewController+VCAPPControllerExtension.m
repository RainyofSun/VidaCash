//
//  UIViewController+VCAPPControllerExtension.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "UIViewController+VCAPPControllerExtension.h"
#import <YYKit/YYKitMacro.h>
#import "NSString+VCAPPStringExtension.h"
#import "VidaCash-Swift.h"

@implementation UIViewController (VCAPPControllerExtension)

- (UIViewController *)topController {
    UIViewController *presentVC = self.presentedViewController;
    if (presentVC != nil) {
        return presentVC.topController;
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self;
        return nav.visibleViewController.topController;
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)self;
        return tabVC.selectedViewController.topController;
    } else {
        return self;
    }
}

- (void)showSystemStyleSettingAlert:(NSString *)content okTitle:(NSString *)ok cancelTitle:(NSString *)cancel {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *okTitle = [NSString isEmpty:ok] ? [VCAPPLanguageTool localAPPLanguage:@"alert_sheet_ok"] : ok;
    NSString *cancelTitle = [NSString isEmpty:cancel] ? [VCAPPLanguageTool localAPPLanguage:@"alert_sheet_cancel"] : cancel;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    dispatch_async_on_main_queue(^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

@end

//
//  UIViewController+VCAPPControllerExtension.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (VCAPPControllerExtension)

- (UIViewController *)topController;
- (void)showSystemStyleSettingAlert:(NSString *)content okTitle:(NSString * _Nullable )ok cancelTitle:(NSString * _Nullable )cancel;

@end

NS_ASSUME_NONNULL_END

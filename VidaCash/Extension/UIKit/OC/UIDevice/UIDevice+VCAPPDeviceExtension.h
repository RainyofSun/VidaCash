//
//  UIDevice+VCAPPDeviceExtension.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (VCAPPDeviceExtension)

- (NSString *)readIDFVFormDeviceKeyChain;
- (UIWindowScene *)activeScene;
- (UIWindow *)keyWindow;

- (NSArray <NSString *>*)appBattery;
- (NSString *)getSIMCardInfo;
- (NSString *)getNetconnType;
- (NSArray<NSString *> *)getWiFiInfo;
- (NSString *)getIPAddress;
+ (NSDictionary *)getAppDiskSize;
+ (NSString *)getFreeMemory;
- (BOOL)getProxyStatus:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

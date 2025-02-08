//
//  UIDevice+VCAPPDeviceExtension.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "UIDevice+VCAPPDeviceExtension.h"
#import <YYKit/YYKeychain.h>
#import "NSString+VCAPPStringExtension.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <Reachability/Reachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/utsname.h>
#import <sys/mount.h>
#import <sys/statvfs.h>
#import <mach/mach.h>

#pragma mark - idfv key
#define VC_APP_IDFV_KEY    @"VC_APP_IDFV_KEY"

@implementation UIDevice (VCAPPDeviceExtension)

- (NSString *)readIDFVFormDeviceKeyChain {
    NSString *idfv = self.identifierForVendor.UUIDString;
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *keychainIDFA = [YYKeychain getPasswordForService:bundleID account:VC_APP_IDFV_KEY];
    if (![NSString isEmpty:keychainIDFA]) {
        return keychainIDFA;
    } else {
        if (![NSString isEmpty:idfv]) {
            [YYKeychain setPassword:idfv forService:bundleID account:VC_APP_IDFV_KEY];
            return idfv;
        }
    }
    
    return @"";
}

- (UIWindowScene *)activeScene {
    UIScene* scene = nil;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(connectedScenes)]) {
        NSSet<UIScene*> *scenes = [[UIApplication sharedApplication] connectedScenes];
        for (UIScene *tmpScene in scenes) {
            if (tmpScene.activationState == UISceneActivationStateForegroundActive) {
                scene = tmpScene;
                break;
            }
        }
    }
    
    return (UIWindowScene *)scene;
}

- (UIWindow *)keyWindow {
    UIWindowScene* scene = [self activeScene];
    
    if (scene) {
        return scene.windows.firstObject;
    } else {
        return [[UIApplication sharedApplication] keyWindow];
    }
}

- (NSArray<NSString *> *)appBattery {
    [self setBatteryMonitoringEnabled:YES];
    if ([self isBatteryMonitoringEnabled]) {
        float batteryLevel = [self batteryLevel];
        BOOL isCharge = self.batteryState == UIDeviceBatteryStateCharging || self.batteryState == UIDeviceBatteryStateFull ? YES : NO;
        return @[[NSString stringWithFormat:@"%ld", (long)(batteryLevel * 100)], [NSString stringWithFormat:@"%@", [NSNumber numberWithBool:isCharge]]];
    } else {
        return @[];
    }
}

/**
 #import <CoreTelephony/CTTelephonyNetworkInfo.h>
 #import <CoreTelephony/CTCarrier.h>
 sim卡信息
 */
- (NSString *)getSIMCardInfo {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = nil;
    NSString *radioType = nil;
    if (@available(iOS 12.1, *)) {
        if (info && [info respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
            
            NSDictionary *dic = [info serviceSubscriberCellularProviders];
            if (dic.allKeys.count) {
                carrier = [dic objectForKey:dic.allKeys[0]];
            }
        }
        
        if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            
            NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
            if (radioDic.allKeys.count) {
                radioType = [radioDic objectForKey:radioDic.allKeys[0]];
            }
        }
    } else {
        carrier = [info subscriberCellularProvider];
        radioType = [info currentRadioAccessTechnology];
    }
    
    //运营商可用
    BOOL use = carrier.allowsVOIP;
    //运营商名字
    NSString *name = carrier.carrierName;
    //ISO国家代码
    NSString *code = carrier.isoCountryCode;
    //移动国家代码
    NSString *mcc = [carrier mobileCountryCode];
    //移动网络代码
    NSString *mnc = [carrier mobileNetworkCode];
    return name;
}

- (NSString *)getNetconnType {

    NSString *netconnType = @"";

    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];

    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {

            netconnType = @"no network";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

            NSString *currentStatus = info.currentRadioAccessTechnology;

            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {

                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {

                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){

                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){

                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){

                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){

                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){

                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){

                netconnType = @"4G";
            }
        }
            break;

        default:
            break;
    }

    return netconnType;
}

- (NSArray<NSString *> *)getWiFiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            return @[info[(__bridge NSString *)kCNNetworkInfoKeySSID], info[(__bridge NSString *)kCNNetworkInfoKeyBSSID]];
        }
    }
    return nil;
}
 
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *interface;
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through all the interfaces until we find one that has an IPv4 address.
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (interface->ifa_addr->sa_family == AF_INET) { // AF_INET represents IPv4.
                // Check if interface is not lo0 (loopback)
                if ([[NSString stringWithUTF8String:interface->ifa_name] isEqualToString:@"lo0"]) {
                    continue;
                }
                
                // Get human readable IPv4 address
                struct sockaddr_in *addr = (struct sockaddr_in *)interface->ifa_addr;
                address = [NSString stringWithUTF8String:inet_ntoa(addr->sin_addr)];
                break;
            }
        }
        
        freeifaddrs(interfaces);
    }
    return address;
}

+ (NSDictionary *)getAppDiskSize {
    NSURL *fileURL = [NSURL fileURLWithPath:@"/private/var"];
    NSError *error = nil;

    // 获取磁盘资源的相关值
    NSDictionary *values = [fileURL resourceValuesForKeys:@[
        NSURLVolumeAvailableCapacityKey,
        NSURLVolumeAvailableCapacityForImportantUsageKey,
        NSURLVolumeAvailableCapacityForOpportunisticUsageKey,
        NSURLVolumeTotalCapacityKey
    ] error:&error];

    if (error) {
        NSLog(@"Error retrieving capacity: %@", error.localizedDescription);
        return @{@"availableCapacity": @"", @"usedCapacity": @"", @"totalCapacity": @""};
    }

    // 获取可用容量和总容量
    NSNumber *volumeAvailableCapacityForImportantUsage = values[NSURLVolumeAvailableCapacityForImportantUsageKey];
    NSNumber *volumeTotalCapacity = values[NSURLVolumeTotalCapacityKey];

    if (volumeAvailableCapacityForImportantUsage && volumeTotalCapacity) {
        // 使用字节数格式化器
        NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
        // 获取总容量并格式化为 GB
        NSString *totalCapacityString = [formatter stringFromByteCount:volumeTotalCapacity.longLongValue];
        // 获取可用容量并格式化为 GB
        NSString *availableCapacityString = [formatter stringFromByteCount:volumeAvailableCapacityForImportantUsage.longLongValue];

        return @{
            @"availableCapacity": [NSString stringWithFormat:@"%lld", volumeAvailableCapacityForImportantUsage.longLongValue],
            @"totalCapacity": [NSString stringWithFormat:@"%lld", volumeTotalCapacity.longLongValue]
        };
    }

    return @{@"availableCapacity": @"", @"totalCapacity": @""};
}

+ (NSString *)getFreeMemory {
//    // 获取当前设备的 VM 统计数据
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
//    host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &count);
//
//    // 计算空闲内存（以字节为单位）
//    return [NSString stringWithFormat:@"%lu", (vmStats.free_count * vm_page_size)];
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return @"内存查找失败";
    }
    long long availableMemorySize = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    return [NSString stringWithFormat:@"%lld", availableMemorySize];
}
@end

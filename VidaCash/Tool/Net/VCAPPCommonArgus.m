//
//  VCAPPCommonArgus.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPCommonArgus.h"
#import <YYKit/UIDevice+YYAdd.h>
#import "NSString+VCAPPStringExtension.h"
#import "UIDevice+VCAPPDeviceExtension.h"
#import "VidaCash-Swift.h"
#import "VCAPPAuthorizationTool.h"
#import <AdSupport/AdSupport.h>

@implementation VCAPPCommonArgus

+ (NSString *)splicingCommonArgus:(NSString *)requestUrl {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [[UIDevice currentDevice] machineModel];
    NSString *idfvStr = [[UIDevice currentDevice] readIDFVFormDeviceKeyChain];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *loginToken = VCAPPCommonInfo.shared.appLoginInfo.brought;
    NSString *IDFAStr = [[VCAPPAuthorizationTool authorization] ATTTrackingStatus] == ATTrackingManagerAuthorizationStatusAuthorized ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : @"";
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestUrl];
    NSMutableArray<NSURLQueryItem *>* url_components = [NSMutableArray array];
    if (![NSString isEmpty:appVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"leading" value:appVersion]];
    }
    
    if (![NSString isEmpty:deviceName]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"films" value:deviceName]];
    }
    
    if (![NSString isEmpty:idfvStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"miramax" value:idfvStr]];
    }
    
    if (![NSString isEmpty:systemVersion]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"distributors" value:systemVersion]];
    }
    
    if (![NSString isEmpty:loginToken]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"brought" value:loginToken]];
    }
    
    if (![NSString isEmpty:IDFAStr]) {
        [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"this" value:IDFAStr]];
    }
    
    [url_components addObject:[[NSURLQueryItem alloc] initWithName:@"atrocities" value:[NSString stringWithFormat:@"%ld", VCAPPCommonInfo.shared.countryCode]]];
    
    if ([requestUrl containsString:@"?"]) {
        NSArray<NSArray <NSString *>*>* argusArray = [self separamtionRequestURLParameter:requestUrl];
        if (argusArray.count != 0) {
            [argusArray enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [url_components addObject:[[NSURLQueryItem alloc] initWithName:obj.firstObject value:obj.lastObject]];
            }];
        }
    }
    
    components.queryItems = url_components;
    
    return [NSString isEmpty:components.URL.absoluteString] ? requestUrl : components.URL.absoluteString;
}

+ (NSArray<NSArray<NSString *> *>*)separamtionRequestURLParameter:(NSString *)requestURL {
    NSString *lastStr = [[requestURL componentsSeparatedByString:@"?"] lastObject];
    NSMutableArray<NSArray <NSString *>*>* argusArray = [NSMutableArray array];
    NSArray<NSString *>* params = [lastStr componentsSeparatedByString:@"&"];
    [params enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *>* tempArray = [obj componentsSeparatedByString:@"="];
        [argusArray addObject:tempArray];
    }];
    
    return argusArray;
}

@end

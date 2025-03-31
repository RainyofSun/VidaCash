//
//  URLMacroHeader.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#ifndef URLMacroHeader_h
#define URLMacroHeader_h

#import <UIKit/UIKit.h>
#import "VCAPPNetResponseModel.h"

#pragma mark - URL
#if DEBUG
static NSString * _Nullable const NET_REQUEST_BASE_URL = @"http://47.251.52.24:8415/scale";
#else
//static NSString * _Nullable const NET_REQUEST_BASE_URL = @"https://app.fintopia-lending.com/scale";
static NSString * _Nullable const NET_REQUEST_BASE_URL = @"http://47.251.52.24:8415/scale";
#endif

/*
    block 回调
 */
typedef void(^ _Nonnull SuccessCallBack)(NSURLSessionDataTask * _Nonnull task, VCAPPSuccessResponse * _Nonnull responseObject);
typedef void(^ _Nullable FailureCallBack)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);

/*
    登录态通知
 */
/// 登录状态失效
static NSString * _Nonnull const APP_LOGIN_EXPIRED_NOTIFICATION = @"com.mx.notification.name.login.expired";
/// 登录成功
static NSString * _Nonnull const APP_LOGIN_SUCCESS_NOTIFICATION = @"com.mx.notification.name.login.success";

#endif /* URLMacroHeader_h */

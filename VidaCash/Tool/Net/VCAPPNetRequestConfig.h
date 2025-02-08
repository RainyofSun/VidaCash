//
//  VCAPPNetRequestConfig.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCAPPNetRequestConfig : NSObject

/** 网络请求管理 */
@property (nonatomic,strong) AFHTTPSessionManager* manager;

+ (instancetype)requestConfig;
+ (void)reloadNetworkRequestURL;
- (void)updateNetworkRequestURL;

@end

NS_ASSUME_NONNULL_END

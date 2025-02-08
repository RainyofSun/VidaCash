//
//  VCAPPNetResponseModel.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPNetResponseModel.h"

@implementation VCAPPNetResponseModel

@end

@implementation VCAPPSuccessResponse



@end

@implementation NetworkRequestConfig

+ (instancetype)defaultRequestConfig:(NSString *)requestURL requestParams:(NSDictionary<NSString *,NSString *> *)params {
    NetworkRequestConfig *config = [[NetworkRequestConfig alloc] init];
    config.requestParams = params;
    config.requestURL = requestURL;
    config.requestType = AFNRequestType_Post;
    return config;
}

@end

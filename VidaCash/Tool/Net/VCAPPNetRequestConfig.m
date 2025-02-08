//
//  VCAPPNetRequestConfig.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPNetRequestConfig.h"
#import "VCAPPNetRequestURLConfig.h"

@implementation VCAPPNetRequestConfig

+ (instancetype)requestConfig {
    static VCAPPNetRequestConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [[VCAPPNetRequestConfig alloc] init];
        }
    });
    
    return config;
}

+ (void)reloadNetworkRequestURL {
    [[VCAPPNetRequestConfig requestConfig] updateNetworkRequestURL];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultConfig];
    }
    return self;
}

- (void)setDefaultConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.allowsCellularAccess = YES;
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[VCAPPNetRequestURLConfig urlConfig].networkRequestURL sessionConfiguration:config];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/png",@"image/jpeg",@"multipart/form-data", nil];
}

- (void)updateNetworkRequestURL {
    [self.manager.requestSerializer willChangeValueForKey:@"baseURL"];
    [self.manager setValue:[VCAPPNetRequestURLConfig urlConfig].networkRequestURL forKey:@"baseURL"];
    [self.manager.requestSerializer didChangeValueForKey:@"baseURL"];
}

@end

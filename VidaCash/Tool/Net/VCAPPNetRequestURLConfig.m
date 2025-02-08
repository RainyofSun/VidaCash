//
//  VCAPPNetRequestURLConfig.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPNetRequestURLConfig.h"
#import "NSString+VCAPPStringExtension.h"
#import "URLMacroHeader.h"

@interface VCAPPNetRequestURLConfig ()

@property (nonatomic, copy) NSString *requestDomainURL;
@property (nonatomic, strong) NSMutableArray<NSString *>* usedDomainURLs;

@end

@implementation VCAPPNetRequestURLConfig

+ (instancetype)urlConfig {
    static VCAPPNetRequestURLConfig *url;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (url == nil) {
            url = [[VCAPPNetRequestURLConfig alloc] init];
        }
    });
    
    return url;
}

+ (BOOL)reloadNetworkRequestDomainURL:(NSString *)url {
    return [[VCAPPNetRequestURLConfig urlConfig] setNewNetworkRequestDomainURL:url];
}

- (BOOL)setNewNetworkRequestDomainURL:(NSString *)url {
    if ([self.usedDomainURLs containsObject:url]) {
        return NO;
    }
    
    self.requestDomainURL = url;
    [self.usedDomainURLs addObject:url];
    NSLog(@"-------- 设置新的域名 = %@ success ---------", url);
    
    return YES;
}

- (NSURL *)networkRequestURL {
    if ([NSString isEmpty:self.requestDomainURL]) {
        return [NSURL URLWithString:NET_REQUEST_BASE_URL];
    }
    
    return [NSURL URLWithString:self.requestDomainURL];
}

- (NSMutableArray<NSString *> *)usedDomainURLs {
    if (!_usedDomainURLs) {
        _usedDomainURLs = [NSMutableArray array];
    }
    
    return _usedDomainURLs;
}

@end

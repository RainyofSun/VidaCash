//
//  VCAPPNetRequestURLConfig.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCAPPNetRequestURLConfig : NSObject

+ (instancetype)urlConfig;
+ (BOOL)reloadNetworkRequestDomainURL:(NSString *)url;

- (BOOL)setNewNetworkRequestDomainURL:(NSString *)url;
- (NSURL *)networkRequestURL;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+VCAPPStringExtension.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (VCAPPStringExtension)

+ (BOOL)isEmpty:(NSString *)str;
- (NSString *)maskPhoneNumber;

@end

NS_ASSUME_NONNULL_END

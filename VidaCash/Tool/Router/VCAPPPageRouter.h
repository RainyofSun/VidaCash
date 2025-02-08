//
//  VCAPPPageRouter.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCAPPPageRouter : NSObject

+ (instancetype)shared;

- (void)appPageRouter:(NSString *)url backToRoot:(BOOL)toRoot targetVC:(nullable UIViewController *)target;

@end

NS_ASSUME_NONNULL_END

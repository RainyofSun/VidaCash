//
//  VCAPPLocationTool.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCAPPLocationTool : NSObject

@property (nonatomic, strong) CLPlacemark *placeMark;
@property (nonatomic, strong) CLLocation *location;

+ (instancetype)location;
+ (NSArray <NSString *>*)deviceLocationInfo;
- (void)startDeviceLocation;
- (void)stopDeviceLocation;
- (void)requestDeviceLocation;

@end

NS_ASSUME_NONNULL_END

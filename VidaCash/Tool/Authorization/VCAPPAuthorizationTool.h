//
//  VCAPPAuthorizationTool.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NotDetermined,
    Restricted,
    Denied,
    Authorized,
    Limited,
    Disable
} VCAPPAuthorizationStatus;

typedef enum : NSUInteger {
    AddOnly,
    ReadAndWrite,
} VCAPPPhotoAccessLevel;

typedef enum : NSUInteger {
    WhenInUse,
    Always,
} VCAPPLocationAuthLevel;

@interface VCAPPAuthorizationTool : NSObject

@property (nonatomic, assign) BOOL phoneOpenLocation;

+ (instancetype)authorization;
- (VCAPPAuthorizationStatus)locationAuthorization;
- (ATTrackingManagerAuthorizationStatus)ATTTrackingStatus;

- (void)requestDevicePhotoAuthrization:(VCAPPPhotoAccessLevel)level completeHandler:(void(^)(BOOL status))handler;
- (void)requestDeviceCameraAuthrization:(void(^)(BOOL status))handler;
- (void)requestDeviceLocationAuthrization:(VCAPPLocationAuthLevel)level;
- (void)requestDeviceIDFAAuthrization:(void(^)(BOOL status))handler;

@end

NS_ASSUME_NONNULL_END

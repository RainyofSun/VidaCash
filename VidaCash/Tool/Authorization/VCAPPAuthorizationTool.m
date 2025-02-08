//
//  VCAPPAuthorizationTool.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPAuthorizationTool.h"
#import <Photos/Photos.h>

@interface VCAPPAuthorizationTool ()

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation VCAPPAuthorizationTool

+ (instancetype)authorization {
    static VCAPPAuthorizationTool *au;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (au == nil) {
            au = [[VCAPPAuthorizationTool alloc] init];
        }
    });
    
    return au;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isEndable = [CLLocationManager locationServicesEnabled];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phoneOpenLocation = isEndable;
            });
        });
    }
    return self;
}

- (VCAPPAuthorizationStatus)locationAuthorization {
    if (!self.phoneOpenLocation) {
        return Disable;
    }
    
    switch ([self.manager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
            return Denied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return Authorized;
        case kCLAuthorizationStatusRestricted:
            return Restricted;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return Limited;
        case kCLAuthorizationStatusNotDetermined:
            return NotDetermined;
        default:
            return Denied;
    }
}

- (ATTrackingManagerAuthorizationStatus)ATTTrackingStatus {
    return [ATTrackingManager trackingAuthorizationStatus];
}

- (void)requestDevicePhotoAuthrization:(VCAPPPhotoAccessLevel)level completeHandler:(void (^)(BOOL))handler {
    [PHPhotoLibrary requestAuthorizationForAccessLevel:level == AddOnly ? PHAccessLevelAddOnly : PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
        handler(status == PHAuthorizationStatusAuthorized);
    }];
}

- (void)requestDeviceCameraAuthrization:(void (^)(BOOL))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
}

- (void)requestDeviceLocationAuthrization:(VCAPPLocationAuthLevel)level {
    if (level == WhenInUse) {
        [self.manager requestWhenInUseAuthorization];
    } else {
        self.manager.allowsBackgroundLocationUpdates = YES;
        [self.manager requestAlwaysAuthorization];
    }
}

- (void)requestDeviceIDFAAuthrization:(void (^)(BOOL))handler {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        handler(status == ATTrackingManagerAuthorizationStatusAuthorized);
    }];
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
    }
    
    return _manager;
}

@end

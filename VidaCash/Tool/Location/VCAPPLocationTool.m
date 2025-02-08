//
//  VCAPPLocationTool.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPLocationTool.h"
#import "VCAPPAuthorizationTool.h"
#import "UIDevice+VCAPPDeviceExtension.h"
#import "VidaCash-Swift.h"
#import "UIViewController+VCAPPControllerExtension.h"

@interface VCAPPLocationTool ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation VCAPPLocationTool

+ (instancetype)location {
    static VCAPPLocationTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[VCAPPLocationTool alloc] init];
        }
    });
    
    return tool;
}

+ (NSArray<NSString *> *)deviceLocationInfo {
    return @[[NSString stringWithFormat:@"%f", [VCAPPLocationTool location].location.coordinate.latitude],[NSString stringWithFormat:@"%f", [VCAPPLocationTool location].location.coordinate.longitude]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = 0.01;
    }
    return self;
}

- (void)startDeviceLocation {
    if ([VCAPPAuthorizationTool authorization].phoneOpenLocation) {
        CLAuthorizationStatus status = [self.locationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            [[UIDevice currentDevice].keyWindow.rootViewController showSystemStyleSettingAlert:[VCAPPLanguageTool localAPPLanguage:@"alert_location"] okTitle:nil cancelTitle:nil];
            return;
        }
        
        [self.locationManager startUpdatingLocation];
    } else {
        if (![CLLocationManager locationServicesEnabled]) {
            [[UIDevice currentDevice].keyWindow.rootViewController showSystemStyleSettingAlert:[VCAPPLanguageTool localAPPLanguage:@"alert_location"] okTitle:nil cancelTitle:nil];
            return;
        }
        
        if ([[VCAPPAuthorizationTool authorization] locationAuthorization] == NotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)stopDeviceLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)requestDeviceLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)geocoderInfoForLocation:(CLLocation *)location {
    if (!VCAPPNetworkObserver.shared.netReachable) {
        return;
    }
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        weakSelf.placeMark = placemarks.firstObject;
        weakSelf.location = location;
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败了 --- %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location == nil) {
        return;
    }
    
    NSLog(@"------ 埋点定位 -- %f - %f", location.coordinate.latitude, location.coordinate.longitude);
    [self geocoderInfoForLocation:location];
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}
@end

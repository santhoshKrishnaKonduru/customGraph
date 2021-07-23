//
//  LocationManager.h
//  IU
//
//  Created by Bitcot Inc on 2/17/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class AppData;
@class AppDelegate;
@interface LocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocation *previousLocation;
@property (nonatomic,strong) id target;

+ (LocationManager*) sharedInstanceWithTarget:(id)target;
+ (LocationManager*)sharedInstance;
- (void)reset;
- (void)requestAuthorization;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)getCurrentLocation;
- (void)loadBackgroundMode;
- (CLAuthorizationStatus)locationAuthorizationStatus;
- (BOOL)isLocationStatusAuthorized;
- (BOOL)didAskLocationPermission;
+ (void)reset;
@end

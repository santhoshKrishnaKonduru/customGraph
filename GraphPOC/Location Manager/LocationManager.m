
//
//  LocationManager.m
//
//
//  Created by Bitcot Inc.
//
//

#import "LocationManager.h"

#define kLocationDenialNotification @"kLocationDenialNotification"
#define kLocationUpdateNotification @"LocationUpdateNotification"
#define kLocationUpdateErrorNotification @"LocationUpdateErroNotification"
#define kLocationStatusChangeNotification @"LocationStatusChangeNotification"
#define kPreviousLocationKey @"PreviousLocationKey"


#define kErrorLocationDenialMessage @"You have declined the permission to use location services, Please enable it from settings for better discovery of Mountains and Instructors around you"
#define kErrorLocationRestrictionMessage @"Application cannot use location services, due to active restrictions on location services. Please enable it from settings for better discovery of Mountains and Instructors around you"

static LocationManager *sharedLocationManager = nil;
@interface LocationManager ()
{
    CLLocationManager *clLocationManager;
    BOOL isBackgroundMode;
    BOOL deferUpdates;
}
@end

@implementation LocationManager

+ (LocationManager *)sharedInstanceWithTarget:(id)target{
    if (!sharedLocationManager) {
        sharedLocationManager = [[LocationManager alloc] init];
    }
    sharedLocationManager.target = target;
    return sharedLocationManager;
}

+ (LocationManager *)sharedInstance{
    if (!sharedLocationManager) {
        sharedLocationManager = [[LocationManager alloc] init];
    }
    return sharedLocationManager;
}

+ (void)reset{
    sharedLocationManager = nil;
}

- (id)init{
    if (self = [super init]) {
        clLocationManager = [[CLLocationManager alloc] init];
        clLocationManager.delegate = (id<CLLocationManagerDelegate>)self;
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([clLocationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            clLocationManager.allowsBackgroundLocationUpdates = YES;
        }
        clLocationManager.pausesLocationUpdatesAutomatically = NO;
        [self initialize];
        [self registerNotificiations];
    }
    return self;
}

- (void)initialize{
}

- (void)registerNotificiations{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)startUpdatingLocation{
    [clLocationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [clLocationManager stopUpdatingLocation];
}

- (void)getCurrentLocation{
    [self stopUpdatingLocation];
    clLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    clLocationManager.distanceFilter = kCLDistanceFilterNone;
    [clLocationManager requestAlwaysAuthorization];
    [clLocationManager startUpdatingLocation];
}

- (void)applicationEnterForeground{
    isBackgroundMode = false;
    [self stopUpdatingLocation];
    clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    clLocationManager.distanceFilter = kCLDistanceFilterNone;
    [clLocationManager startUpdatingLocation];
}

- (void)applicationEnterBackground{
    isBackgroundMode = true;
    [self loadBackgroundMode];
}

- (void)loadBackgroundMode{
    [self stopUpdatingLocation];
    clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    clLocationManager.distanceFilter = kCLDistanceFilterNone;
    [clLocationManager requestAlwaysAuthorization];
    [clLocationManager startUpdatingLocation];
}


- (CLAuthorizationStatus)locationAuthorizationStatus{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status;
}

- (BOOL)isLocationStatusAuthorized{
    CLAuthorizationStatus status = [self  locationAuthorizationStatus];
    return status == kCLAuthorizationStatusAuthorizedAlways;
}

- (BOOL)didAskLocationPermission{
    CLAuthorizationStatus status = [self  locationAuthorizationStatus];
    return !(status == kCLAuthorizationStatusNotDetermined);
}

- (void)requestAuthorization{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        if (hasAlwaysKey) {
            [clLocationManager requestAlwaysAuthorization];
        } else if (hasWhenInUseKey) {
            [clLocationManager requestWhenInUseAuthorization];
        } else {
            // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
            NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
        }
    }
    else if ([self isLocationStatusAuthorized]){
        [self getCurrentLocation];
    }
    else{
        switch (status) {
            case kCLAuthorizationStatusDenied:
            {
                NSString *message = kErrorLocationDenialMessage;
                [self postLocationUpdateNotification:false errorMsg:message location:nil];
            }
                break;
            case kCLAuthorizationStatusRestricted:{
                NSString *message = kErrorLocationRestrictionMessage;
                [self postLocationUpdateNotification:false errorMsg:message location:nil];
            }
                break;
            default:{
            }
                break;
        }
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            NSString *message = kErrorLocationDenialMessage;
            [self postLocationUpdateNotification:false errorMsg:message location:nil];
        }
            break;
        case kCLAuthorizationStatusRestricted:{
            NSString *message = kErrorLocationRestrictionMessage;
            [self postLocationUpdateNotification:false errorMsg:message location:nil];
        }
            break;
        default:{
            [clLocationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    deferUpdates = false;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError  *)error
{
    NSLog(@"locationManager didFailWithError: %@", error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            NSString *message = @"Please check your network connection.";
            [self postLocationUpdateNotification:false errorMsg:message location:nil];
        }
            break;
        case kCLErrorDenied:{
            NSString *message = kErrorLocationDenialMessage;
            [self postLocationUpdateNotification:false errorMsg:message location:nil];
        }
        break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        if(newLocation!=nil &&
           theAccuracy>0&&
           theAccuracy<100){
            self.currentLocation = newLocation;
            NSLog(@"didUpdateToLocation: %@", _currentLocation);
            if (isBackgroundMode) {

            }else{
                [self postLocationUpdateNotification:true errorMsg:@"" location:newLocation];
            }
        }
    }
}


#pragma mark - end
- (void)postDenialOfLocationServices{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:kLocationDenialNotification object:self userInfo:nil];
}

- (void)postLocationUpdateNotification:(BOOL)isSuccessful
                              errorMsg:(NSString*)errorMsg
                              location:(CLLocation *)location {
    
  //  AlamofireAPIResponse *response = [[AlamofireAPIResponse alloc] initWithResponse:location errorCode:0 errorMessage:errorMsg successful:isSuccessful];
    //NSDictionary* locationInfo = [NSDictionary dictionaryWithObjectsAndKeys:response,@"response", nil];
    //NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    //[nc postNotificationName:kLocationUpdateNotification object:self userInfo:locationInfo];
}
@end

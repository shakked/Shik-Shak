//
//  ZSSLocationQuerier.m
//  
//
//  Created by Zachary Shakked on 1/24/15.
//
//

#import "ZSSLocationQuerier.h"
#import <CoreLocation/CoreLocation.h>

@interface ZSSLocationQuerier () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ZSSLocationQuerier

+ (instancetype)sharedQuerier {
    
    static ZSSLocationQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        self.currentLocation = [locations lastObject];
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (CLLocation *)currentLocation {
    //if location was less than a second ago...
    [self.locationManager stopUpdatingLocation];
    return self.currentLocation;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self setUpLocationManager];
    }
    return self;
}

- (void)setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [self.locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [self.locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use [ZSSLocationQuerier sharedQuerier]"
                                 userInfo:nil];
    return nil;
}

@end

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
@property (nonatomic, copy) void (^locationFoundHandler)(CLLocation *location, NSError *);

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

- (void)findCurrentLocaitonWithCompletion:(void (^)(CLLocation *, NSError *))completionBlock {
    self.locationFoundHandler = completionBlock;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    if (self.locationFoundHandler) {
        self.locationFoundHandler(location, nil);
    }
    self.locationFoundHandler = nil;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.locationFoundHandler) {
        self.locationFoundHandler(nil, error);
    }
    self.locationFoundHandler = nil;
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

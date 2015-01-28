//
//  ZSSLocationQuerier.h
//  
//
//  Created by Zachary Shakked on 1/24/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZSSLocationQuerier : NSObject

+ (instancetype)sharedQuerier;

@property (nonatomic, strong) CLLocation *currentLocation;
- (void)findCurrentLocaitonWithCompletion:(void (^)(CLLocation *location, NSError *error))completionBlock;

@end

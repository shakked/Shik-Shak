//
//  ZSSDownloader.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZSSDownloader : NSObject

- (void)getShaksNear:(CLLocation *)location withCompletion:(void (^)(NSError *, NSArray *))completion;
+ (instancetype)sharedDownloader;

@end

//
//  ZSSCloudQuerier.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/25/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class ZSSShak;

@interface ZSSCloudQuerier : NSObject

- (void)getShaksNear:(CLLocation *)location withCompletion:(void (^)(NSError *, NSArray *))completion;
- (void)postShak:(ZSSShak *)shak withCompletion:(void (^)(NSError *, BOOL))completion;
+ (instancetype)sharedQuerier;

@end

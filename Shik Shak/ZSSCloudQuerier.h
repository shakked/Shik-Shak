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

- (void)getNewShaksWithCompletion:(void (^)(NSArray *, NSError *))completion;
- (void)getHotShaksWithCompletion:(void (^)(NSArray *, NSError *))completion;

- (void)postShak:(ZSSShak *)shak withCompletion:(void (^)(NSError *, BOOL))completion;
+ (instancetype)sharedQuerier;
- (void)testQuery;
@end
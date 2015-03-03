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
- (void)isUserBannedWithCompletion:(void (^)(BOOL, NSError *))completion;

- (void)postShak:(ZSSShak *)shak withCompletion:(void (^)(NSError *, BOOL))completion;
- (void)upvoteShakWithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion;
- (void)downvoteShakWithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion;

- (void)reportShakwithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion;

- (void)registerDeviceToken:(NSString *)deviceToken withCompletion:(void (^)(NSError *, BOOL))completion;
- (void)updateInstallationId:(NSString *)objectId withDevicetoken:(NSString *)deviceToken withCompletion:(void (^)(NSError *, BOOL))completion;
    
+ (instancetype)sharedQuerier;

@end

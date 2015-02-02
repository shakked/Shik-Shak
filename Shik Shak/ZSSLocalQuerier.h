//
//  ZSSLocalQuerier.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSSUser;
@class ZSSShak;
@interface ZSSLocalQuerier : NSObject

+ (instancetype)sharedQuerier;
- (BOOL)userExists;
- (ZSSShak *)localShakForCloudShak:(NSDictionary *)cloudShak;

- (ZSSUser *)currentUser;
- (NSArray *)shaks;

- (BOOL)didUpvoteShakWithObjectId:(NSString *)objectId;
- (BOOL)didDownvoteShakWithObjectId:(NSString *)objectId;
- (BOOL)shakIdExistsLocally:(NSString *)objectId;


@end

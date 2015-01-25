//
//  ZSSLocalStore.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSSUser;
@class ZSSShak;

@interface ZSSLocalStore : NSObject

+ (instancetype)sharedStore;
- (ZSSUser *)createUser;
- (ZSSShak *)createShak;
- (ZSSUser *)user;
- (NSArray *)shaks;
- (BOOL)saveCoreDataChanges;
- (void)logCoreDataStatus;
- (void)deleteUser:(ZSSUser *)user;
- (void)deleteShak:(ZSSShak *)shak;
- (void)deleteAllObjects;

@end
